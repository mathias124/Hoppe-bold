ArrayList<Mover> movers = new ArrayList<Mover>();

ArrayList<PVector> floorPoints = new ArrayList<PVector>();

int[][] colorArray = {{255,0,0},{0,255,0},{0,10,250},{255,255,0},{0,255,255}};

int lastMousePress = 0;

PImage img;

//                       x   y   w    h
int[] resetButtonData = {50, 50, 100, 30};
String resetButtonText = "Reset";

void setup() {
  size(600,600);
  //Generating the floor terrain
  generateFloor(10);
  img = loadImage("pict.PNG");
}

void generateFloor(int numOfPoints){
  float distBetweenPoints = width / numOfPoints;
  for (int xStep = 0; xStep < numOfPoints+1; xStep++){
    //The points will at max be a 1/4 up from the bottom.
    floorPoints.add(new PVector(xStep*distBetweenPoints, random(height-height/4, height-height/8)));
  }
}

void draw() {
  collideMovers();
  //background(255);
  image(img,0,0);
  img.resize(600,600);
  drawFloor();
  drawResetButton();
  
  PVector wind = new PVector(0.01,0);
  PVector gravity = new PVector(0,0.1);
  //Loop through all objects and apply both forces to each object as well as calculating and applying the friction.
  for (Mover mover : movers) {
    collideFloor(mover);
    //Calculating the friction force
    float c = 0.01;
    PVector friction = mover.velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(c);
    
    //Applying the forces
    mover.applyForce(friction);
    mover.applyForce(wind);
    mover.applyForce(gravity);
    
    //Call nescesarry mover methods
    mover.checkEdges();
    mover.update();
    mover.display();
  }
  //We have to have a separate loop as you cannot remove an object in a for-each loop.
  for (int i = 0; i < movers.size(); i++){
    if (movers.get(i).alpha <= 10){
      //Check whether any of them should be deleted
      movers.remove(i);
      //We break so as to not remove the wrong object if there are multiple objects to be removed
      break;
    }
  }
}
void collideMovers(){
  //We have to have a nested loop with movers as our iterator as I couldn't be bothered to think about better time-complexities n^2 it is.
  for (Mover mover1 : movers){
    for (Mover mover2 : movers){
      if(mover1 != mover2){
        float distance = mover1.location.dist(mover2.location);
        if(distance <= mover1.r + mover2.r){
          PVector distVec = PVector.sub(mover2.location, mover1.location);
          //The result of the collision is that they go in opposite direction but with their previous velocities.
          //Velocity of mover1
          distVec.setMag(mover1.velocity.mag());
          mover1.velocity = distVec;
          //Velocity of mover 2
          distVec.setMag(mover2.velocity.mag());
          distVec.mult(-1);
          mover2.velocity.add(distVec);
        }
      }
    }
  }
}

void collideFloor(Mover mover){
  //We go through all but the last one
  for(int i = 0; i < floorPoints.size()-1; i++){
    PVector p1 = floorPoints.get(i);
    PVector p2 = floorPoints.get(i+1);
    if (p1.x <= mover.location.x && p2.x >= mover.location.x){
      float dx = p2.x-p1.x;
      float dy = p2.y-p1.y;
      //We calculate the y-coordinate of where the collision is supposed to happen from the balls x-coordinate and the two points
      float yCollision = (dy/dx * (mover.location.x - p1.x)) + p1.y;
      if (yCollision <= mover.location.y || yCollision <= mover.location.y + mover.velocity.y/2){
        PVector p1p2 = new PVector(dx, dy);
        mover.velocity.mult(-1);
        float angle = PVector.angleBetween(mover.velocity, p1p2);
        mover.velocity.rotate(PI-angle);
        mover.location.y = yCollision;
      }
      //THE COLLISION CHECK HAS BEEN DONE
      break;
    }
  
  }
}


//The floor is drawn in the order the points appear in the arraylist. Therefore it is important to remember adding the points in the right order.
void drawFloor(){
  pushMatrix();
    strokeWeight(0);
    //We draw three layers of mountains
    for(int a = 0; a < 45; a += 15 ){
      fill(150-a*2);
      //We draw a polygon through each of the points of the floor as well as the two bottom corners
      beginShape();
        //Left bottom corner
        vertex(0,height);
          //All other floorpoints
          for (PVector floorPoint : floorPoints){
            vertex(floorPoint.x, floorPoint.y+a*2);
          }
        //Right bottom corner
        vertex(width, height);
      endShape();
    }
  popMatrix();
}

void drawResetButton(){
  pushMatrix();
    fill(255, 0, 0);
    rect(resetButtonData[0], resetButtonData[1], resetButtonData[2], resetButtonData[3]);
    fill(255, 255, 255);
    textAlign(CENTER, CENTER);
    text(resetButtonText, resetButtonData[0]+resetButtonData[2]/2, resetButtonData[1]+resetButtonData[3]/2);
  popMatrix();
}

void mousePressed() {
  //If it clicks the reset button
  if ((mouseX > resetButtonData[0] && mouseX < resetButtonData[0]+resetButtonData[2]) && (mouseY > resetButtonData[1] && mouseY < resetButtonData[1]+resetButtonData[3])){
    movers.clear();
  }
  //If the press is anywhere but the button
  else{
    //We check how long it has been since we spawned the last ball, if it has been long enough (0,5 s) we spawn a new one
    //We also have to make sure that the user doesn't spawn a ball below the new floor
    if(millis()-lastMousePress > 500 && mouseY < height-height/4){
      lastMousePress = millis();
      //Adding the new ball to the list of balls
      movers.add(new Mover(random(1,6),mouseX,mouseY));
      //We choice a random index of the color array.
      int randomIndex = (int) random(0,colorArray.length);
      //We take the last Mover object in movers and chage the color to the randomly chosen one above
      movers.get(movers.size()-1).c = colorArray[randomIndex];
    }
  }
}
