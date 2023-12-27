package main

import (
    "os"
    "strings"
    "strconv"
)


func ParseFile(path string) ([][]int, error) {
    data, err := os.ReadFile(path)
    if err != nil {
        return nil, err
    }

    lines := strings.Split(string(data), "\n")
    numbers := make([][]int, len(lines) - 1)
    for i, line := range lines {
        if line == "" {
            continue
        }

        nums := strings.Split(line, " ")
        numbers[i] = make([]int, len(nums))

        for j, num := range nums {
            if num == "" {
                continue
            }

            n, err := strconv.Atoi(num)
            if err != nil {
                return nil, err
            }

            numbers[i][j] = n
        }
    }

    return numbers, nil
}

func IsAllZero(numbers []int) bool {
    for _, n := range numbers {
        if n != 0 {
            return false
        }
    }

    return true
}

func Derivative(numbers []int) []int {
    derivative := make([]int, len(numbers) - 1)
    for i := 0; i < len(numbers) - 1; i++ {
        derivative[i] = numbers[i + 1] - numbers[i]
    }

    return derivative
}

func PredictForward(numbers []int) int {
    derivative := Derivative(numbers)
    if IsAllZero(derivative) {
        return numbers[len(numbers) - 1] + derivative[len(derivative) - 1]
    }

    return numbers[len(numbers) - 1] + PredictForward(derivative)
}

func PredictBackward(numbers []int) int {
    derivative := Derivative(numbers)
    if IsAllZero(derivative) {
        return numbers[0] - derivative[0]
    }

    return numbers[0] - PredictBackward(derivative)
}

func Solve(numbers [][]int, Predict func([]int) int) int {
    total := 0
    for _, line := range numbers {
        next := Predict(line)
        total += next
    }

    return total
}

func main() {
    numbers, err := ParseFile("input/input.txt")
    if err != nil {
        panic(err)
    }

    println("Part 1:", Solve(numbers, PredictForward))
    println("Part 2:", Solve(numbers, PredictBackward))
}
