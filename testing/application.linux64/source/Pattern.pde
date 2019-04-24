class Pattern
{
  //------------------------------------------------------------------------------------
  public static final int SIZE = 16;
  private int radix = 16;
  private int[] steps = new int[16];
  String[] binArray = new String[16];
  //------------------------------------------------------------------------------------
  Pattern()
  {
  }
//------------------------------------------------------------------------------------
  public void setStepBlock(int x, int y, boolean value)
  {
    steps[x] = (value) ? (steps[x] | (1 << y)) : steps[x] & ~(1 << y);
  }
//------------------------------------------------------------------------------------
  public boolean getStep(int x, int y)
  {
    return 0 != (steps[x] & 1 << y);
  }
//------------------------------------------------------------------------------------
  public void clear()
  {
    for (int x = 0; x < 16; x++)
    {
      steps[x] = 0;
    }
  }
  //------------------------------------------------------------------------------------
  public void randomise()
  {
    for (int x = 0; x < 16; x++)
    {
      steps[x] = int(random(0,65536));
    }
  }
  
  public void setRandomBlock()
  {
    int x = int(random(16));
    int y = int(random(16));
    boolean val = !getStep(x,y);
    setStepBlock(x,y,val);
  }
  
  public void line()
  {
    for (int x = 0; x < 16; x++)
    {
      steps[x] = int(random(0,65536));
    }
  }
//------------------------------------------------------------------------------------
  public String serialize()
  {
    for (int x = 0; x < 16; x++)
    {
      binArray[x] = new StringBuilder(binary(steps[x], 16)).reverse().toString();       
    }
    return join(binArray,".");
  }
//------------------------------------------------------------------------------------
  public void deserialize(String str)
  {
    
    if (str == null || 16 != str.length())
    {
      return;
    }
    
    String[] bin = str.split(".");

    for (int x = 0; x < 16; x++)
    {
      steps[x] = parseInt(bin[x], radix);
    }    
  }
  //------------------------------------------------------------------------------------
}
