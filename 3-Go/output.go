package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strings"
)

func main() {
    readFile, err := os.Open("input.txt")

    if err != nil {
        fmt.Println(err)
    }

    fileScanner := bufio.NewScanner(readFile)
 
    fileScanner.Split(bufio.ScanLines)

    priority := 0
  
    // Part one

    for fileScanner.Scan() {
        line := fileScanner.Text()       
        compartment1 := line[:len(line)/2]
        compartment2 := line[len(line)/2:]

        for _, item := range compartment1 {
            if(strings.Contains(compartment2, string(item))){
                asciiValue := int(item)
                // Uppercase Letters
                if(asciiValue < 91){
                    priority += asciiValue - 38
                // Lowercase letters
                } else {
                    priority += asciiValue - 96
                }
                break;
            }
        }
    }

    fmt.Println(priority)

    // Part two

    priority = 0

    _, err = readFile.Seek(0, io.SeekStart)

	if err != nil {
		fmt.Println(err)
	}

    fileScanner = bufio.NewScanner(readFile)
 
    fileScanner.Split(bufio.ScanLines)

    rucksacks := []string{}

    for fileScanner.Scan() {
        line := fileScanner.Text()          
        rucksacks = append(rucksacks, line)
       
        if (len(rucksacks) == 3){
            found := false
            for _, item := range rucksacks[0] {
                if (!found && strings.Contains(rucksacks[1], string(item)) && strings.Contains(rucksacks[2], string(item))){
                    found = true
                    asciiValue := int(item)
                    // Uppercase Letters
                    if (asciiValue < 91){
                        priority += asciiValue - 38
                    // Lowercase letters
                    } else {
                        priority += asciiValue - 96
                    }                 
                }
            }
            rucksacks = rucksacks[:0]
        } 
    }

    fmt.Println(priority)
  
    readFile.Close()
}