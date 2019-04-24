class Pattern
{
  public static final int SIZE = 16;
  private int radix = 32;
  private final int[] steps = new int[16];

  Pattern()
  {
  }

  public void setStep(int x, int y, boolean value)
  {
    steps[x] = (value) ? (steps[x] | (1 << y)) : steps[x] & ~(1 << y);
  }

  public boolean getStep(int x, int y)
  {
    return 0 != (steps[x] & 1 << y);
  }

  public void clear()
  {
    for (int x = 0; x < 16; x++)
    {
      steps[x] = 0;
    }
  }

  public String serialize()
  {
    int[]  = new int[16];
    for (int x = 0; x < 16; x++)
    {
      binArray[x] = steps[x].toString(radix);
    }
    return binArray.join(".");
  }

  public String deserialize(String string)
  {
    if (string == null || 16 != string.length)
    {
      return null;
    }

    String bin = string.split(".");

    for (int x = 0; x < 16; x++)
    {
      steps[x] = parseInt(bin[x], radix);
    }
  }
}
