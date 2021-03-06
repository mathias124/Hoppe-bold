class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  float r;
  int[] c = {0,0,0};
  float alpha = 255;
  int amount_still = 0;
  
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
    //We check whether the mover is actually moving or pretty much standing still
    if (velocity.mag() <= 0.5){
      amount_still++;
    }else{
      //If it starts moving we reset the values
      amount_still = 0;
      alpha = 255;
    }
    //If it is standing still we make it increasingly more opaque
    if (amount_still >= 10){
      alpha -= 10;
    }
    //We draw the mover
    pushMatrix();
    stroke(0);
    fill(c[0],c[1],c[2], alpha);
    circle(location.x, location.y, r*2);
    fill(0);
    circle(location.x, location.y, 1);
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
  }
}
