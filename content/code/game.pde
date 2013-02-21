World world = new World(50, 50);

void setup() {
  size(400,400);
  
  //world.initializeSpecific();
  world.initialize();
  
}

void draw() {
  background(0);
  world.draw();
  world.updateState();
}

class World {
  
  int rows;
  int cols;
  
  Cell[][] map;
  
  World(int tempRows, int tempCols) {
    this.rows = tempRows;
    this.cols = tempCols;
    
    this.map = new Cell[this.cols][this.rows];
  }
  
  void initialize() {
    boolean isAlive = false;
    for (int i = 0; i < this.cols; i++) {
      for (int j = 0; j < this.rows; j++) {
        // Initialize each object
        isAlive = int(random(2)) == 1 ? true : false;
        map[i][j] = new Cell(i*10, j*10, 10, 10, isAlive);
      }
    }
  }
  
  void initializeSpecific() {

    for (int i = 0; i < this.cols; i++) {
      for (int j = 0; j < this.rows; j++) {
        // Initialize each object
        map[i][j] = new Cell(i*10, j*10, 10, 10, false);
      }
    }
    
    
   /* map[10][11].isAlive = true;
    map[10][12].isAlive = true;
    map[11][11].isAlive = true;
    
    
    
    map[12][14].isAlive = true;
    map[13][13].isAlive = true;
    map[13][14].isAlive = true;*/
    
    map[13][13].isAlive = true;
    map[13][14].isAlive = true;
    map[13][15].isAlive = true;
    
  }
  
  void draw() {
    for (int i = 0; i < this.cols; i++) {
      for (int j = 0; j < this.rows; j++) {
        map[i][j].display();
      }
    }
  }
  
  void updateState() {
    Cell [][] tempMap = new Cell[this.cols][this.rows];

    for (int i = 0; i < this.cols; i++) {
      for (int j = 0; j < this.rows; j++) {
        // Initialize each object
        
        tempMap[i][j] = new Cell(i*10, j*10, 10, 10, false);
      }
    }
    
    int liveNeighbourCount = 0;
    for (int i = 0; i < this.cols; i++) {
      for (int j = 0; j < this.rows; j++) {
        
        liveNeighbourCount = this.getLiveNeighbourCount( i, j);
       
        // Check status based on 4 rules:
        // 1. Any live cell with fewer than two live neighbours dies, as if caused by under-population.
        if (liveNeighbourCount < 2) {
          tempMap[i][j].isAlive = false;
        // 2. Any live cell with two or three live neighbours lives on to the next generation.
        }else if (map[i][j].isAlive == true && (liveNeighbourCount == 2 || liveNeighbourCount == 3)){
          tempMap[i][j].isAlive = true;}
        // 3. Any live cell with more than three live neighbours dies, as if by overcrowding.
        else if (map[i][j].isAlive == true && liveNeighbourCount > 3){
          tempMap[i][j].isAlive = false;}
        // 4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
        else if (map[i][j].isAlive == false && liveNeighbourCount == 3){
          tempMap[i][j].isAlive = true;}
  
      }
    }
    
    this.map = tempMap;
 
  }
  
  int getLiveNeighbourCount(int col, int row) {
    
    int count = 0;
    
    //North-West
    if (row != 0 && col != 0 && this.map[col-1][row-1].isAlive)
      count++;
    //North
    if (row != 0 && this.map[col][row-1].isAlive)
      count++;
    //North-East
    if (row != 0 && col != (this.cols - 1) && this.map[col+1][row-1].isAlive)
      count++;
    //East
    if (col != (this.cols - 1) && this.map[col+1][row].isAlive)
      count++;
    //South-East
    if (row != (this.rows - 1) && col != (this.cols - 1) && this.map[col+1][row+1].isAlive)
      count++;
    //South
    if (row != (this.rows - 1) && this.map[col][row+1].isAlive)
      count++;
    //South-West
    if (row != (this.rows -1) && col != 0 && this.map[col-1][row+1].isAlive)
      count++;
    //West
    if (col != 0 && this.map[col-1][row].isAlive)
      count++;
  
    return count;
  }
    
  // A Cell object
  class Cell {
    // A cell object knows about its location in the grid as well as its size with the variables x,y,w,h.
    float x,y; // x,y location
    float w,h; // width and height
    boolean isAlive; // is this organism alive
  
    // Cell Constructor
    Cell(float tempX, float tempY, float tempW, float tempH, boolean tempIsAlive) {
      x = tempX;
      y = tempY;
      w = tempW;
      h = tempH;
      isAlive = tempIsAlive;
    }
  
    void display() {
      stroke(255);
      // Color calculated using sine wave
      
      if(this.isAlive)
        fill(0);
      else
        fill(255);
        
      rect(x,y,w,h);
    }
  }
}
