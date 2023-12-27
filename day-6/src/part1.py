

def parse_input(path: str) -> list[tuple[int, int]]:
    with open(path, "r") as f:
        lines = [line.strip() for line in f.readlines()]

        timings = filter(
            lambda x: x != "",
            lines[0].replace("Time:", "").strip().split(" ")
        )

        distances = filter(
            lambda x: x != "",
            lines[1].replace("Distance:", "").strip().split(" ")
        )

        return list(zip(
            [int(timing) for timing in timings],
            [int(distance) for distance in distances]
        ))

def solve(input):
    solutions = []

    for race in input:
        eq = lambda x: -x ** 2 + race[0] * x - race[1] > 0

        min_x, max_x = -1, -1
        for x in range(1, race[0]):
            if eq(x):
                min_x = x
                break

        for x in range(race[0] - 1, 0, -1):
            if eq(x):
                max_x = x
                break

        if min_x == -1 or max_x == -1:
            solutions.append(0)

        solutions.append(max_x - min_x + 1)

    print(solutions)
    sum = 1
    for solution in solutions:
        sum *= solution

    print(sum)


def main():
    input = parse_input("input/input.txt")
    solve(input)


if __name__ == "__main__":
    main()
