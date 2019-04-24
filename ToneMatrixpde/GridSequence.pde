class GridSequence
{
  int xn;
  int yn;
  int w;
  int h;
  int margin;
  int ss;
  // private Pattern _pattern;

  GridSequence(int nx, int ny, int mwidth, int mheight)
  {
    xn = nx;
    yn = ny;
    w = mwidth;
    h = mheight;
    margin = size/(4*s);
    dotSize = (w/nx)-(size/(4*nx));
  }

  void draw()
  {
    fill(80);
    for (int i = 0; i < 16; ++i)
    {
      // String binpat = new StringBuilder(binary(pattern[i],16)).reverse().toString();
      for (int j = 0; j < 16; ++j)
      {
        // boolean c = int(binpat.substring(j,j+1)) == 1 ? true : false;
        // if(c)
        // {
        //   fill(255);
        // }
        // else
        // {
        //   fill(100);
        // }
        rect((i * (w/16))+ margin, (j * (w/16)) + margin, ss, ss);
      }
    }
  }

  //----------------------------------------------------------------------------

  public void setSquare(int x, int y, int beatColour)
  {

  }
  public int getSquare(int x, int y, int beatColour)
  {
    
  }
}
