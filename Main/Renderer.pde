public class Renderer{
  RayCastor rc;
  color ground, sky;
  
  public Renderer(RayCastor r){
    rc = r;
    ground = #764D0D;
    sky = #82CAFF;
  }
  
  public void render(){
    background(ground);
    fill(sky);
    rectMode(CORNERS);
    rect(0, 0, width, height/2);
    PImage[] buffer = rc.getBuffer();
    imageMode(CENTER);
    for(int i = 0; i < buffer.length; i++) {
      if(buffer[i] == null) continue;
      for(int j = 0; j < height/buffer.length; j++) {
        image(buffer[i], i*(height/buffer.length)+j, height/2);
      }
    }
  }
  
  public void setSky(color c) {sky = c;}
  public color getSky() {return sky;}
  public void setGround(color c) {ground = c;}
  public color getGround() {return ground;}
  
  public void update(){
    rc.beginCasting();
  }
  
  public void setResolution(int resolution){
    rc.camera.resolution = resolution;
  }
  
  public int getResolution(){
    return rc.camera.resolution;
  }
  
  
}