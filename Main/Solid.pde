public class Solid{
  int xpos;
  int ypos;
  int sideLength;
  Texture texture;
  double opacity; //transparent or not 0-invisible 1-there

  public Solid(int x, int y, int side, Texture text){
    if (x <0 || y <0){
      throw new IllegalArgumentException("you cannot use negative coordinates");
    }
    else{
      xpos = x;
      ypos = y;
      sideLength = side;
      texture = text;
      opacity = 1;
    }
  }
  
  public Solid(int x, int y, double o, Texture tex) {
    if(x < 0 || y < 0)
      throw new IllegalArgumentException("you cannot use negative coordinates");
    xpos = x;
    ypos = y;
    sideLength = 3;
    texture = tex;
    opacity = o;
  }
  
  public PImage getStripe(float where, double distance, boolean dark){
    if(dark) return texture.copy().darker().getStripe(where, distance);
    return texture.getStripe(where, distance);
  }
  
  public int getSide(){
    return sideLength;
  }

  public int getX(){
    return xpos;
  }

  public int getY(){
    return ypos;
  }
}

public class Door extends Solid {
  int lastUpdate, status;
  float progress;
  boolean paused;
  public Door(int x, int y, int side, Texture tex) {
    super(x, y, side, tex);
    opacity = 0.9;
    lastUpdate = millis();
    status = 0; //0=closed, 1=opening, 2=open, 3=closing
    progress = 1.0; //0=open, 1=closed
    paused = false;
  }
  
  public PImage getStripe(float where, double distance, boolean dark) {
    PImage stripe = super.getStripe(where, distance, dark);
    update();
    int downShift = floor((1-progress)*stripe.height);
    if(downShift == 0) return stripe;
    stripe.loadPixels();
    for(int i = stripe.height-1; i >= 0; i--) {
      if(i > downShift) {
        stripe.pixels[i] = stripe.pixels[i - downShift];
      } else {
        stripe.pixels[i] = color(0, 0);
      }
    }
    //since raycastor checks alpha of top pixel, we make it opaque to make sure
    //it doesnt draw other stuff over the solid part of the door
    //128 means half opaque because while the door is opening the walls to either
    //side are partly visible so we allow them to render by not making it fully opaque
    if(status == 1 || status == 3) stripe.pixels[0] = color(0, 128);
    stripe.updatePixels();
    return stripe;
  }
  
  public void update() {
    if(millis() - lastUpdate < 100 || paused) return;
    if(status == 1) { //opening
      progress -= 0.01;
      if(progress <= 0) {status = 2; progress=0;}
    }
    else if(status == 3) { //closing
      progress += 0.01;
      if(progress >= 1) {status = 0; progress=1;}
    }
    lastUpdate = millis();
  }
  
  void open() {status = 1;}
  void close() {status = 3;}
  void stop() {paused = true;}
  void resume() {paused = false;}
  void toggle() {
    if(status == 0) status = 1;
    else if(status == 1) status = 3;
    else if(status == 2) status = 3;
    else if(status == 3) status = 1;
  }
}