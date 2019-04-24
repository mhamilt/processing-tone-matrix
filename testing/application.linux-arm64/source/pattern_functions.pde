void setPattern()
{
  for (int i = 0; i < 16; ++i)
  {         
    int stepColor = ((i == beat) && (pa < pulseMap.length)) ? int(pulseMap[pa] * 100.0) : 0;
    
    for (int j = 0; j < 16; ++j)
    {            
      if (pat.getStep(i, j))
      {
        fill(150 + stepColor);
      } else
      {
        fill(70);
      }
      rect((i * (width/16))+ spacer, (j * (width/16)) + spacer, dotSize, dotSize);
    }
  }
}


void initPulseMap()
{
  for (int i = 0; i < pulseMap.length; ++i)
  {
    pulseMap[i] = sin(float(i)*PI/float(framesPerBeat));
  }
}
