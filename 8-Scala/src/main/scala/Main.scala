import scala.io.Source
import scala.collection.mutable.ListBuffer
import scala.collection.mutable.ArraySeq
import scala.math._

@main def output: Unit = 
  val trees: ListBuffer[ListBuffer[Int]] = ListBuffer()
  for (line <- Source.fromFile("./input.txt").getLines) {
    val row = ListBuffer[Int]()
    for (char <- line){
      row += char - '0'
    } 
    trees += row   
  }

  var count = 99 * 2 + 97 * 2 // Edge trees
  var score = 0

  for (i <- 1 to trees.size - 2){
    for (j <- 1 to trees.apply(1).size - 2){
      val tree = trees.apply(i).apply(j)
      val visible = ArraySeq(true, true, true, true)

      var top = i -1
      var bottom = i + 1
      var left = j - 1
      var right = j + 1

      var tScore, bScore, lScore, rScore = 0

      while(top >= 0 || bottom <= trees.size - 1 || left >= 0 || right <= trees.apply(1).size - 1){

        if(top >= 0){
          val tt = trees.apply(top).apply(j)
          
          if(visible.apply(0)){
            tScore = tScore + 1
          }

          if(tt >= tree){
            visible(0) = false
          }
        }

        if(bottom <= trees.size - 1){
          val bt = trees.apply(bottom).apply(j)
           
          if(visible.apply(1)){
            bScore = bScore + 1
          }
           
          if(bt >= tree){
            visible(1) = false
          }
        }

        if(left >= 0){
          val lt = trees.apply(i).apply(left)

          if(visible.apply(2)){
            lScore = lScore + 1
          }

          if(lt >= tree){
            visible(2) = false
          }
        }

        if(right <= trees.apply(1).size - 1){
          val rt = trees.apply(i).apply(right)

          if(visible.apply(3)){
            rScore = rScore + 1
          }

          if(rt >= tree){
            visible(3) = false
          }
        }

        top = top - 1
        bottom = bottom + 1
        left = left - 1
        right = right + 1
      }

      score = max(score, tScore * bScore * lScore * rScore)

      if (visible.exists(v => v)){
        count = count + 1
      }
    }
  }

  println(count) 
  println(score) 

