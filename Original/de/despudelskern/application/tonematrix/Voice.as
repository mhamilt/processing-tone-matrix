package de.despudelskern.application.tonematrix
{
   import com.audiotool.audio.Signal;
   import com.audiotool.audio.TimeEventNote;
   import com.audiotool.audio.utils.note2Frequency;
   import com.audiotool.collections.managed.ManagedObject;
   import com.audiotool.collections.managed.ManagedObjectInfo;
   
   final class Voice extends ManagedObject
   {
       
      
      private const DURATION:int = 22050;
      
      private const DURATION_INV:Number = 4.5351473922902495E-5;
      
      private var _length:int;
      
      private var _phase:Number;
      
      private var _phaseIncr:Number;
      
      private var _gainL:Number;
      
      private var _gainR:Number;
      
      function Voice(managedObjectInfo:ManagedObjectInfo)
      {
         super(managedObjectInfo);
      }
      
      public function playEvent(event:TimeEventNote) : void
      {
         _length = 22050;
         _phase = 0;
         _phaseIncr = note2Frequency(event.note) / 44100;
         var pan:Number = Math.random() - Math.random();
         var vol:Number = event.velocity / (1 + Math.abs(pan));
         _gainL = (1 - pan) * vol;
         _gainR = (pan + 1) * vol;
      }
      
      public function processAdd(current:Signal, numSignals:int) : Boolean
      {
         var env:Number = NaN;
         var amp:Number = NaN;
         var x:Number = NaN;
         var sin:Number = NaN;
         var tmp:Number = NaN;
         numSignals++;
         while(true)
         {
            numSignals--;
            if(!numSignals)
            {
               break;
            }
            _length = _length - 1;
            if(0 == _length - 1)
            {
               return true;
            }
            env = _length * 0.0000453514739229025 * 0.4;
            x = _phase;
            if(x > 0.5)
            {
               x--;
            }
            if(x < 0)
            {
               tmp = 8 * x + 16 * x * x;
               §§push(8 * x + 16 * x * x - 0.225 * (tmp * tmp + tmp));
            }
            else
            {
               tmp = 8 * x - 16 * x * x;
               §§push(Number(8 * x - 16 * x * x + 0.225 * (tmp * tmp - tmp)));
            }
            sin = §§pop();
            amp = sin * env * env;
            _phase = _phase + _phaseIncr;
            if(_phase >= 1)
            {
               _phase = _phase - 1;
            }
            current.c0 = current.c0 + amp * _gainL;
            current.c1 = current.c1 + amp * _gainR;
            current = current.next;
         }
         return false;
      }
      
      override public function dispose() : void
      {
      }
      
      override public function toString() : String
      {
         return "[ToneMatrixVoice]";
      }
   }
}
