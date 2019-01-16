Camera cam;
RayCastor rc;
Renderer render;
Player p;

void setup() {
  size(500, 500);
  /*Ray r = new Ray(0, 0, -.5, 1);
  println(r);
  r.grow();
  println(r);
  r.grow();
  println(r);
  r.grow();
  println(r);
  int x0 = 3, y0 = 3, x1 = 8, y1 = 16;
  cam = new Camera(0, 0, 0, 10); //@origin facing right, 10 rays
  Ray r2 = cam.nextRay();
  drawGrid(40);
  drawRay(40, r2);
  println(r2.perpWallDist());*/
  rc = new RayCastor(new Camera(0, 0, -radians(45), 100));
  rc.camera.rotate(HALF_PI);
  rc.beginCasting();
  render = new Renderer(rc);
  p = new Player(render);
}

void draw() {
  //background(0,0,0);
  //PImage[] buffer = rc.getBuffer();
  //imageMode(CENTER);
  //for(int i = 0; i < buffer.length; i++) {
  //  for(int j = 0; j < height/buffer.length; j++) {
  //    image(buffer[i], i*(height/buffer.length)+j, height/2);
  //  }
  //}
  render.render();
  //if(frameCount % 720 < 360) { //number of times draw has been called
  //  rc.camera.rotate(- PI/720);
  //} else {
  //  rc.camera.rotate(+ PI/720);
  //}
  rc.beginCasting();
}
//
void drawGrid(float scale) {
  background(0);
  stroke(255, 0, 0);
  for(int line = 0; line < max(width, height)/scale; line++) {
    line(line*scale, 0, line*scale, height); //vertical
    line(0, line*scale, width, line*scale); //horizontal
  }
}

void drawRay(int scale, Ray r) {
  println("Ray: " + r);
  fill(255);
  ellipseMode(CENTER);
  ellipse(240, 240, 5, 5);
  println("Pos: "+r.getPosX() + ", " + r.getPosY() + ", " + r.startY);
  ellipse(240+r.getPosX()*scale, 240-r.getPosY()*scale, 5, 5);
  text("Dir", 250+r.getPosX()*scale, 250-r.getPosY()*scale);
  for(int i = 0; i < 5; i++) {
    r.grow();
    println(i+") "+r.where());
    ellipse(240+r.getMapX()*scale + scale/2, 240-r.getMapY()*scale - scale/2, 5, 5);
    text(i+"", 250+r.getMapX()*scale + scale/2, 250-r.getMapY()*scale - scale/2);
  }
  stroke(150, 150, 255);
  float x = (float)r.startX, y = (float)r.startY;
  for(int step = 0; step < max(width, height)/(2*scale); step++) {
    line(240+x*scale, 240-y*scale, 240+(x+r.vector.x)*scale, 240-(y+r.vector.y)*scale);
    x += r.vector.x;
    y += r.vector.y;
  }
}

void keyReleased() {
  /*if(cam.hasNextRay()) {
    drawGrid(40);
    drawRay(40, cam.nextRay());
  }*/
  if (keyCode == UP) {
      println("up");
  } else if (keyCode == DOWN) {
      println("down");
  } else if (keyCode == RIGHT) {
      println("right");
  } else if (keyCode == LEFT) {
     println("left");
  }
  else if (key == ' ') {
  //  ((Door)render.rc.world.whatsThere(2, 1)).toggle();
    Solid entrance = render.rc.world.whatsThere(2, 1);
    if(entrance != null && entrance instanceof Door) ((Door)entrance).toggle();
  }
}

void keyPressed() {
  if(keyCode == UP) {
    p.forward();
  } else if(keyCode == DOWN) {
    p.backward();
  } else if(keyCode == LEFT) {
    p.turn(-1);
  } else if(keyCode == RIGHT) {
    p.turn(1);
  }
}