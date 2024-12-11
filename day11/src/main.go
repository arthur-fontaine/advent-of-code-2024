package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	input, err := readInput()
	if err != nil {
		panic(err)
	}
	stones, err := parseInput(input)
	for i := 0; i < 25; i++ {
		if newStones, err := blink(stones); err != nil {
			panic(err)
		} else {
			stones = newStones
		}
	}

	fmt.Println(len(stones))
}

func readInput() (string, error) {
	if file, err := os.ReadFile("input.txt"); err != nil {
		return "", err
	} else {
		return string(file), nil
	}
}

type stone int

func parseInput(input string) ([]stone, error) {
	r := []stone{}
	for _, part := range strings.Split(input, " ") {
		if s, err := strconv.Atoi(part); err != nil {
			return nil, err
		} else {
			r = append(r, stone(s))
		}
	}
	return r, nil
}

func blink(stones []stone) ([]stone, error) {
	newStones := []stone{}
	for _, stone := range stones {
		if _newStones, err := getNewStones(stone); err != nil {
			return nil, err
		} else {
			newStones = append(newStones, _newStones...)
		}
	}
	return newStones, nil
}

func isEven(n int) bool {
	return n%2 == 0
}

func splitAt(s string, i int) []string {
	return []string{s[:i], s[i:]}
}

func getNewStones(s stone) ([]stone, error) {
	stoneStr := strconv.Itoa(int(s))
	if s == 0 {
		return []stone{1}, nil
	} else if isEven(len(stoneStr)) {
		splittedStones := splitAt(stoneStr, len(stoneStr)/2)

		stone1, err := strconv.Atoi(splittedStones[0])
		stone2, err := strconv.Atoi(splittedStones[1])
		if err != nil {
			return nil, err
		}
		return []stone{stone(stone1), stone(stone2)}, nil
	} else {
		return []stone{s * 2024}, nil
	}
}
