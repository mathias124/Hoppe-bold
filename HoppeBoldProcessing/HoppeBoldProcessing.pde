ArrayList<Mover> movers = new ArrayList<Mover>();

int[][] colorArray = {{255,0,0},{0,255,0},{0,10,250},{255,255,0},{0,255,255}};

void setup() {
  size(600,600);
  
}

void draw() {
  background(255);
  
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
void mousePressed() {
  
  movers.add(new Mover(random(0.2,5),mouseX,mouseY));
  //We choice a random index of the random index of the color array.
  int randomIndex = (int) random(0,colorArray.length);
  //We take the last Mover object in movers and chage the color to the randomly chosen one above
  movers.get(movers.size()-1).c = colorArray[randomIndex];
}
