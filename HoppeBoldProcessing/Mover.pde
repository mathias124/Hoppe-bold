class Mover {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  float r;
  int[] c = {0,0,0};
  
  Mover(float m, float x , float y) {
    mass = m;
    r = mass*8;
    location = new PVector(x,y);
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }

  void display() {
    pushMatrix();
    stroke(0);
    fill(c[0],c[1],c[2]);
    circle(location.x, location.y, r*2);
    popMatrix();
  }

  // Somewhat arbitrarily, we are deciding that an object bounces when it hits the edges of a window.
  void checkEdges() {
    if (location.x > width) {
      location.x = width;
      velocity.x *= -1;
    } else if (location.x < 0) {
      velocity.x *= -1;
      location.x = 0;
    }
    
    //Here we are going to have to check with which of the point intervals it may be colliding with.
    /*if (location.y > height) {
      // Even though we said we shouldn't touch location and velocity directly, there are some exceptions.
      // Here we are doing so as a quick and easy way to reverse the direction of our object when it reaches the edge.
      velocity.y *= -1;
      location.y = height;
    }*/
  }
}
