package de.despudelskern.application.tonematrix
{
  import com.audiotool.audio.AudioTimeInfo;
  import com.audiotool.audio.Signal;
  import com.audiotool.audio.SignalBuffer;
  import com.audiotool.audio.SignalOutput;
  import com.audiotool.audio.SignalProcessor;
  import com.audiotool.audio.TimeEventNote;
  import com.audiotool.audio.events.ITimeEvent;
  import com.audiotool.collections.managed.IManagedObjectIterator;
  import com.audiotool.collections.managed.IManagedObjectList;
  import com.audiotool.collections.managed.ManagedObjectLinkedList;
  import com.audiotool.math.nextPow2;

  public final class Processor extends SignalProcessor
  {


    private const processList:IManagedObjectList = new ManagedObjectLinkedList(Voice);

    private const delayOffset:Number = AudioTimeInfo.ticksToNumSamplesWithTempo(AudioTimeInfo.toTicks(3,16),120);

    private const delaySize:int = nextPow2(delayOffset);

    private const delayBuffer:SignalBuffer = new SignalBuffer(delaySize,true,true);

    private const delayWet:Number = 0.08;

    private const delayFeedback:Number = 0.4;

    private const delayLfoRate:Number = 6.802721088435374E-5;

    private var _signalOutput:SignalOutput;

    private var lfoPhase:Number;

    private var delayHead:Signal;

    private var delayIndex:int;

    public function Processor()
    {
      super();
      init();
    }

    override protected function reset() : void
    {
      processList.clear();
    }

    private function init() : void
    {
      _signalOutput = createSignalOutput();
      lfoPhase = 0;
      delayHead = delayBuffer.first;
      delayIndex = 0;
    }

    override protected function processSignals(numSignals:int) : void
    {
      _signalOutput.zero(numSignals);
      var _loc2_:Signal = _signalOutput.current;
      processVoices(_loc2_,numSignals);
      processDelay(_loc2_,numSignals);
    }

    private function processDelay(current:Signal, numSignals:int) : void
    {
      var i:int = 0;
      var _loc9_:Number = NaN;
      var _loc11_:Number = NaN;
      var lfo:Number = NaN;
      var pNum:Number = NaN;
      var _loc7_:int = 0;
      var _loc5_:Number = NaN;
      var _loc12_:* = null;
      var _loc13_:* = null;
      var _loc8_:Number = NaN;
      var _loc10_:Number = NaN;
      var _loc3_:Vector.<Signal> = delayBuffer.signals;
      for(i = 0; i < numSignals; )
      {
        _loc9_ = current.c0;
        _loc11_ = current.c1;
        lfo = lfoPhase * 4;
        if(lfo < 2)
        {
          lfo--;
        }
        else
        {
          lfo = 3 - lfo;
        }
        lfoPhase = lfoPhase + 0.0000680272108843537;
        if(lfoPhase >= 1)
        {
          lfoPhase = lfoPhase - 1;
        }
        pNum = delayIndex - (delayOffset + lfo * 12);
        if(pNum < 0)
        {
          pNum = pNum + delaySize;
        }
        _loc7_ = pNum;
        _loc5_ = pNum - _loc7_;
        _loc12_ = _loc3_[_loc7_];
        _loc13_ = _loc12_.next;
        _loc8_ = _loc12_.c0 + _loc5_ * (_loc13_.c0 - _loc13_.c0);
        _loc10_ = _loc12_.c1 + _loc5_ * (_loc13_.c1 - _loc13_.c1);
        current.c0 = _loc9_ + _loc8_ * 0.08;
        current.c1 = _loc11_ + _loc10_ * 0.08;
        delayHead.c0 = _loc9_ + _loc10_ * 0.4;
        delayHead.c1 = _loc11_ + _loc8_ * 0.4;
        delayHead = delayHead.next;
        delayIndex = delayIndex + 1;
        if(delayIndex + 1 == delaySize)
        {
          delayIndex = 0;
        }
        current = current.next;
        i++;
      }
    }

    private function processVoices(current:Signal, numSignals:int) : void
    {
      var _loc3_:IManagedObjectIterator = processList.iterator;
      while(_loc3_.hasNext())
      {
        if(Voice(_loc3_.next()).processAdd(current,numSignals))
        {
          _loc3_.remove();
        }
      }
    }

    override protected function processTimeEvent(event:ITimeEvent) : void
    {
      var _loc2_:* = null;
      if(event.classID == TimeEventNote.CLASS_ID)
      {
        _loc2_ = Voice(processList.createSingle());
        _loc2_.playEvent(TimeEventNote(event));
      }
    }

    public function get signalOutput() : SignalOutput
    {
      return _signalOutput;
    }

    override public function dispose() : void
    {
      processList.clear();
      processList.dispose();
      _signalOutput.dispose();
      _signalOutput = null;
      super.dispose();
    }

    public function toString() : String
    {
      return "[ToneMatrixProcessor]";
    }
  }
}
