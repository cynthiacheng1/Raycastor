public class Ray {
  int stepX, stepY, mapX, mapY;
  double startX, startY;
  double originalMagnitude;
  double deltaDistX, deltaDistY, initDistX, initDistY;
  PVector vector;
  boolean onGrid, sideHit;
  
  Ray(float x1, float y1, float x2, float y2) {
    startX = x1;
    startY = y1;
    mapX = (int)startX;
    mapY = (int)startY;
    vector = new PVector(x2 - x1, y2 - y1);
    originalMagnitude = vector.mag();
    onGrid = false;
    sideHit = false; //false=NorthSouth // true=EastWest
    calculateDistances();
  }
  

  void calculateDistances() {
    deltaDistX = sqrt(1 + (vector.y*vector.y) / (vector.x*vector.x));
    deltaDistY = sqrt(1 + (vector.x*vector.x) / (vector.y*vector.y));
    if(vector.x < 0) {
      stepX = -1;
      initDistX = (getPosX() - getMapX()) * deltaDistX;
    } else {
      stepX = 1;
      initDistX = (getMapX() + 1 - getPosX()) * deltaDistX;
    }
    if(vector.y < 0) {
      stepY = -1;
      initDistY = (getPosY() - getMapY()) * deltaDistY;
    } else {
      stepY = 1;
      initDistY = (getMapY() + 1 - getPosY()) * deltaDistY;
    }
  }
  
  void grow() {
    if(initDistX < initDistY) {
      initDistX += deltaDistX;
      //mapX += stepX
      mapX += stepX;
      //side = east/west
      sideHit = true;
    } else {
      initDistY += deltaDistY;
      //mapY += setpY
      mapY += stepY;
      //side = north/south
      sideHit = false;
    }
    //now safe to check if a wall was hit
  }
  
  /** The length of this ray from its vertex */
  double magnitude() {
    return vector.mag();
  }
  
  /** The length of this ray if it began at the camera plane */
  double planeMagnitude() {
    return vector.mag() - originalMagnitude;
  }
  
  /** Returns the exact coordinates of this ray tip */
  float getPosX() {return vector.x + (float)startX;}
  float getPosY() {return vector.y + (float)startY;}
  
  /** Returns the integer coordinates of this ray tip */
  int getMapX() {return mapX;}
  int getMapY() {return mapY;}
  
  /** Returns the perpendicular distance from the camera plane
      to wherever the ray hit a wall to avoid the fish-eye effect.*/
  double perpWallDist() {
    if(sideHit) //hit east-west side
      return (mapX - startX + (1 - stepX) / 2) / vector.x;
    else         //hit north-south side
      return (mapY - startY + (1 - stepY) / 2) / vector.y; 
  }
  
  String toString() {
    return "<" + vector.x + "," + vector.y + ">";
  }
  
  String where() {
    return "("+mapX+"  "+mapY+")";
  }
}