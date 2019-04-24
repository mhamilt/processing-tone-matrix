package de.despudelskern.application.tonematrix
{
  import com.audiotool.events.Events;
  import com.audiotool.ui.events.UIEvent;
  import com.audiotool.ui.events.UIKeyboardEvent;
  import com.audiotool.ui.events.UIMouseEvent;
  import com.audiotool.ui.events.UISprite;
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.filters.BlurFilter;
  import flash.geom.Point;
  import flash.geom.Rectangle;

  public final class PatternView extends UISprite
  {
    private var _pattern:Pattern;

    private var _mapA:Vector.<Vector.<Number>>;

    private var _mapB:Vector.<Vector.<Number>>;

    private var _size:int;

    private var _wavemap:BitmapData;

    private var _layerPattern:Sprite;

    private var _bitmapDots:Bitmap;

    private var _bitmapStep:Bitmap;

    private var _bitmapWave:Bitmap;

    private var _bitmapStepData:BitmapData;

    private var _stepIndex:int = 15;

    private var _v:Boolean;

    public function PatternView(pattern:Pattern, size:int)
    {
      super();
      _pattern = pattern;
      _size = size;
      _mapA = _create2DMap();
      _mapB = _create2DMap();
      var xn:int = 16;
      var yn:int = 16;
      _layerPattern = new Sprite();
      _layerPattern.blendMode = "normal";
      addChild(_layerPattern);
      _bitmapDots = new Bitmap(createMatrix(size,yn,xn));
      _layerPattern.addChild(_bitmapDots);
      _bitmapStepData = new BitmapData(16,16,false,11579568);
      _bitmapStep = new Bitmap(_bitmapStepData,"always",false);
      var _loc5_:* = size;
      _bitmapStep.scaleY = _loc5_;
      _bitmapStep.scaleX = _loc5_;
      _bitmapStep.blendMode = "subtract";
      _layerPattern.addChild(_bitmapStep);
      _wavemap = new BitmapData(xn,yn,false,0);
      _bitmapWave = new Bitmap(_wavemap,"always",false);
      _loc5_ = size;
      _bitmapWave.scaleY = _loc5_;
      _bitmapWave.scaleX = _loc5_;
      _bitmapWave.blendMode = "add";
      _bitmapWave.filters = [new BlurFilter(16,16,2)];
      addChild(_bitmapWave);
      Events.enterFrame.add(run);
    }

    override public function processEvent(event:UIEvent) : void
    {
      if(event.type == 257)
      {
        mouseDown(UIMouseEvent(event));
      }
      else if(event.type == 258)
      {
        mouseMove(UIMouseEvent(event));
      }
      else if(event.type == 513)
      {
        if(UIKeyboardEvent(event).keyCode == 32)
        {
          _pattern.clear();
          _bitmapStepData.fillRect(_bitmapStepData.rect,11579568);
        }
      }
    }

    public function update() : void
    {
      var x:int = 0;
      var y:int = 0;
      for(x = 0; x < 16; )
      {
        for(y = 0; y < 16; )
        {
          setStep(x,y,_pattern.getStep(x,y));
          y++;
        }
        x++;
      }
    }

    public function set stepIndex(value:int) : void
    {
      _stepIndex = value;
    }

    private function run() : void
    {
      var amp:* = NaN;
      var gray:int = 0;
      var x:int = 0;
      var y:int = 0;
      var xn:int = 16;
      var yn:int = 16;
      var x1:int = xn - 1;
      var y1:int = yn - 1;
      var index:int = _stepIndex + 1;
      if(index < 0)
      {
        index = index + 16;
      }
      else if(index >= 16)
      {
        index = index - 16;
      }
      y = 0;
      while(y < 16)
      {
        if(_pattern.getStep(index,y))
        {
          _mapB[y][index] = -1;
        }
        y++;
      }
      for(y = 0; y < yn; )
      {
        for(x = 0; x < xn; )
        {
          amp = 0;
          if(x > 0)
          {
            amp = Number(amp + _mapA[y][x - 1]);
          }
          if(y > 0)
          {
            amp = Number(amp + _mapA[y - 1][x]);
          }
          if(x < x1)
          {
            amp = Number(amp + _mapA[y][x + 1]);
          }
          if(y < y1)
          {
            amp = Number(amp + _mapA[y + 1][x]);
          }
          amp = Number((amp * 0.5 - _mapB[y][x]) * 0.85);
          if(amp < -1)
          {
            amp = -1;
          }
          else if(amp > 1)
          {
            amp = 1;
          }
          _mapB[y][x] = amp;
          gray = 128 * amp;
          if(gray < 0)
          {
            gray = 0;
          }
          else if(gray > 128)
          {
            gray = 128;
          }
          _wavemap.setPixel(x,y,gray << 16 | gray << 8 | gray);
          x++;
        }
        y++;
      }
      var tmp:Vector.<Vector.<Number>> = _mapA;
      _mapA = _mapB;
      _mapB = tmp;
    }

    private function mouseDown(event:UIMouseEvent) : void
    {
      var p:Point = globalToLocal(event.mousePos);
      var x:int = p.x / _size;
      var y:int = p.y / _size;
      if(x > -1 && x < 16 && y > -1 && y < 16)
      {
        _v = !_pattern.getStep(x,y);
        setStep(x,y,_v);
      }
    }

    private function mouseMove(event:UIMouseEvent) : void
    {
      var p:Point = globalToLocal(event.mousePos);
      var x:int = p.x / _size;
      var y:int = p.y / _size;
      if(event.isDown)
      {
        if(x > -1 && x < 16 && y > -1 && y < 16)
        {
          setStep(x,y,_v);
        }
      }
    }

    private function setStep(x:int, y:int, value:Boolean) : void
    {
      var c:int = !!value?0:11579568;
      _pattern.setStep(x,y,value);
      if(_bitmapStepData.getPixel(x,y) != c)
      {
        _mapA[y][x] = -1;
        _bitmapStepData.setPixel(x,y,c);
      }
    }

    private function createMatrix(size:int, xn:int, yn:int) : BitmapData
    {
      var texture:* = null;
      var shape:* = null;
      texture = new BitmapData(size,size,false,0);
      texture.fillRect(new Rectangle(3,3,size - 6,size - 6),16777215);
      texture.fillRect(new Rectangle(5,5,size - 10,size - 10),14342874);
      texture.applyFilter(texture,texture.rect,new Point(),new BlurFilter(2,2,3));
      shape = new Shape();
      shape.graphics.beginBitmapFill(texture);
      shape.graphics.drawRect(0,0,yn * size,xn * size);
      shape.graphics.endFill();
      texture = new BitmapData(yn * size,xn * size,true,0);
      texture.draw(shape);
      return texture;
    }

    private Vector.<Vector.<Number>> _create2DMap()
    {
      var map:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>(16,true);
      var y:int = 0;
      while(y < 16)
      {
        map[y] = new Vector.<Number>(16,true);
        y++;
      }
      return map;
    }
  }
}
