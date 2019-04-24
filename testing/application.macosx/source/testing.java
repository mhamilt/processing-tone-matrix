import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class testing extends PApplet {



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
float attackTime = 0.004f;
float sustainTime = 0.004f;
float sustainLevel = 0.5f;
float releaseTime = 0.7f;
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
int[][] gridMapA = new int[s][s];
int[][] gridMapB = new int[s][s];
//------------------------------------------------------------------------------------
int initialBlockCount = 10;
public void settings()
{
  size(size+spacer, size+spacer);
}
//------------------------------------------------------------------------------------
public void setup()
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

  for (int i = 0; i < note.length; ++i)
  {
    sine[i] = new SinOsc(this);
    sine[i].freq(midi2Hz(note[i]));
    sine[i].amp(0.303f);

    delay[i] = new Delay(this);
    delay[i].process(sine[i], 0.1f, 0.1f);
    delay[i].feedback(0.4f);

    env[i] = new Env(this);
  }
  //env = new Env(this);
}
//------------------------------------------------------------------------------------
public void draw()
{
  background(0);
  setPattern();

  if (frameCount < initialBlockCount)
  {
    pat.setRandomBlock();
  } else if ((frameCount % framesPerBeat) == 0)
  {   
    pa = 0;
    playSound();
  }
  pa++;
}
//------------------------------------------------------------------------------------
public void mouseClicked()
{  
  pat.clear();
  for (int i = 0; i < initialBlockCount; i++)
  {
    pat.setRandomBlock();
  }
}
//------------------------------------------------------------------------------------
public float midi2Hz(int midiNoteNumber)
{ 
  return pow(2, PApplet.parseFloat(midiNoteNumber - 69)/12.0f) * 440.0f;
}

public void playSound()
{
  if (beat == 0)
  {
    pat.setRandomBlock();
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
class Pattern
{
  //------------------------------------------------------------------------------------
  public static final int SIZE = 16;
  private int radix = 16;
  private int[] steps = new int[16];
  String[] binArray = new String[16];
  //------------------------------------------------------------------------------------
  Pattern()
  {
  }
//------------------------------------------------------------------------------------
  public void setStepBlock(int x, int y, boolean value)
  {
    steps[x] = (value) ? (steps[x] | (1 << y)) : steps[x] & ~(1 << y);
  }
//------------------------------------------------------------------------------------
  public boolean getStep(int x, int y)
  {
    return 0 != (steps[x] & 1 << y);
  }
//------------------------------------------------------------------------------------
  public void clear()
  {
    for (int x = 0; x < 16; x++)
    {
      steps[x] = 0;
    }
  }
  //------------------------------------------------------------------------------------
  public void randomise()
  {
    for (int x = 0; x < 16; x++)
    {
      steps[x] = PApplet.parseInt(random(0,65536));
    }
  }
  
  public void setRandomBlock()
  {
    int x = PApplet.parseInt(random(16));
    int y = PApplet.parseInt(random(16));
    boolean val = !getStep(x,y);
    setStepBlock(x,y,val);
  }
  
  public void line()
  {
    for (int x = 0; x < 16; x++)
    {
      steps[x] = PApplet.parseInt(random(0,65536));
    }
  }
//------------------------------------------------------------------------------------
  public String serialize()
  {
    for (int x = 0; x < 16; x++)
    {
      binArray[x] = new StringBuilder(binary(steps[x], 16)).reverse().toString();       
    }
    return join(binArray,".");
  }
//------------------------------------------------------------------------------------
  public void deserialize(String str)
  {
    
    if (str == null || 16 != str.length())
    {
      return;
    }
    
    String[] bin = str.split(".");

    for (int x = 0; x < 16; x++)
    {
      steps[x] = parseInt(bin[x], radix);
    }    
  }
  //------------------------------------------------------------------------------------
}
public void keyPressed() 
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
public void setPattern()
{
  for (int i = 0; i < 16; ++i)
  {         
    int stepColor = ((i == beat) && (pa < pulseMap.length)) ? PApplet.parseInt(pulseMap[pa] * 100.0f) : 0;
    
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


public void initPulseMap()
{
  for (int i = 0; i < pulseMap.length; ++i)
  {
    pulseMap[i] = sin(PApplet.parseFloat(i)*PI/PApplet.parseFloat(framesPerBeat));
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "testing" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
