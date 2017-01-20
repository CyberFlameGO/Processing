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
    this.wall = random(1) < wallProb;
  }
  
  public void draw() {
    fill(getColor());
    rect(x * tileSize, y * tileSize, tileSize, tileSize);
  }
  
  public void drawPredef() {    
    rect(x * tileSize, y * tileSize, tileSize, tileSize);
  }
  
  private int getColor() {
    return this.equals(start) || this.equals(end) ? 100 : (wall ? 0 : 255);
  }
  
  public ArrayList<Tile> getNeighbors() {
    if (neighbors == null) {
      neighbors = new ArrayList<Tile>();
      addNeighbors();
    }
    
    return neighbors;
  }
  
  public void addNeighbors() {
    int cols = tiles.length;
    int rows = tiles[0].length;
    
    if (x < cols - 1) {
      neighbors.add(tiles[y][x + 1]);
    }
    
    if (x > 0) {
      neighbors.add(tiles[y][x - 1]);
    }
    
    if (y < rows - 1) {
      neighbors.add(tiles[y + 1][x]);    
    }
    
    if (y > 0) {
      neighbors.add(tiles[y - 1][x]);
    }
    
    // TODO Add diagonals
  }
}

// Settings
int numTiles = 40;
int fps = 15;
float wallProb = .2;

int tileSize;
Tile[][] tiles;

Tile start;
Tile end;
Tile previous;

ArrayList<Tile> closedSet = new ArrayList<Tile>();
ArrayList<Tile> openSet = new ArrayList<Tile>();

public void setup() {
  size(400, 400);
  frameRate(fps);
  noStroke();

  tileSize = floor(width / numTiles);
  
  // Create & fill tile array
  tiles = new Tile[numTiles][numTiles];
  
  for (int y = 0; y < numTiles; y++) {
    for (int x = 0; x < numTiles; x++) { 
      Tile tile = tiles[y][x] = new Tile(x, y);
      
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
  step();
  
  for (int y = 0; y < tiles.length; y++) {
    for (int x = 0; x < tiles[y].length; x++) {
      Tile tile = tiles[y][x];
      tile.draw();
    }
  }
  
  if (previous == null) {
    return;
  }
  
  // Draw current path
  ArrayList<Tile> path = new ArrayList<Tile>();
  Tile temp = previous;
  
  path.add(temp);
  
  while (temp.previous != null) {
    path.add(temp);
    
    temp = temp.previous;
  }
  
  drawPath(path);
}

private void drawPath(ArrayList<Tile> path) {
  fill(255, 0, 200);
  
  for (Tile tile : path) {
    tile.drawPredef();
  }
}

// All the A* winner selector
public void step() {
  if (openSet.size() <= 0) {
    // No solution
    System.out.println("No solution!");
    noLoop();
    return;
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
    return;
  }
  
  openSet.remove(winner);
  closedSet.add(winner);
  
  if (winner.getNeighbors().size() > 4) {
    System.out.println("Too many neighbors! x: " + winner.x + " y: " + winner.y);
  }
  
  for (Tile neighbor : winner.getNeighbors()) {
    if (closedSet.contains(neighbor) || neighbor.wall) {
      continue;
    }
    
    float newG = winner.g + heuristic(neighbor, winner);
    boolean newPath = false;
    
    boolean contains = openSet.contains(neighbor);
    
    if (!contains || newG < neighbor.g) {
      neighbor.g = newG;
      newPath = true;
      
      if (!contains) {
        openSet.add(neighbor);
      }
    }
    
    if (!newPath) {
      continue;
    }
    
    // Recalc A* values if new path
    neighbor.h = heuristic(neighbor, end);
    neighbor.f = neighbor.g + neighbor.h;
    neighbor.previous = winner;
  }
  
  previous = winner;
}

// TODO Add diagonal support
private float heuristic(Tile a, Tile b) {
  return abs(a.x - b.x) + abs(b.x - b.x);
  
  //return dist(a.x, a.y, b.x, b.y);
}