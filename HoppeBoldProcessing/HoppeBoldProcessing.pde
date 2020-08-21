ArrayList<Mover> movers = new ArrayList<Mover>();
ArrayList<PVector> floorPoints = new ArrayList<PVector>();

int[][] colorArray = {{255,0,0},{0,255,0},{0,10,250},{255,255,0},{0,255,255}};

int lastMousePress = 0;

//                  x    y   w    h
int[] resetButtonData = {50, 50, 100, 30};
String resetButtonText = "Reset";

void setup() {
  size(600,600);
  //Generating the floor terrain
  generateFloor(10);
}

void generateFloor(int numOfPoints){
  float distBetweenPoints = width / numOfPoints;
  for (int xStep = 0; xStep < numOfPoints+1; xStep++){
    //The points will at max be a 1/4 up from the bottom.
    floorPoints.add(new PVector(xStep*distBetweenPoints, random(height-height/4, height)));
  }
}

void draw() {
  background(255);
  //UPDATE CYCLE
  collideMovers();
  //DRAW CYCLE
  drawFloor();
  drawResetButton();
  PVector wind = new PVector(0.01,0);
  // Make up two forces.
  PVector gravity = new PVector(0,0.1);

  //[full] Loop through all objects and apply both forces to each object.
  for (Mover mover : movers) {
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
  //[end]
    mover.checkEdges();
    mover.update();
    mover.display();
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

//The floor is drawn in the order the points appear in the arraylist. Therefore it is important to remember adding the points in the right order.
void drawFloor(){
  pushMatrix();
  //Therefore we iterate through all but the last object
  //We iterate indexwise since we need to know what the next point is.
  for (int i = 0; i < floorPoints.size()-1; i++){
    PVector p1 = floorPoints.get(i);
    PVector p2 = floorPoints.get(i+1);
    line(p1.x, p1.y, p2.x, p2.y);
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
  if ((mouseX > resetButtonData[0] && mouseX < resetButtonData[0]+resetButtonData[2]) && (mouseY > resetButtonData[1] && mouseY < resetButtonData[1]+resetButtonData[3])){
    movers = new ArrayList<Mover>();
  }
  else{
    //We check how long it has been since we spawned the last ball, if it has been long enough (0,5 s) we spawn a new one
    if(millis()-lastMousePress > 500){
      lastMousePress = millis();
      //Adding the new ball to the list of balls
      movers.add(new Mover(random(0.2,5),mouseX,mouseY));
      //We choice a random index of the random index of the color array.
      int randomIndex = (int) random(0,colorArray.length);
      //We take the last Mover object in movers and chage the color to the randomly chosen one above
      movers.get(movers.size()-1).c = colorArray[randomIndex];
    }
  }
}
