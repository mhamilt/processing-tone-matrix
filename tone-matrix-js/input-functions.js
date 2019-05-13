function keyPressed()
{
  switch (key)
  {
    case 'b':
    case 'B':
    {
      pat.prvarMap();
      break;
    }
    case ' ':
    {
      pat.clear();
      break;
    }
    case 's':
    {
      rc -= 0.05;
      rc = constrain(rc, 0.05, 0.85);
      break;
    }
    case 'w':
    {
      rc += 0.05;
      rc = constrain(rc, 0.05, 0.85);
      break;
    }
    default:
    {
      switch (keyCode)
      {
        case UP:
        {
          framesPerBeat--;
          framesPerBeat = (framesPerBeat <= 5) ? 5 : framesPerBeat;
          prvarln(framesPerBeat);
          break;
        }
        case DOWN:
        {
          framesPerBeat++;
          framesPerBeat = (framesPerBeat >= 25) ? 25 : framesPerBeat;
          prvarln(framesPerBeat);
          break;
        }
      }
    }
  }
}

//------------------------------------------------------------------------------------

function mouseClicked()
{
  pat.clear();
  for (var i = 0; i < initialBlockCount; i++)
  {
    pat.setRandomNote();
  }
}
