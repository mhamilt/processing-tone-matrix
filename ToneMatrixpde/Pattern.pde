class ToneMatrix
{
  //------------------------------------------------------------------------------------
  public static final int s = 16;
  private int radix = s;
  private boolean[][] steps     = new boolean[s][s];
  private boolean[][] stepsCopy = new boolean[s][s];
  boolean wrapMove = false;
  String[] binArray = new String[s];
  //------------------------------------------------------------------------------------
  float[] pulseMap = new float[framesPerBeat]; // coefficients during beat pulse animations
  public float[][] mapA = new float[s][s];
  public float[][] mapB = new float[s][s];
  //------------------------------------------------------------------------------------
  ToneMatrix()
  {
    this.clear();
    this.initPulseMap();
  }
  //------------------------------------------------------------------------------------
  public void setStepNote(int beat, int note, boolean value)
  {
    steps[beat][note] = value;
    mapB[beat][note] = ((value) ? -1.0 : 0.0);
  }
  //------------------------------------------------------------------------------------
  public boolean getStep(int beat, int note)
  {
    return steps[beat][note];
  }
  //------------------------------------------------------------------------------------
  public void clear()
  {
    for (int beat = 0; beat < 16; beat++)
    {
      for (int note = 0; note < 16; note++)
      {
        setStepNote(beat, note, false);
      }
    }
  }
  //------------------------------------------------------------------------------------
  public void randomise()
  {
    for (int beat = 0; beat < s; beat++)
    {
      for (int note = 0; note < s; note++)
      {
        setRandomNote();
      }
    }
  }

  public void setRandomNote()
  {
    int beat = int(random(16));
    int note = int(random(16));
    boolean val = !getStep(beat, note);
    setStepNote(beat, note, val);
  }

  public void line()
  {
    for (int beat = 0; beat < s; beat++)
    {
      for (int note = 0; note < s; note++)
      {
        if (beat == note)
        {
          setStepNote(beat, note, true);
        }
      }
    }
  }

  //------------------------------------------------------------------------------------
  public void printMap()
  {
    println("\n-----------------------MAPA--------------------------");
    for (int beat = 0; beat < 16; beat++)
    {
      for (int note = 0; note < 16; note++)
      {
        print(mapA[beat][note]);
        print(" ");
      }
      println();
    }

    println("\n-----------------------MAPB--------------------------");
    for (int beat = 0; beat < 16; beat++)
    {
      for (int note = 0; note < 16; note++)
      {
        print(mapB[beat][note]);
        print(" ");
      }
      println();
    }
  }
  //------------------------------------------------------------------
  // Arrangement: Functions for arranging and automating playback

  public void move(int direction)
  {

    for (int beat = 0; beat < 16; beat++)
    {
      for (int note = 0; note < 16; note++)
      {
        stepsCopy[beat][note] = steps[beat][note];
      }
    }

    switch(direction)
    {
    case UP:
      for (int beat = 0; beat < 16; beat++)
      {
        for (int note = 0; note < 15; note++)
        {
          setStepNote(beat, note, stepsCopy[beat][note+1]);
        }
      }
      for (int beat = 0; beat < 16; beat++)
      {
        setStepNote(beat, 15, false);
      }
      break;
    case DOWN:
      for (int beat = 0; beat < 16; beat++)
      {
        for (int note = 1; note < 16; note++)
        {
          setStepNote(beat, note, stepsCopy[beat][note-1]);
        }
      }
      for (int beat = 0; beat < 16; beat++)
      {
        setStepNote(beat, 0, false);
      }
      break;
    case LEFT:
      for (int beat = 0; beat < 15; beat++)
      {
        for (int note = 0; note < 16; note++)
        {
          setStepNote(beat, note, stepsCopy[beat+1][note]);
        }
      }
      for (int note = 0; note < 16; note++)
      {
        setStepNote(15, note, false);
      }
      break;
    case RIGHT:
      for (int beat = 1; beat < 16; beat++)
      {
        for (int note = 0; note < 16; note++)
        {
          setStepNote(beat, note, stepsCopy[beat-1][note]);
        }
      }

      if (wrapMove)
      {
        for (int note = 0; note < 16; note++)
          setStepNote(beat, note, stepsCopy[beat-1][note]);
      } else
      {
        for (int note = 0; note < 16; note++)
          setStepNote(0, note, false);
      }

      break;
    }
  }

  public void draw(int b)
  {
    int cx = ((width  - size-spacer) / 2);
    int cy = ((height - size-spacer) / 2);

    push();
    translate(cx, cy);

    for (int beat = 0; beat < 16; ++beat)
    {
      //int stepColor = ((beat == b) && (pa < pulseMap.length)) ? int(pulseMap[pa] * 100.0) : 0;

      for (int note = 0; note < 16; ++note)
      {
        int rip = ripple(beat, note);
        if (pat.getStep(beat, note))
        {
          fill(((beat == b)?255:150));
        } else
        {
          fill(40 + rip);
        }
        rect((beat * (size/16)) + spacer, (note * (size/16)) + spacer, dotSize, dotSize);
      }
    }

    pop();
    mapSwap();
  }

  private void initPulseMap()
  {
    for (int i = 0; i < pulseMap.length; ++i)
    {
      pulseMap[i] = sin(float(i)*PI/float(framesPerBeat));
    }
  }

  private int ripple(int step, int note)
  {
    float amp = 0;
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
    int gray = int(constrain(158.0 * amp, 0.0, 158.0));
    return gray;
  }

  private void mapSwap()
  {
    float[][] tmp = pat.mapA;
    pat.mapA = pat.mapB;
    pat.mapB = tmp;
  }
}
