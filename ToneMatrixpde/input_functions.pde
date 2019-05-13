void keyPressed() 
{
  switch(key)
  {
  case 'b':  
  case'B':
    {
      pat.printMap();
      break;
    }
  case' ':
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

//------------------------------------------------------------------------------------

void mouseClicked()
{  
  //pat.clear();
  //for (int i = 0; i < initialBlockCount; i++)
  //{
  //  pat.setRandomNote();
  //}

  //pat.setStepNote((mouseX * s) / width, (mouseY * s) / height);
}

void mouseDragged() 
{
  int note = constrain((mouseX * s) / width, 0, s-1);
  int beat = constrain((mouseY * s) / height, 0, s-1);
  pat.setStepNote(note, beat, currentDragState);
}
