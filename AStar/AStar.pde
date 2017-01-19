class Tile {
  public int x;
  public int y;
  
  // f, g and h for A*
  public float f = 0;
  public float g = 0;
  public float h = 0;
  
  // Neighbors
  private ArrayList<Tile> neighbors;
  
  public Tile previous;
  
  public boolean wall;
  
  public Tile(int x, int y) {
    this.x = x;
    this.y = y;
    this.wall = random(1) < .1;
  }
  
  public void draw() {
    fill(getColor());
    rect(x * tileSize, y * tileSize, tileSize, tileSize);
  }
  
  private int getColor() {
    return this.equals(start) || this.equals(end) ? 100 : (wall ? 0 : 255);
  }
  
  public ArrayList<Tile> getNeighbors() {
    // Just in case
    if (neighbors == null) {
      addNeighbors();
    }
    
    return neighbors;
  }
  
  public void addNeighbors() {
    int cols = tiles.length;
    int rows = tiles[0].length;
    
    neighbors = new ArrayList<Tile>();
    
    if (x < cols - 1) {
      neighbors.add(tiles[x + 1][y]);
    }
    
    if (x > 0) {
      neighbors.add(tiles[x - 1][y]);
    }
    
    if (y < rows - 1) {
      neighbors.add(tiles[x][y + 1]);    
    }
    
    if (y > 0) {
      neighbors.add(tiles[x][y - 1]);
    }
    
    // TODO Add diagonals
  }
}

int tileSize;
int numTiles = 20;

Tile[][] tiles;

Tile start;
Tile end;

ArrayList<Tile> closedSet = new ArrayList<Tile>();
ArrayList<Tile> openSet = new ArrayList<Tile>();

public void setup() {
  size(400, 400);
  noStroke();

  tileSize = floor(width / numTiles);
  
  // Create & fill tile array
  tiles = new Tile[numTiles][numTiles];
  
  for (int y = 0; y < numTiles; y++) {
    for (int x = 0; x < numTiles; x++) { 
      Tile tile = tiles[y][x] = new Tile(x, y);
      tile.addNeighbors();
      
      if (x == 0 && y == 0) {
        start = tile;
      } else if (x == numTiles - 1 && y == numTiles - 1) {
        end = tile;
      }
    }
  }
  
  start.wall = false;
  end.wall = false;
  
  openSet.add(start);
}

public void draw() {
  //background(0);
  Tile current = step();
  
  for (int y = 0; y < tiles.length; y++) {
    for (int x = 0; x < tiles[y].length; x++) {
      Tile tile = tiles[y][x];
      tile.draw();
    }
  }
  
  if (current == null) {
    return;
  }
  
  // Draw current path
  ArrayList<Tile> path = new ArrayList<Tile>();
  Tile temp = current;
  
  path.add(temp);
  
  while (temp.previous != null) {
    path.add(temp);
    
    temp = temp.previous;
  }
  
  drawPath(path);
}

private void drawPath(ArrayList<Tile> path) {
  noFill();
  stroke(255, 0, 200);
  strokeWeight(width / 2);
  beginShape();
  
  for (Tile tile : path) {
    vertex(tile.x * width + width / 2, tile.y * height + height / 2);
  }
}

// All the A* code

public Tile step() {
  if (openSet.size() <= 0) {
    // No solution
    noLoop();
    return null;
  }
  
  // Keep going if openSet is empty
  Tile winner = openSet.get(0);
    
  for (Tile tile : openSet) {
    if (tile.f < winner.f) {
      winner = tile;
    }
  }
  
  if (winner.equals(end)) {
    noLoop();
    return null;
  }
  
  openSet.remove(winner);
  closedSet.add(winner);
  
  for (Tile neighbor : winner.getNeighbors()) {
    // TODO Fix weird NPE
    if (neighbor == null || closedSet.contains(neighbor) || neighbor.wall) {
      continue;
    }
    
    float newG = winner.g + heuristic(neighbor, winner);
    boolean newPath = false;
    
    if (openSet.contains(neighbor)) {
      if (newG < neighbor.g) {
        neighbor.g = newG;
        newPath = true;
      }
    } else {
      neighbor.g = newG;
      newPath = true;
      openSet.add(neighbor);
    }
    
    if (!newPath) {
      continue;
    }
    
    // Recalc A* values if new path
    neighbor.h = heuristic(neighbor, end);
    neighbor.f = neighbor.g + neighbor.h;
    neighbor.previous = winner;
  }
  
  return winner;
}

// TODO Add diagonal support
private float heuristic(Tile a, Tile b) {
  return dist(a.x, a.y, b.x, b.y);
}