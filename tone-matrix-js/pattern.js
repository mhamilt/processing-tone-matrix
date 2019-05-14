class Pattern
{
  constructor()
  {
    //----------------------------------------------------------------------------
    this.s = 16;
    this.ripple = new Ripple(s);
    this.steps = new Array(this.s);
    this.mapA = new Array(this.s);
    this.mapB = new Array(this.s);
    for (var i = 0; i < this.s; i++)
    {
      this.steps[i] = new Array(this.s);
      this.mapA[i] = new Array(this.s);
      this.mapB[i] = new Array(this.s);
    }
    this.binArray = new Array(this.s)
    this.clear();
  }
  //----------------------------------------------------------------------------
  setStepNote(step, note, value)
  {
    this.steps[step][note] = value;
    this.ripple.setMapPoint(step, note, value);
  }
  //----------------------------------------------------------------------------
  getStep(step, note)
  {
    return this.steps[step][note];
  }
  //----------------------------------------------------------------------------
  clear()
  {
    for (var step = 0; step < 16; step++)
    {
      for (var note = 0; note < 16; note++)
      {
        this.setStepNote(step, note, false);
      }
    }
  }
  //----------------------------------------------------------------------------
  randomise()
  {
    for (var step = 0; step < this.s; step++)
    {
      for (var note = 0; note < this.s; note++)
      {
        this.setRandomNote();
      }
    }
  }
  //----------------------------------------------------------------------------
  setRandomNote()
  {
    var step = Math.floor((Math.random() * 16));
    var note = Math.floor((Math.random() * 16));
    var val = !this.getStep(step, note);
    this.setStepNote(step, note, val);
  }
  //----------------------------------------------------------------------------
  line()
  {
    for (var step = 0; step < this.s; step++)
    {
      for (var note = 0; note < this.s; note++)
      {
        if (step == note)
        {
          this.setStepNote(step, note, true);
        }
      }
    }
  }
  //----------------------------------------------------------------------------
  draw()
  {
    if ((frameCount % framesPerBeat) == 0)
    {
      this.updateRipple();
    }

    for (var step = 0; step < 16; ++step)
    {
      var stepColor = (step == beat) ? 55 : 0;
      for (var note = 0; note < 16; ++note)
      {
        var x = this.ripple.update(step, note);
        if (this.getStep(step, note))
        {

          fill(180 + stepColor);
        }
        else
        {

          fill(40 + x);
        }

        rect((step * (screensize / 16)) + spacer, (note * (screensize / 16)) + spacer, dotSize, dotSize);
        if (this.getStep(step, note) && (step == beat))
        {
          // dotSize + (spacer * 4)
          image(glow_rect, (step * (screensize / 16)) - spacer, (note * (screensize / 16)) - spacer);
        }
      }
    }
    this.ripple.swap();
  }
  //----------------------------------------------------------------------------
  updateRipple() // do once per beat
  {
    for (var note = 0; note < 16; ++note)
    {
      if (pat.getStep(beat, note))
      {
        this.ripple.mapB[beat][note] = -1;
      }
    }
  }
}
