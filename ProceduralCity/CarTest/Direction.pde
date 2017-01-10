public enum Direction {

  WEST(0), 
    NORTH(1), 
    EAST(2), 
    SOUTH(3);

  private final int value;

  private Direction(int value) {
    this.value = value;
  }

  // get enum type from int value
  public static Direction getEnum(int value) {
    for (Direction e : Direction.class.getEnumConstants()) {
      if (e.getValue() == (value)) {
        return e;
      }
    }
    return Direction.NORTH;
  }
  
  

  public int getValue() {
    return this.value;
  }
}