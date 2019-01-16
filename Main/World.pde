import java.util.ArrayList;
import java.util.Scanner;

public class World {
  private Solid[][] world;
  private ArrayList<Solid> solids;

  //possible problems is cols and rols swich w x and y 
  public World(ArrayList<Solid> solidList, int dimensionX, int dimensionY) {
    solids = solidList;
    world = new Solid[dimensionY][dimensionX];
    for (int i =0; i < solids.size(); i++) {
      addSolid(solids.get(i));
    }
  }

  public World(int w, int h) {
    world = new Solid[h][w];
    solids = new ArrayList<Solid>();
  }

  public World(String str) {
    int w = str.indexOf("\n")+1, h = str.split("\n").length+1;
    world = new Solid[h][w];
    println(">>>", w, h);
    solids = new ArrayList<Solid>();
    Scanner s = new Scanner(str);
    Texture[] textures = {
      new OneColor(color(255, 0, 255)), 
      new OneColor(color(#746D0D)), 
      new ImageTexture(loadImage("data/bricks.png")), 
      new ImageTexture(loadImage("data/bookshelf.png")), 
      new ImageTexture(loadImage("data/stonebrick.png"))
    };
    int x = 0, y = 0;
    while (s.hasNextLine()) {
      char[] chars = s.nextLine().toCharArray();
      for (char c : chars) {
        if (c == '#') addSolid(new Solid(x, y, 3, textures[4]));
        else if (c == 'D') {addSolid(new Door(x, y, 3, textures[3]));}
        else if (c == 'B') addSolid(new Solid(x, y, 3, textures[2]));
        else if (c >= 'A' && c <= 'Z') addSolid(new Solid(x, y, 3, textures[0]));
        x++;
      }
      x = 0;
      y++;
    }
    s.close();
  }

  public Solid whatsThere(int x, int y) {
    if (y < 0 || y >= world.length) {
      return null;
    }
    if (x < 0 || x >= world[y].length) {
      return null;
    }
    return world[y][x];
  }

  public void addSolid(Solid current) {
    if (current.getX() < world[0].length && current.getY() < world.length) {
      world[current.getY()][current.getX()] = current;
    } else {
      throw new IllegalArgumentException("coordinates must be within the dimensions of the world");
    }
  }

  public String toString() {
    String ans = "[ \n";
    String identity = "";
    for (int row = 0; row < world.length; row++) {
      ans += "[";
      for (int col = 0; col < world[0].length; col++) {
        if (world[row][col] instanceof Solid) {
          identity = "solid";
        } else if (world[row][col]  == null) {
          identity = "null";
        }
        ans += " " + identity + ",";
      }
      ans += "] \n";
    }
    return ans + "]";
  }
}