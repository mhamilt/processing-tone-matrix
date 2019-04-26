import processing.sound.*;

class Sequencer
{
  // public static final int ONE_SIXTEENTH = AudioTimeInfo.toTicks(1,16);
  //     private const TIME_EVENT_NOTE_POOL:ITimeEventPool = TimeEvents.pool(TimeEventNote);
  // private var _timedEventOutput:TimeEventOutput;
  private Pattern _pattern;
  private static final int notes = {96, 93, 91, 89, 86, 84, 81, 79, 77, 74, 72, 69, 67, 65, 62, 60};
  private SinOsc[] sine;
  private Delay[] delay;
  Env env;
  float attackTime = 0.004;
  float sustainTime = 0.004;
  float sustainLevel = 0.5;
  float releaseTime = 0.7;
  Sequencer(Pattern pattern)
  {
    _pattern = pattern;
    for (int i = 0; i < note.length; ++i)
    {
      sine[i] = new SinOsc(this);
      sine[i].freq(midi2Hz(note[i]));
      sine[i].amp(0.303);

      delay[i] = new Delay(this);
      delay[i].process(sine[i],0.1,0.1);
      delay[i].feedback(0.4);
    }
  }

  public function get timedEventOutput() : TimeEventOutput
  {
    return _timedEventOutput;
  }

  protected void process(t0:int, t1:int)
  {    
    for(int noteIndex = 0; noteIndex < 16; noteIndex++;)
    {
      if(_pattern.getStep(stepIndex,noteIndex))
      {
        env.play(sine[noteIndex], attackTime, sustainTime, sustainLevel, releaseTime);
      }

    }
  }
  position = position + ONE_SIXTEENTH;
  stepIndex++;
  if(stepIndex >= 16)
  {
    stepIndex = 0;
  }
}
while(position < t1);

}

float midi2Hz(int midiNoteNumber)
{
  return pow(2, float(midiNoteNumber - 69)/12.0) * 440.0f;
}
}
