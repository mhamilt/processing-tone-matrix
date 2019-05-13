function setPattern()
{
  for (var step = 0; step < 16; ++step)
  {
    var stepColor = ((step == beat) && (pa < pulseMap.length)) ?
      var (pulseMap[pa] * 155.0) : 0;

    for (var note = 0; note < 16; ++note)
    {
      var rip = ripple(step, note);
      if (pat.getStep(step, note))
      {
        fill(100 + stepColor);
      }
      else
      {
        fill(40 + rip);
      }
      rect((step * (width / 16)) + spacer, (note * (width / 16)) + spacer, dotSize, dotSize);
    }
  }
  mapSwap();
}


function initPulseMap()
{
  for (var i = 0; i < pulseMap.length; ++i)
  {
    pulseMap[i] = sin(var (i) * PI /
      var (framesPerBeat));
  }
}

var ripple(var step,
  var note)
{
  var amp = 0;
  if (note > 0)
  {
    amp += pat.mapA[step][note - 1];
  }
  if (step > 0)
  {
    amp += pat.mapA[step - 1][note];
  }
  if (note < 15)
  {
    amp += pat.mapA[step][note + 1];
  }
  if (step < 15)
  {
    amp += pat.mapA[step + 1][note];
  }
  amp = (amp * 0.5 - pat.mapB[step][note]) * rc;
  amp = constrain(amp, -1, 1);
  pat.mapB[step][note] = amp;
  var gray =
    var (constrain(158.0 * amp, 0.0, 158.0));
  return gray;
}

function mapSwap()
{
  var [] tmp = pat.mapA;
  pat.mapA = pat.mapB;
  pat.mapB = tmp;
}
