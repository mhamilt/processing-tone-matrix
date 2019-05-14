
//------------------------------------------------------------------------------
function mousePressed()
{
  if (
    mouseX > 0 &&
    mouseX < width &&
    mouseY > 0 &&
    mouseY < height
  )
  {
    getAudioContext().resume()
    var note = Math.floor(constrain((mouseX * s) / width, 0, s - 1));
    var beat = Math.floor(constrain((mouseY * s) / height, 0, s - 1));

    if (!drawLock)
    {
      drawStyle = !pat.getStep(note, beat);
      drawLock = true;
    }

    pat.setStepNote(note, beat, drawStyle);
  }
}
//------------------------------------------------------------------------------
function mouseDragged()
{
  if (
    mouseX > 0 &&
    mouseX < width &&
    mouseY > 0 &&
    mouseY < height
  )
  {
    var note = Math.floor(constrain((mouseX * s) / width, 0, s - 1));
    var beat = Math.floor(constrain((mouseY * s) / height, 0, s - 1));

    pat.setStepNote(note, beat, drawStyle);
  }
}
//------------------------------------------------------------------------------

function mouseReleased()
{
  drawLock = false;
}

//------------------------------------------------------------------------------
function keyPressed()
{
  switch (key)
  {
    case ' ':
      pat.clear();
      break;
    default:
      return false;

  }
}
