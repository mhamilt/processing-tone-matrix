import processing.sound.*;

final int s = 16;
int[][] x = new int[s][s];
int size = 400;
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
Reverb[] reverb;
float attackTime = 0.004;
float sustainTime = 0.004;
float sustainLevel = 0.5;
float releaseTime = 0.7;
//------------------------------------------------------------------------------------
Pattern pat = new Pattern();
//------------------------------------------------------------------------------------
// beat vars
int beat = 0;
int framesPerBeat = 10;
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
  stroke(70);
  fill(255);  
  for (int i = 0; i < 16; i++)
  {   
    pattern[i] = (1 << i);
  }

  initPulseMap();
  sine = new SinOsc[note.length];
  delay = new Delay[note.length];
  env  = new Env[note.length];
  reverb = new Reverb[note.length];
  for (int i = 0; i < note.length; ++i)
  {
    sine[i] = new SinOsc(this);
    sine[i].freq(midi2Hz(note[i]));
    sine[i].amp(0.303);

    delay[i] = new Delay(this);
    delay[i].process(sine[i], 0.1, 0.1);
    delay[i].feedback(0.4);

    reverb[i] = new Reverb(this);    
    env[i] = new Env(this);
  }
  //env = new Env(this);
  pat.line();
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
    pat.setRandomNote();
    pa = 0;
    playSound();
  }
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
      //env.play(sine[i], attackTime, sustainTime, sustainLevel, releaseTime);
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
