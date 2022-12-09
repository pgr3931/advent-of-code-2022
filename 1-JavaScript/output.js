const fs = require("fs");

fs.readFile("input.txt", "utf8", (err, data) => {
  if (err) {
    console.error(err);
    return;
  }

  // Part one
  let max = 0;
  let localMax = 0;

  for (const calories of data.split("\n")) {
    if (calories === "") {
      max = Math.max(localMax, max);
      localMax = 0;
    } else {
      localMax += parseInt(calories);
    }
  }

  console.log(max);

  //Part two
  const elves = [];
  let elf = 0;
  for (const calories of data.split("\n")) {
    if (calories === "") {
      elves.push(elf);
      elf = 0;
    } else {
      elf += parseInt(calories);
    }
  }

  console.log(
    elves
      .sort((a, b) => b - a)
      .slice(0, 3)
      .reduce((prev, curr) => prev + curr)
  );
});
