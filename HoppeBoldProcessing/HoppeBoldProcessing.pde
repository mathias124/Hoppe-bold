ArrayList<Mover> movers = new ArrayList<Mover>();

void setup() {
  size(600,600);
  for (int i = 0; i < 20; i++) {
    // Initializing many Mover objects, all with random mass (and all starting at 0,0)
    movers.add(new Mover(random(0.1,5),random(0,600),random(0,600)));
  }
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
