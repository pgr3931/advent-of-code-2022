import 'dart:async';
import 'dart:convert';
import 'dart:io';

List<String> inputs = [];
List<String> allInputs = ["[[2]]", "[[6]]"];
var result = 0;
var i = 1;
var level = 0;

Comparator<String> comparator = (String left, String right) {
  var rightAsInt = int.tryParse(right);
  var rightIsInt = rightAsInt != null;
  var leftAsInt = int.tryParse(left);
  var leftIsInt = leftAsInt != null;

  if (leftIsInt && rightIsInt) {
    // print((' ' * level) + '- Compare $left vs $right');
    level += 2;
    if (leftAsInt == rightAsInt) {
      return 0;
    } else if (leftAsInt < rightAsInt) {
      return -1;
    } else {
      return 1;
    }
  }

  List<String> leftValues = [];
  List<String> rightValues = [];
  var openBr = 0;

  if (!rightIsInt && leftIsInt) {
    leftValues.add(left);
  } else if (left.startsWith("[")) {
    left = left.substring(1, left.length - 1);
    var lastPos = 0;

    for (int i = 0; i < left.length; i++) {
      var char = left[i];
      if (char == "[") openBr++;
      if (char == "]") openBr--;
      if ((openBr == 0 && char == ",")) {
        leftValues.add(left.substring(lastPos, i));
        lastPos = i + 1;
      }
    }

    if (left.length > 0) leftValues.add(left.substring(lastPos));
  }

  openBr = 0;

  if (!leftIsInt && rightIsInt) {
    rightValues.add(right);
  } else if (right.startsWith("[")) {
    right = right.substring(1, right.length - 1);
    var lastPos = 0;

    for (int i = 0; i < right.length; i++) {
      var char = right[i];
      if (char == "[") openBr++;
      if (char == "]") openBr--;
      if ((openBr == 0 && char == ",")) {
        rightValues.add(right.substring(lastPos, i));
        lastPos = i + 1;
      }
    }

    if (right.length > 0) rightValues.add(right.substring(lastPos));
  }

  // print((' ' * level) + '- Compare $leftValues vs $rightValues');
  level += 2;

  for (var i = 0; i < leftValues.length; i++) {
    if (rightValues.length == i) return 1;
    var result = comparator(leftValues[i], rightValues[i]);

    if (result != 0) return result;

    level -= 2;
  }

  return leftValues.length == rightValues.length ? 0 : -1;
};

void process(String line) {
  if (line == "") {
    // print('== Pair $i ==');
    var res = comparator(inputs[0], inputs[1]);
    if (res != 1) {
      // print("Right order");
      result += i;
    } else {
      // print("Wrong order");
    }
    inputs.clear();
    i++;
    level = 0;
    //print("");
  } else {
    inputs.add(line);
    allInputs.add(line);
  }
}

void main() {
  // Part one

  new File("input.txt").readAsLinesSync().forEach(process);
  process("");

  print(result);

  // Part two

  allInputs.sort(comparator);
  // for (var input in allInputs) {
  //   print(input);
  // }
  var index = allInputs.indexOf("[[2]]") + 1;
  index *= allInputs.indexOf("[[6]]") + 1;
  print(index);
}
