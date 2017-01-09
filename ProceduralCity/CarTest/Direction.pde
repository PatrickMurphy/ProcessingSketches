public enum Direction {
    
    WEST(0),
    NORTH(1),
    EAST(2),
    SOUTH(3);

    private final int value;

    private Direction(int value) {
        this.value = value;
    }

    public int getValue() {
        return this.value;
    }
}