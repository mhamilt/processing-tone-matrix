package de.despudelskern.application.tonematrix
{
  import com.audiotool.audio.AudioTimeInfo;
  import com.audiotool.audio.TimeEventNote;
  import com.audiotool.audio.TimeEventOutput;
  import com.audiotool.audio.TimeEventProcessor;
  import com.audiotool.audio.events.ITimeEventPool;
  import com.audiotool.audio.events.TimeEvents;

  public final class Sequencer extends TimeEventProcessor
  {

    public static const ONE_SIXTEENTH:int = AudioTimeInfo.toTicks(1,16);

    private static const NOTES:Vector.<int> = new Vector.<int>(16,true);

    {
      NOTES[0] = 96;
      NOTES[1] = 93;
      NOTES[2] = 91;
      NOTES[3] = 89;
      NOTES[4] = 86;
      NOTES[5] = 84;
      NOTES[6] = 81;
      NOTES[7] = 79;
      NOTES[8] = 77;
      NOTES[9] = 74;
      NOTES[10] = 72;
      NOTES[11] = 69;
      NOTES[12] = 67;
      NOTES[13] = 65;
      NOTES[14] = 62;
      NOTES[15] = 60;
    }

    private const TIME_EVENT_NOTE_POOL:ITimeEventPool = TimeEvents.pool(TimeEventNote);

    private var _timedEventOutput:TimeEventOutput;

    private var _pattern:Pattern;

    public function Sequencer(pattern:Pattern)
    {
      super();
      _pattern = pattern;
      _timedEventOutput = createTimeEventOutput();
    }

    public function get timedEventOutput() : TimeEventOutput
    {
      return _timedEventOutput;
    }

    override protected function processTimeEvents(t0:int, t1:int) : void
    {
      var noteIndex:int = 0;
      var _loc5_:* = null;
      var position:int = int(t0 / ONE_SIXTEENTH) * ONE_SIXTEENTH;
      var stepIndex:int = int(position / ONE_SIXTEENTH) % 16;
      do
      {
        if(position >= t0)
        {
          for(noteIndex = 0; noteIndex < 16; )
          {
            if(_pattern.getStep(stepIndex,noteIndex))
            {
              _loc5_ = TimeEventNote(TIME_EVENT_NOTE_POOL.pop());
              _loc5_.position = position;
              _loc5_.note = NOTES[noteIndex];
              _loc5_.velocity = 1;
              _timedEventOutput.insert(_loc5_);
            }
            noteIndex++;
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
  }
}
