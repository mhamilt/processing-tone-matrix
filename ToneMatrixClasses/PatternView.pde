/* Pattern View:
 
 How the ToneMatrix actually looks on screen and it's associated animations
 */


class PatternView
{
  //----------------------------------------------------------------------------
  private Pattern _pattern; // incoming pattern
  private int[][] _mapA;
  private int[][] _mapB;
  private int _size;
  private BitmapData _wavemap;
  private Sprite _layerPattern;
  private Bitmap _bitmapDots;
  private Bitmap _bitmapStep;
  private Bitmap _bitmapWave;
  private Bitmap _bitmapStepData;
  private int _stepIndex = 15;
  private boolean _v;
  private int xn = 16;
  private int yn = 16;
  int xlim = xn - 1;
  int ylim = yn - 1;
  // Colours
  private int beatColour = 0xFFFFFF;
  private int onColour = 0xCCCCCC;
  private int rippleColour = 0xB0B0B0;
  private int offColour = 0x999999;
  private int grey = 0x808080;

  //----------------------------------------------------------------------------
  PatternView(Pattern pattern, int size)
  {
    super();
    _pattern = pattern;
    _size = size;
    _mapA = _create2DMap();
    _mapB = _create2DMap();
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Draw xn X yn rectangles
    _layerPattern = new Sprite();
    _layerPattern.blendMode = "normal";
    addChild(_layerPattern);
    _bitmapDots = new Bitmap(createMatrix(size, yn, xn));
    _layerPattern.addChild(_bitmapDots);
    _bitmapStepData = new BitmapData(16, 16, false, offColour);
    _bitmapStep = new Bitmap(_bitmapStepData, "always", false);
    _bitmapStep.scaleY = size;
    _bitmapStep.scaleX = size;
    _bitmapStep.blendMode = "subtract";
    _layerPattern.addChild(_bitmapStep);
    _wavemap = new BitmapData(xn, yn, false, 0);
    _bitmapWave = new Bitmap(_wavemap, "always", false);
    _bitmapWave.scaleY = size;
    _bitmapWave.scaleX = size;
    _bitmapWave.blendMode = "add";
    _bitmapWave.filters = [new BlurFilter(16, 16, 2)];
    addChild(_bitmapWave);
    Events.enterFrame.add(run);
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  }
  //----------------------------------------------------------------------------
  // Update UI
  void draw()
  {
    processEvent();
    update();

    float amp;
    int gray = 0;
    int x1 = xn - 1;
    int y1 = yn - 1;
    int index = _stepIndex + 1;

    if (index < 0)
    {
      index = index + 16;
    } else if (index >= 16)
    {
      index = index - 16;
    }

    for (int y = 0; y < yn; y++ )
    {
      if (_pattern.getStep(index, y))
      {
        _mapB[y][index] = -1;
      }
      for (int x = 0; x < xn; x++)
      {
        amp = 0;
        if (x > 0)
        {
          amp = amp + _mapA[y][x - 1];
        }
        if (y > 0)
        {
          amp = amp + _mapA[y - 1][x];
        }
        if (x < xlim)
        {
          amp = amp + _mapA[y][x + 1];
        }
        if (y < ylim)
        {
          amp = amp + _mapA[y + 1][x];
        }

        amp = (amp * 0.5 - _mapB[y][x]) * 0.85;
        amp = constrain(amp, -1, 1);
        _mapB[y][x] = amp;
        gray = constrain(128.0 * amp, 0, 128);
        int beatColour = grey*amp;
        _wavemap.setPixel(x, y, beatColour);
      }
    }
    int[][] tmp = _mapA;
    _mapA = _mapB;
    _mapB = tmp;
  }
  //----------------------------------------------------------------------------
  public void update()
  {
    for (int x = 0; x < 16; x++; )
    {
      for (int y = 0; y < 16; y++; )
      {
        setStep(x, y, _pattern.getStep(x, y));
      }
    }
  }
  //----------------------------------------------------------------------------
  // Getters and Setters
  void setStepIndex(int value)
  {
    _stepIndex = value;
  }

  private void setStep(int x, int y, boolean value)
  {
    int c = ((value) ? 0 : offColour);
    _pattern.setStep(x, y, value);
    if (_bitmapStepData.getPixel(x, y) != c)
    {
      _mapA[y][x] = -1;
      _bitmapStepData.setPixel(x, y, c);
    }
  }
  //----------------------------------------------------------------------------
  // UI events
  public void processEvent()
  {
    if (mouseDown)
    {
      onClick()
    } else if (mouseDragged)
    {
      mouseMove(UIMouseEvent(event));
    } else if (spacebar)
    {
      _pattern.clear();
      _bitmapStepData.fillRect(_bitmapStepData.rect, offColour);
    }
  }

  private void onClick()
  {
    int x = mouseX / _size;
    int y = mouseY / _size;
    if (x > -1 &&
      x < 16 &&
      y > -1 &&
      y < 16 )
    {
      _v = !_pattern.getStep(x, y); // value becomes opposite
      setStep(x, y, _v);
    }
  }

  private void mouseDrag()
  {
    int x = mouseX / _size;
    int y = mouseY / _size;
    if (x > -1 &&
      x < 16 &&
      y > -1 &&
      y < 16 )
    {
      _v = !_pattern.getStep(x, y); // value becomes opposite
      setStep(x, y, _v);
    }
  }

  //----------------------------------------------------------------------------
  // Initialise UI
  private BitmapData createMatrix(int size, int xn, int yn)
  {
  BitmapData texture:
    * = null;
  BitmapData shape:
    * = null;
    texture = new BitmapData(size, size, false, 0);
    texture.fillRect(new Rectangle(3, 3, size - 6, size - 6), beatColour);
    texture.fillRect(new Rectangle(5, 5, size - 10, size - 10), onColour);
    texture.applyFilter(texture, texture.rect, new Point(), new BlurFilter(2, 2, 3));
    shape = new Shape();
    shape.graphics.beginBitmapFill(texture);
    shape.graphics.drawRect(0, 0, yn * size, xn * size);
    shape.graphics.endFill();
    texture = new BitmapData(yn * size, xn * size, true, 0);
    texture.draw(shape);
    return texture;
  }

  private int[][] _create2DMap()
  {
    int[][] map = new int[xn][yn];
    return map;
  }
}
