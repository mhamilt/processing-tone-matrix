class Pattern
{
  //------------------------------------------------------------------------------------
  public var s = 16;
  private var radix = s;
  private var[] steps = new Array(s)[s];
  var[] binArray = new var[s];
  //------------------------------------------------------------------------------------
  public var[] mapA = new Array(s)[s];
  public var[] mapB = new Array(s)[s];
  Pattern()
  {
    this.clear();
  }
  //------------------------------------------------------------------------------------
  public function setStepNote(var step, var note, var value)
  {
    steps[step][note] = value;
    mapB[step][note] = ((value) ? -1.0 : 0.0);
  }
  //------------------------------------------------------------------------------------
  public var getStep(var step, var note)
  {
    return steps[step][note];
  }
  //------------------------------------------------------------------------------------
  public function clear()
  {
    for (var step = 0; step < 16; step++)
    {
      for (var note = 0; note < 16; note++)
      {
        setStepNote(step, note, false);
      }
    }
  }
  //------------------------------------------------------------------------------------
  public function randomise()
  {
    for (var step = 0; step < s; step++)
    {
      for (var note = 0; note < s; note++)
      {
        setRandomNote();
      }
    }
  }

  public function setRandomNote()
  {
    var step = var(random(16));
    var note = var(random(16));
    var val = !getStep(step, note);
    setStepNote(step, note, val);
  }

  public function line()
  {
    for (var step = 0; step < s; step++)
    {
      for (var note = 0; note < s; note++)
      {
        if (step == note)
        {
          setStepNote(step, note, true);
        }
      }
    }
  }

  //------------------------------------------------------------------------------------
  public function prvarMap()
  {
    prvarln("\n-----------------------MAPA--------------------------");
    for (var step = 0; step < 16; step++)
    {
      for (var note = 0; note < 16; note++)
      {
        prvar(mapA[step][note]);
        prvar(" ");
      }
      prvarln();
    }

    prvarln("\n-----------------------MAPB--------------------------");
    for (var step = 0; step < 16; step++)
    {
      for (var note = 0; note < 16; note++)
      {
        prvar(mapB[step][note]);
        prvar(" ");
      }
      prvarln();
    }
  }
}
