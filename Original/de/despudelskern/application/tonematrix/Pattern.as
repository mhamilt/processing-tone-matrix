package de.despudelskern.application.tonematrix
{
  public final class Pattern
  {}
    public static const SIZE:int = 16;

    private const steps:Vector.<int> = new Vector.<int>(16,true);

    public function Pattern()
    {
      super();
    }

    public function setStep(x:int, y:int, value:Boolean) : void
    {
      if(value)
      {
        var _loc4_:* = x;
        var _loc5_:* = steps[_loc4_] | 1 << y;
        steps[_loc4_] = _loc5_;
      }
      else
      {
        _loc5_ = x;
        _loc4_ = steps[_loc5_] & ~(1 << y);
        steps[_loc5_] = _loc4_;
      }
    }

    public function getStep(x:int, y:int) : Boolean
    {
      return 0 != (steps[x] & 1 << y);
    }

    public function clear() : void
    {
      var x:int = 0;
      for(x = 0; x < 16; )
      {
        steps[x] = 0;
        x++;
      }
    }

    public function serialize() : String
    {
      var x:int = 0;
      var _loc1_:Array = [];
      for(x = 0; x < 16; )
      {
        _loc1_[x] = steps[x].toString(32);
        x++;
      }
      return _loc1_.join(".");
    }

    public function deserialize(string:String) : void
    {
      var x:int = 0;
      if(string == null)
      {
        return;
      }
      var _loc2_:Array = string.split(".");
      if(16 != _loc2_.length)
      {
        return;
      }
      x = 0;
      while(x < 16)
      {
        steps[x] = parseInt(_loc2_[x],32);
        x++;
      }
    }
  }
}
