class Ripple
{
  constructor(s)
  {
    this.rc = 0.85;
    this.mapA = new Array(s);
    this.mapB = new Array(s);
    for (var i = 0; i < this.mapA.length; i++)
    {
      this.mapA[i] = new Array(s);
      this.mapB[i] = new Array(s);
      for (var j = 0; j < this.mapA.length; j++)
      {
        this.mapA[i][j] = 0;
        this.mapB[i][j] = 0;
      }
    }
  }
  //----------------------------------------------------------------------------
  setMapPoint(step, note, value)
  {
    this.mapB[step][note] = ((value) ? -1.0 : 0.0);
  }

  swap()
  {
    var tmp = this.mapA;
    this.mapA = this.mapB;
    this.mapB = tmp;
  }
  //----------------------------------------------------------------------------
  update(step, note)
  {
    var amp = 0;
    if (note > 0)
    {
      amp += this.mapA[step][note - 1];
    }
    if (step > 0)
    {
      amp += this.mapA[step - 1][note];
    }
    if (note < 15)
    {
      amp += this.mapA[step][note + 1];
    }
    if (step < 15)
    {
      amp += this.mapA[step + 1][note];
    }
    amp = (amp * 0.5 - this.mapB[step][note]) * this.rc;
    amp = constrain(amp, -1, 1);
    this.mapB[step][note] = Math.tanh(amp);
    var gray = Math.floor(constrain(200.0 * amp, 0.0, 200.0));

    return gray;
  }
}
