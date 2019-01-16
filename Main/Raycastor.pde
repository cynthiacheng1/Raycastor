import java.util.ArrayList;

public class RayCastor {
  World world;
  Camera camera;
  int renderDistance; //how far away you can see
  PImage[] stripes;
  ArrayList<Solid> solids = new ArrayList<Solid>();

  public RayCastor(Camera c) {
    solids.add(new Solid(1, 1, 3, new ImageTexture(loadImage("data/bricks.png"))));
    solids.add(new Solid(3, 1, 3, new Beacon(new ImageTexture(loadImage("data/stonebrick.png")), color(255, 0, 255))));
    solids.add(new Door(2, 1, 3, new ImageTexture(loadImage("data/bookshelf.png"))));
    world = new World(solids, 5, 5);
    world = new World(join(loadStrings("data/world1.txt"), "\n"));
    camera = c;
    stripes = new PImage[camera.resolution];
    renderDistance = 10;
  }
  
  public void camX(){
    
  }

  public void beginCasting() {
    camera.reset();
    stripes = new PImage[camera.resolution];
    int rayNumber = 0;
    Solid s = null;
    while (camera.hasNextRay()) {
      Ray r = camera.nextRay();
      for (int i = 0; i < renderDistance; i ++) {
        //this is the cone thing
        //if(world.whatsThere(r.getMapX(), r.getMapY()) != 0) {
        //  //println("Detected @(" + r.getMapX() + ", " + r.getMapY() + ") " + r.perpWallDist());
        //  PVector end = r.vector.copy();
        //  end.setMag((float)r.perpWallDist()); //looks like fish-eye
        //  stroke(128, 255, 128);
        //  line(240, 240, 240 + end.x*40, 240 - end.y*40);
        //  break;
        //} 
        s = world.whatsThere(r.getMapX(), r.getMapY());

        if (s == null) {
          r.grow(); //nothing there, keep going
        } else if (s.opacity < 1) {
          addToStripe(rayNumber, r, s); //we hit a transparent solid
          r.grow();
        } else {
          break; //we hit something opaque
        }
      }
      double where; //from 0 to 1, the xCoord of the texture
      if (r.sideHit == true) where = r.startX + r.perpWallDist() * r.vector.y; //east-west (side = 0)
      else                   where = r.startX + r.perpWallDist() * r.vector.x; //north-south (side = 1)
      if (s != null) {
        addToStripe(rayNumber, r, s); //if we hit something
      }
      rayNumber++;
    }
  }

  public PImage[] getBuffer() {
    return stripes;
  }

  void setRenderDistance(int d) {
    renderDistance = d;
  }
  int getRenderDistance() {
    return renderDistance;
  }

  /** Puts one image on top of another */
  private void compose(PImage img1, PImage img2) {
    int padding = (img1.height - img2.height)/2;
    img1.blend(img2, 0, 0, 1, img2.height, 0, padding, 1, img2.height, BLEND);
  }

  /** If you want to merge two images in a stripe, use this.
      Expects a ray that hit a Solid s. The index is the rayNumber. */
  private void addToStripe(int index, Ray r, Solid s) {
    double where;
    if (r.sideHit == true) where = r.startX + r.perpWallDist() * r.vector.y; //east-west (side = 0)
    else                   where = r.startX + r.perpWallDist() * r.vector.x; //north-south (side = 1)
    if (stripes[index] != null) {
      PImage overlay = s.getStripe((float)where, r.perpWallDist(), r.sideHit); //the opaque image
      overlay.mask(createAlphaMask(255 - (int)alpha(stripes[index].get(0,0)), overlay.height)); //allows us to blend colors
      compose(stripes[index], overlay);
    } else
      stripes[index] = s.getStripe((float)where, r.perpWallDist(), r.sideHit); //if it hit an east-west side, make it shaded
  }
  
  /** Used for the mask() function, which accepts an array
      filled with alpha values 0...255 the length should be
      the number of pixels in the image this will be applied to */
  private int[] createAlphaMask(int a, int length) {
    int[] array = new int[length];
    for(int i = 0; i < array.length; i++) array[i] = a;
    return array;
  }
}