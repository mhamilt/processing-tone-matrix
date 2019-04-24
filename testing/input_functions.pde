void keyPressed() 
{
  switch(key)
  {
  case 'b':  
  case'B':
    {
      println("hello");
      break;
    }
  case' ':
    {
      pat.clear();
      break;
    }
  default:
    {
      switch(keyCode)
      {
      case UP:
        {
          framesPerBeat--;
          framesPerBeat = (framesPerBeat <= 5) ? 5: framesPerBeat;
          println(framesPerBeat);
          break;
        }
      case DOWN:
        {
          framesPerBeat++;
          framesPerBeat = (framesPerBeat >= 25) ? 25: framesPerBeat;
          println(framesPerBeat);
          break;
        }
      }
    }
  }
}
