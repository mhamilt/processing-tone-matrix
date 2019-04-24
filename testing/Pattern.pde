class Pattern
{
  //------------------------------------------------------------------------------------
  public static final int s = 16;
  private int radix = s;
  private boolean[][] steps = new boolean[s][s];
  String[] binArray = new String[s];
  //------------------------------------------------------------------------------------
  public float[][] mapA = new float[s][s];
  public float[][] mapB = new float[s][s];
  Pattern()
  {
    this.clear();
  }
  //------------------------------------------------------------------------------------
  public void setStepN(int step, int note, boolean value)
  {
    steps[step][note] = value;
    mapA[step][note] = ((value) ? -1.0 : 0.0);
  }
  //------------------------------------------------------------------------------------
  public boolean getStep(int step, int note)
  {
    return steps[step][note];
  }
  //------------------------------------------------------------------------------------
  public void clear()
  {
    for (int step = 0; step < 16; step++)
    {
      for (int note = 0; note < 16; note++)
      {
        setStepBlock(step, note, false);
      }
    }
  }
  //------------------------------------------------------------------------------------
  public void randomise()
  {
    for (int step = 0; step < s; step++)
    {
      for (int note = 0; note < s; note++)
      {
        setRandomBlock();
      }
    }
  }

  public void setRandomNote()
  {
    int step = int(random(16));
    int note = int(random(16));
    boolean val = !getStep(step, note);
    setStepBlock(step, note, val);
  }

  public void line()
  {
    for (int step = 0; step < s; step++)
    {
      for (int note = 0; note < s; note++)
      {
        if (step == note)
        {
          setStepBlock(step, note, true);
        }
      }
    }
  }

  //------------------------------------------------------------------------------------
  public void printMap()
  {
    println("\n-----------------------MAPA--------------------------");
    for (int step = 0; step < 16; step++)
    {
      for (int note = 0; note < 16; note++)
      {
        print(mapA[step][note]);
        print(" ");
      }
      println();
    }
    
    println("\n-----------------------MAPB--------------------------");
    for (int step = 0; step < 16; step++)
    {
      for (int note = 0; note < 16; note++)
      {
        print(mapB[step][note]);
        print(" ");
      }
      println();
    }
  }
}
