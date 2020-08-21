ArrayList<Mover> movers = new ArrayList<Mover>();
ArrayList<PVector> floorPoints = new ArrayList<PVector>();

int[][] colorArray = {{255,0,0},{0,255,0},{0,10,250},{255,255,0},{0,255,255}};

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
  
  drawFloor();
  
  PVector wind = new PVector(0.01,0);
  // Make up two forces.
  PVector gravity = new PVector(0,0.1);

  //[full] Loop through all objects and apply both forces to each object.
  for (Mover mover : movers) {
    mover.applyForce(wind);
    mover.applyForce(gravity);
  //[end]
    mover.update();
    mover.display();
    mover.checkEdges();
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

void mousePressed() {
  movers.add(new Mover(random(0.2,5),mouseX,mouseY));
  //We choice a random index of the random index of the color array.
  int randomIndex = (int) random(0,colorArray.length);
  //We take the last Mover object in movers and chage the color to the randomly chosen one above
  movers.get(movers.size()-1).c = colorArray[randomIndex];
}
