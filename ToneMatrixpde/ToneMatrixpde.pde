import processing.sound.*;

final int s = 16;
int[][] x = new int[s][s];
int size = 850;
//------------------------------------------------------------------------------------
// Grid Vars
int spacer = size/(4*s);
int[] pattern = new int[s]; 
int dotSize = (size/s)-(spacer);
//------------------------------------------------------------------------------------
// Sound Vars
private static final int[] note = {96, 93, 91, 89, 86, 84, 81, 79, 77, 74, 72, 69, 67, 65, 62, 60};
Env[] env;
SinOsc[] sine;
Delay[] delay;
float attackTime = 0.004;
float sustainTime = 0.004;
float sustainLevel = 0.5;
float releaseTime = 0.7;
//------------------------------------------------------------------------------------
Pattern pat = new Pattern();
//------------------------------------------------------------------------------------
// beat vars
int beat = 0;
int framesPerBeat = 20;
int bpm;
//------------------------------------------------------------------------------------
// animation variables
float[] pulseMap = new float[framesPerBeat]; // coefficients during beat pulse animations
int pa = 0; // pulse animation index;
float rc = 0.85;
//------------------------------------------------------------------------------------
int initialBlockCount = 10;
void settings()
{
  size(size+spacer, size+spacer);
}
//------------------------------------------------------------------------------------
void setup()
{
  background(0);
  stroke(50);
  fill(255);  
  for (int i = 0; i < 16; i++)
  {   
    pattern[i] = (1 << i);
  }

  initPulseMap();
  sine = new SinOsc[note.length];
  delay = new Delay[note.length];
  env  = new Env[note.length];

  for (int i = 0; i < note.length; ++i)
  {
    sine[i] = new SinOsc(this);
    sine[i].freq(midi2Hz(note[i]));
    sine[i].amp(0.303);

    delay[i] = new Delay(this);
    delay[i].process(sine[i], 0.1, 0.1);
    delay[i].feedback(0.4);

    env[i] = new Env(this);
  }
}
//------------------------------------------------------------------------------------
void draw()
{  
  background(0);
  setPattern();

  if (frameCount < initialBlockCount)
  {
  } else if ((frameCount % framesPerBeat) == 0)
  {
    if (beat == 0)
    {
      pat.setRandomNote();
    }
    for (int note = 0; note < 16; ++note)
    {
      if (pat.getStep(beat, note))
      {
        pat.mapB[beat][note] = -1;
      }
    }

    playSound();
  }
  if ((frameCount % framesPerBeat) == (framesPerBeat-1))
    pa = 0;
  pa++;
}


//------------------------------------------------------------------------------------
float midi2Hz(int midiNoteNumber)
{ 
  return pow(2, float(midiNoteNumber - 69)/12.0) * 440.0f;
}

void playSound()
{
  if (beat == 0)
  {
    //pat.setRandomBlock();
  }

  for (int i = 0; i < 16; i++)
  {
    if (pat.getStep(beat, i))
    {      
      env[i].play(sine[i], attackTime, sustainTime, sustainLevel, releaseTime);
    }
  }       
  beat++;
  beat %= note.length;
}


int fpb2bpm(int fpb)
{
  return (int(frameRate) * 60) / fpb;
}

int bpm2fpb(int bpm)
{
  return (int(frameRate) * 60) / bpm;
}
