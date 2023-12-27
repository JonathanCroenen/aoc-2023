
def parse_input(path: str) -> tuple[int, int]:
    with open(path, "r") as f:
        lines = [line.strip() for line in f.readlines()]

        timing = lines[0].replace("Time:", "").replace(" ", "").strip()
        distance = lines[1].replace("Distance:", "").replace(" ", "").strip()

        return int(timing), int(distance)

def solve(race):
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
        print("No solutions")
        return

    solution = max_x - min_x + 1
    print(f"Solution: {solution}")


def main():
    input = parse_input("input/input.txt")
    solve(input)


if __name__ == "__main__":
    main()
