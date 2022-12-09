use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn main() {
    let mut count1 = 0;
    let mut count2 = 0;

    if let Ok(lines) = read_lines("./input.txt") {
        for line in lines {
            if let Ok(pair) = line {
                if let Some(zones) = pair.split_once(','){   
                    let mut id1: i32 = 0; 
                    let mut id2: i32 = 0; 
                    if let Some(ids) = zones.0.split_once('-'){
                         id1 =  ids.0.parse().unwrap();
                         id2 =  ids.1.parse().unwrap();
                    }    
                    
                    if let Some(ids) = zones.1.split_once('-'){
                        let id3 =  ids.0.parse::<i32>().unwrap();
                        let id4 =  ids.1.parse::<i32>().unwrap();

                        // Part one
                        if (id1 <= id3 && id2 >= id4) || (id3 <= id1 && id4 >= id2){
                            count1 += 1;
                        }

                        // Part two
                        // definition of overlapping ranges: id1 <= C <= id2 && id3 <= C <= id4
                        // I'm not that smart though https://stackoverflow.com/questions/3269434/whats-the-most-efficient-way-to-test-if-two-ranges-overlap
                        if id1 <= id4 && id3 <= id2 {
                            count2 += 1;
                        }

                   }             
                }
            }
        }
    }

    println!("{}", count1);
    println!("{}", count2);
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}