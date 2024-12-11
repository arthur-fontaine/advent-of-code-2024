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
	if err != nil {
		panic(err)
	}

	r, err := blink(stones, 75)
	if err != nil {
		panic(err)
	}

	fmt.Println(r)
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

var blinkCache = map[string]int{}

func blink(stones []stone, i int) (int, error) {
	key := getBlinkCacheKey(stones, i)

	if i == 0 {
		blinkCache[key] = len(stones)
		return len(stones), nil
	}

	if c, ok := blinkCache[key]; ok {
		return c, nil
	}

	r := 0
	for _, s := range stones {
		if _newStones, err := getNewStones(s); err != nil {
			return 0, err
		} else {
			if r_, err := blink(_newStones, i-1); err != nil {
				return 0, err
			} else {
				r += r_
			}
		}
	}
	blinkCache[key] = r
	return r, nil
}

func getBlinkCacheKey(stones []stone, remaining int) string {
	return fmt.Sprint(stones) + strconv.Itoa(remaining)
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
