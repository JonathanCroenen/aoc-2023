// Disclaimer: Prime Java code up ahead

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Set;
import java.util.HashSet;

public class Main {
    static Map parseFile(String path) throws FileNotFoundException {
        File file = new File(path);
        Scanner scanner = new Scanner(file);

        List<List<Pipe>> lines = new ArrayList<>();
        int y = 0;
        while (scanner.hasNextLine()) {
            List<Pipe> pipes = new ArrayList<>();
            int x = 0;
            for (byte b : scanner.nextLine().trim().getBytes()) {
                pipes.add(PipeFactory.create(b, new Position(x, y)));
                ++x;
            }

            lines.add(pipes);
            ++y;
        }

        scanner.close();
        return new Map(lines);
    }

    public static void main(String[] args) {
        try {
            Map input = parseFile("input/input.txt");
            Navigator navigator = new Navigator(input);
            // navigator.setLogging(true);

            int length = navigator.findLength();
            System.out.println("Part1: " + length / 2);

            int enclosed = navigator.findEnclosed();
            System.out.println("Part2: " + enclosed);

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}

abstract class Pipe {
    Position position;

    protected Pipe(Position position) {
        this.position = position;
    }

    public Position getPosition() {
        return position;
    }

    public abstract boolean canConnect(Direction direction);
}

enum Direction {
    NORTH,
    EAST,
    SOUTH,
    WEST;

    public Direction opposite() {
        switch (this) {
            case NORTH:
                return SOUTH;
            case EAST:
                return WEST;
            case SOUTH:
                return NORTH;
            case WEST:
                return EAST;
            default:
                return null;
        }
    }
}

class Position {
    private int x;
    private int y;

    public Position(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }

    public boolean canMove(Direction direction, int width, int height) {
        switch (direction) {
            case NORTH:
                return y > 0;
            case EAST:
                return x < width - 1;
            case SOUTH:
                return y < height - 1;
            case WEST:
                return x > 0;
            default:
                return false;
        }
    }

    public void move(Direction direction) {
        switch (direction) {
            case NORTH:
                y -= 1;
                break;
            case EAST:
                x += 1;
                break;
            case SOUTH:
                y += 1;
                break;
            case WEST:
                x -= 1;
                break;
        }
    }

    static public Position move(Position position, Direction direction) {
        Position newPosition = new Position(position.getX(), position.getY());
        newPosition.move(direction);

        return newPosition;
    }

    @Override
    public String toString() {
        return "(" + x + ", " + y + ")";
    }
}

class StartNotFoundException extends Exception {
    public StartNotFoundException() {
        super("Start pipe not found");
    }
}

class Map {
    private List<List<Pipe>> pipes;

    public Map(List<List<Pipe>> pipes) {
        this.pipes = pipes;
    }

    public int getWidth() {
        return pipes.get(0).size();
    }

    public int getHeight() {
        return pipes.size();
    }

    public Pipe getPipe(Position position) {
        return pipes.get(position.getY()).get(position.getX());
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        for (List<Pipe> line : pipes) {
            for (Pipe pipe : line) {
                sb.append(pipe.toString());
            }
            sb.append("\n");
        }

        return sb.toString();
    }
}

class Navigator {
    private Map map;
    private boolean log = false;

    private Position position;
    private Direction direction;

    public Navigator(Map map) {
        this.map = map;
    }

    public void setLogging(boolean log) {
        this.log = log;
    }

    public void reset() {
        position = null;
        direction = null;
    }

    public Pipe findStart() {
        for (int j = 0; j < map.getHeight(); j++) {
            for (int i = 0; i < map.getWidth(); i++) {
                Pipe pipe = map.getPipe(new Position(i, j));
                if (pipe instanceof Start) {
                    return pipe;
                }
            }
        }

        return null;
    }

    public List<Pipe> findLoop() throws StartNotFoundException {
        List<Pipe> loop = new ArrayList<>();

        Pipe start = findStart();
        if (start == null) {
            throw new StartNotFoundException();
        }

        position = start.getPosition();

        do {
            Pipe pipe = map.getPipe(position);
            loop.add(pipe);

            if (log) {
                System.out.println(this.toString());
            }

            move();

        } while (!(map.getPipe(position) instanceof Start));

        reset();

        return loop;
    }

    public int findLength() throws StartNotFoundException {
        return findLoop().size();
    }

    public int findEnclosed() throws StartNotFoundException {
        List<Pipe> loop = findLoop();

        // Shoelace formula: 1 / 2 * sum((x_i - x_i+1) * (y_i + y_i+1)) for each vertex in clockwise order
        int shoelace = 0;
        Pipe lastVertex = loop.get(0);
        for (Pipe pipe : loop.subList(1, loop.size())) {
            if (!(pipe instanceof Horizontal) && !(pipe instanceof Vertical)) {
                shoelace += (pipe.getPosition().getX() - lastVertex.getPosition().getX()) *
                            (pipe.getPosition().getY() + lastVertex.getPosition().getY());
                lastVertex = pipe;
            }
        }

        shoelace += (loop.get(0).getPosition().getX() - lastVertex.getPosition().getX()) *
                    (loop.get(0).getPosition().getY() + lastVertex.getPosition().getY());

        shoelace = Math.abs(shoelace / 2);

        // Pick's theorem: A = internal + boundary / 2 - 1
        int internal = shoelace - loop.size() / 2 + 1;
        return internal;
    }

    private void move() {
        List<Direction> possibleDirections = new ArrayList<>();
        Pipe pipe = map.getPipe(position);

        for (Direction dir : Direction.values()) {
            if (pipe.canConnect(dir) &&
                position.canMove(dir, map.getWidth(), map.getHeight()) &&
                map.getPipe(Position.move(position, dir)).canConnect(dir.opposite()) &&
                (direction == null || dir != direction.opposite())) {
                possibleDirections.add(dir);
            }
        }

        if (possibleDirections.size() == 1) {
            direction = possibleDirections.get(0);
            position.move(direction);
            return;
        }

        for (Direction dir: possibleDirections) {
            if (dir != direction) {
                direction = dir;
                position.move(direction);
                return;
            }
        }
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        if (position != null) {
            sb.append("Last position: ");
            sb.append(position.toString());
            sb.append("\n");
        }

        if (direction != null) {
            sb.append("Last direction: ");
            sb.append(direction.toString());
            sb.append("\n");
        }
        sb.append(map.toString());

        return sb.toString();
    }
}

class Ground extends Pipe {
    public Ground(Position position) {
        super(position);
    }

    @Override
    public boolean canConnect(Direction direction) {
        return false;
    }

    @Override
    public String toString() {
        return ".";
    }
}

class Vertical extends Pipe {
    public Vertical(Position position) {
        super(position);
    }

    @Override
    public boolean canConnect(Direction direction) {
        if (direction == Direction.NORTH || direction == Direction.SOUTH) {
            return true;
        }

        return false;
    }

    @Override
    public String toString() {
        return "|";
    }
}

class Horizontal extends Pipe {
    public Horizontal(Position position) {
        super(position);
    }

    @Override
    public boolean canConnect(Direction direction) {
        if (direction == Direction.EAST || direction == Direction.WEST) {
            return true;
        }

        return false;
    }

    @Override
    public String toString() {
        return "-";
    }
}

class NorthEast extends Pipe {
    public NorthEast(Position position) {
        super(position);
    }

    @Override
    public boolean canConnect(Direction direction) {
        if (direction == Direction.NORTH || direction == Direction.EAST) {
            return true;
        }

        return false;
    }

    @Override
    public String toString() {
        return "L";
    }
}

class NorthWest extends Pipe {
    public NorthWest(Position position) {
        super(position);
    }

    @Override
    public boolean canConnect(Direction direction) {
        if (direction == Direction.NORTH || direction == Direction.WEST) {
            return true;
        }

        return false;
    }

    @Override
    public String toString() {
        return "J";
    }
}

class SouthEast extends Pipe {
    public SouthEast(Position position) {
        super(position);
    }

    @Override
    public boolean canConnect(Direction direction) {
        if (direction == Direction.SOUTH || direction == Direction.EAST) {
            return true;
        }

        return false;
    }

    @Override
    public String toString() {
        return "F";
    }
}

class SouthWest extends Pipe {
    public SouthWest(Position position) {
        super(position);
    }

    @Override
    public boolean canConnect(Direction direction) {
        if (direction == Direction.SOUTH || direction == Direction.WEST) {
            return true;
        }

        return false;
    }

    @Override
    public String toString() {
        return "7";
    }
}

class Start extends Pipe {
    public Start(Position position) {
        super(position);
    }

    @Override
    public boolean canConnect(Direction direction) {
        return true;
    }

    @Override
    public String toString() {
        return "S";
    }
}

class PipeFactory {
    static Pipe create(byte b, Position position) throws IllegalArgumentException {
        switch (b) {
            case (byte) '.':
                return new Ground(position);
            case (byte) '|':
                return new Vertical(position);
            case (byte) '-':
                return new Horizontal(position);
            case (byte) 'L':
                return new NorthEast(position);
            case (byte) 'J':
                return new NorthWest(position);
            case (byte) '7':
                return new SouthWest(position);
            case (byte) 'F':
                return new SouthEast(position);
            case (byte) 'S':
                return new Start(position);
            default:
                throw new IllegalArgumentException("Invalid character");
        }
    }
}
