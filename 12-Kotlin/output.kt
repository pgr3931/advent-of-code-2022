import java.io.File
import java.util.LinkedList
import kotlin.collections.mutableListOf

class QItem(row: Int, col: Int, dist: Int) {
  var row = row
  var col = col
  var dist = dist

  override fun toString() = "$row $col"
}

val dRow = intArrayOf(-1, 0, 1, 0)
val dCol = intArrayOf(0, 1, 0, -1)

fun isValid(x: Int, y: Int, curr: Char, grid: MutableList<MutableList<Char>>, visited: Array<BooleanArray>): Boolean {
    if (x >= 0 && y >= 0 && x < grid.size && y < grid[0].size && visited[x][y] == false) {
        val next = if(grid[x][y] =='E') 'z'.code else grid[x][y].code
        if(next - curr.code <= 1)
            return true;
    }

    return false;
}

fun bfs(grid: MutableList<MutableList<Char>>, source: QItem): Int {
    // applying BFS on matrix cells starting from source
    val queue = LinkedList<QItem>();
    queue.add(QItem(source.row, source.col, 0));
 
    val visited = Array<BooleanArray>(grid.size) { BooleanArray(grid[0].size) }
    visited[source.row][source.col] = true;
 
    while (!queue.isEmpty()) {
      val p = queue.remove();
       
      // Destination found
      if (grid[p.row][p.col] == 'E')
        return p.dist;
        
      val curr = if(grid[p.row][p.col] == 'S') 'a' else grid[p.row][p.col]
 
      // moving up
      if (isValid(p.row - 1, p.col, curr, grid, visited)) {
        queue.add(QItem(p.row - 1, p.col, p.dist + 1));
        visited[p.row - 1][p.col] = true;
      }
 
      // moving down
      if (isValid(p.row + 1, p.col, curr, grid, visited)) {
        queue.add(QItem(p.row + 1, p.col, p.dist + 1));
        visited[p.row + 1][p.col] = true;
      }
 
      // moving left
      if (isValid(p.row, p.col - 1, curr, grid, visited)) {
        queue.add(QItem(p.row, p.col - 1, p.dist + 1));
        visited[p.row][p.col - 1] = true;
      }
 
      // moving right
      if (isValid(p.row, p.col + 1, curr, grid, visited)) {
        queue.add(QItem(p.row, p.col + 1, p.dist + 1));
        visited[p.row][p.col + 1] = true;
      }
    }

    return -1;
}

fun main(){
    val grid: MutableList<MutableList<Char>> = mutableListOf()
    val sources: MutableList<QItem> = mutableListOf();
    var row = 0

    File("input.txt").forEachLine { 
        val gridRow = mutableListOf<Char>()
        var col = 0

        it.forEach { 
            gridRow.add(it)
            if(it == 'a' || it == 'S')
                sources.add(QItem(row, col, 0))

            col++
        }

        grid.add(gridRow)
        row++
    }
    
    // Part one

    val source = QItem(0, 0, 0);

    firstLoop@ for (i in 0..grid.size - 1) {
      for (j in 0..grid[i].size - 1)
      {        
        // Finding source
        if (grid[i][j] == 'S') {
          source.row = i;
          source.col = j;
          break@firstLoop;
        }
      }
    }

    println(bfs(grid, source));
    println()

    // Part two

    var min = Float.POSITIVE_INFINITY
    for(s in sources){
        val length = bfs(grid, s)
        if(length != -1)
            min = Math.min(length.toFloat(), min) 
    }
    println(min.toInt())
}