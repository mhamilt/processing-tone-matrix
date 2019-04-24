package
{
   import de.despudelskern.boot.BootLoader;
   
   public final class Boot extends BootLoader
   {
       
      
      public function Boot()
      {
         super([["de.despudelskern.audiotoolversion","de.despudelskern.crypto"],["de.despudelskern.standard"],["de.despudelskern.console"],["de.despudelskern.log","de.despudelskern.debug","de.despudelskern.http","de.despudelskern.pogo"],["de.despudelskern.format","de.despudelskern.cular","de.despudelskern.graph","de.despudelskern.tweens","de.despudelskern.uievents","de.despudelskern.useraction"],["de.despudelskern.layout"],["de.despudelskern.application","de.despudelskern.components"],["de.despudelskern.timeline","de.despudelskern.textures","de.despudelskern.surface"],["de.despudelskern.view","de.despudelskern.remotecontrol"],["de.despudelskern.engine"],["de.despudelskern.midi","de.despudelskern.pattern"],["de.despudelskern.plugin","de.despudelskern.proaddon-client"],["de.despudelskern.parameter","de.despudelskern.desktop","de.despudelskern.audiotimeline"]],"de.despudelskern.application.tonematrix.Application");
      }
      
      override protected function onBootBegin() : void
      {
         repaintPreloader();
      }
      
      override protected function onBootResize(width:Number, height:Number) : void
      {
         repaintPreloader();
      }
      
      override protected function onBootProgress(progress:Number) : void
      {
         repaintPreloader();
      }
      
      override protected function onBootComplete() : void
      {
         graphics.clear();
      }
      
      private function repaintPreloader() : void
      {
         var _loc4_:Number = NaN;
         _loc4_ = 256;
         var _loc5_:* = NaN;
         _loc5_ = 3;
         var _loc3_:* = NaN;
         _loc3_ = 3;
         var _loc1_:Number = stage.stageWidth;
         var _loc2_:Number = stage.stageHeight;
         var _loc6_:Number = (_loc1_ - 256) * 0.5;
         var _loc7_:Number = (_loc2_ - 3) * 0.5;
         graphics.clear();
         graphics.beginFill(2763306);
         graphics.drawRoundRect(_loc6_,_loc7_,256,3,3,3);
         graphics.endFill();
         graphics.beginFill(2614527);
         graphics.drawRoundRect(_loc6_,_loc7_,256 * bootProgress(),3,3,3);
         graphics.endFill();
      }
   }
}
