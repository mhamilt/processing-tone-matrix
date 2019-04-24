package de.despudelskern.application.tonematrix
{
   import com.audiotool.application.AbstractApplication;
   import com.audiotool.application.font.FontLoader;
   import com.audiotool.audio.AudioDriver;
   import com.audiotool.audio.AudioEngine;
   import com.audiotool.audio.IRealTimeObserver;
   import com.audiotool.gui.GUI;
   import com.audiotool.log.Category;
   import com.audiotool.log.Log;
   import com.audiotool.ui.events.IUIEventTarget;
   import com.audiotool.ui.events.UIBitmap;
   import com.audiotool.ui.events.UIEvent;
   import com.audiotool.ui.events.UIMouseEvent;
   import com.audiotool.ui.layer.Layers;
   import com.hobnox.ui.textures.mouse.AudiotoolCursor;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.System;

   public final class Application extends AbstractApplication implements IRealTimeObserver
   {

      private static const LINK_URL:String = "https://tonematrix.audiotool.com/_/";
      private static const AppUrls:String = "https://www.audiotool.com/app/";
      private static const TrackPrefix:String = "tonematrix-import-";
      private static const LOGO_CLASS:Class = §add-drums-btn-250x74_png$836aa56f5432f8a3263f17ee0c6333b9729701278§;
      private static const LOGO_BITMAP_DATA:BitmapData = Bitmap(new LOGO_CLASS()).bitmapData;
      private static const COPY_CLASS:Class = §copy-link-btn-250x74_png$a8981c50deae42e4d9b9e289b583ab221603135885§;
      private static const COPY_BITMAP_DATA:BitmapData = Bitmap(new COPY_CLASS()).bitmapData;
      private static const SHARE_CLASS:Class = §facebook-icon-64x64_png$c11ac7c7304ef31c048dd39e44ce6313663769816§;
      private static const SHARE_BITMAP_DATA:BitmapData = Bitmap(new SHARE_CLASS()).bitmapData;

      private var engine:AudioEngine;
      private var driver:AudioDriver;
      private var pattern:Pattern;
      private var patternView:PatternView;
      private var sequencer:Sequencer;
      private var processor:Processor;
      private var logoButton:UIBitmap;
      private var copyButton:UIBitmap;
      private var shareButton:UIBitmap;

      public function Application()
      {
         super();
      }

      override protected function onApplicationSetup() : void
      {
         stage.align = "TL";
         stage.focus = this;
         stage.scaleMode = "noScale";
         stage.showDefaultContextMenu = false;
         GUI.initialize(this);
         FontLoader.load(fontLoaded);
      }

      private function fontLoaded() : void
      {
         engine = AudioEngine.getInstance();
         driver = new AudioDriver(engine);
         engine.driver = driver;
         pattern = new Pattern();
         patternView = new PatternView(pattern,32);
         addChild(patternView);
         var _loc1_:String = readPattern();
         if(null != _loc1_)
         {
            Log.info(Category.DEFAULT,"Found data: " + _loc1_);
            pattern.deserialize(_loc1_);
            patternView.update();
         }
         logoButton = new UIBitmap(LOGO_BITMAP_DATA);
         var _loc2_:* = 0.5;
         logoButton.scaleY = _loc2_;
         logoButton.scaleX = _loc2_;
         addChild(logoButton);
         copyButton = new UIBitmap(COPY_BITMAP_DATA);
         _loc2_ = 0.5;
         copyButton.scaleY = _loc2_;
         copyButton.scaleX = _loc2_;
         addChild(copyButton);
         shareButton = new UIBitmap(SHARE_BITMAP_DATA);
         _loc2_ = 0.5;
         shareButton.scaleY = _loc2_;
         shareButton.scaleX = _loc2_;
         addChild(shareButton);
         sequencer = new Sequencer(pattern);
         sequencer.processEnabled = true;
         processor = new Processor();
         processor.processEnabled = true;
         engine.connect(sequencer.timedEventOutput,processor.timeEventInput,true);
         engine.masterSignalOutput = processor.signalOutput;
         engine.timeInfo.bpm = 120;
         engine.timeInfo.transporting = true;
         engine.addRealTimeObserver(this);
         driver.start();
         onApplicationResize(stage.stageWidth,stage.stageHeight);
      }

      public function onRealTimeNotify(ticks:int) : void
      {
         var _loc2_:int = ticks / Sequencer.ONE_SIXTEENTH;
         if(null != patternView)
         {
            patternView.stepIndex = _loc2_ % 16;
         }
      }

      override protected function onProcessEvent(event:UIEvent) : void
      {
         var _loc2_:int = event.type;
         var _loc3_:IUIEventTarget = event.target;
         if(_loc2_ == 260)
         {
            if(_loc3_ == logoButton)
            {
               navigateToURL(new URLRequest("https://www.audiotool.com/app/" + "tonematrix-import-" + pattern.serialize()),"_top");
            }
            else if(_loc3_ == copyButton)
            {
               copyToClipboard();
            }
            else if(_loc3_ == shareButton)
            {
               shareFacebook();
            }
         }
         else if(_loc2_ == 268)
         {
            if(_loc3_ == logoButton || _loc3_ == copyButton || _loc3_ == shareButton)
            {
               UIMouseEvent(event).cursor = AudiotoolCursor.BUTTON;
            }
         }
      }

      override protected function onApplicationResize(width:int, height:int) : void
      {
         var _loc3_:int = 0;
         _loc3_ = 27;
         var _loc4_:Number = NaN;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         if(null != patternView && null != copyButton && null != logoButton && null != shareButton)
         {
            patternView.x = Math.round((width - patternView.width) * 0.5);
            patternView.y = Math.round((height - patternView.height) * 0.5);
            _loc4_ = patternView.x + 4;
            _loc6_ = patternView.x + patternView.width - 8;
            _loc5_ = patternView.y + patternView.height + _loc3_;
            logoButton.x = _loc4_;
            logoButton.y = _loc5_;
            copyButton.x = _loc4_ + 331;
            copyButton.y = _loc5_;
            shareButton.x = _loc6_ - shareButton.width;
            shareButton.y = _loc5_ - 1;
         }
         Layers.resizeTo(width,height);
      }

      override protected function get DEACTIVE_FPS() : Number
      {
         return 16;
      }

      override protected function get ACTIVE_FPS() : Number
      {
         return 60;
      }

      private function copyToClipboard() : void
      {
         var data:String = null;
         try
         {
            data = pattern.serialize();
         }
         catch(error:Error)
         {
            Log.error(Category.DEFAULT,error);
         }
         if(null != data)
         {
            System.setClipboard("https://tonematrix.audiotool.com/_/" + data);
         }
      }

      private function shareFacebook() : void
      {
         var result:int = 0;
         if(ExternalInterface.available)
         {
            result = -1;
            try
            {
               result = ExternalInterface.call("login","https://tonematrix.audiotool.com/_/" + pattern.serialize());
            }
            catch(error:Error)
            {
               Log.error(Category.DEFAULT,error);
            }
            Log.info(Category.DEFAULT,"login result: " + result);
         }
      }

      private function readPattern() : String
      {
         var _loc1_:Object = root.loaderInfo.parameters;
         var _loc2_:String = _loc1_["data"];
         if("null" == _loc2_)
         {
            return null;
         }
         return _loc2_;
      }
   }
}
