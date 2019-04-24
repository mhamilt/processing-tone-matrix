package de.despudelskern.boot
{
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.System;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   public class BootLoader extends MovieClip
   {
      
      public static var CONFIG_XML:XML = null;
       
      
      private const _Δ:int = getTimer();
      
      private const classMap:Dictionary = new Dictionary();
      
      private const loaderContext:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain,null);
      
      private var dependencies:Array;
      
      private var applicationClassName:String;
      
      private var configLoader:URLLoader;
      
      private var repositoryRoot:String;
      
      private var swfTotal:int;
      
      private var swfFilesLoaded:int;
      
      private var swfClassRowIndex:int;
      
      private var swfClassRowLoaded:int;
      
      private var swfClassLoaded:int;
      
      private var swfClassRowTotal:int;
      
      private var progress:Number;
      
      public function BootLoader(dependencies:Array, applicationClassName:String)
      {
         super();
         this.dependencies = dependencies;
         this.applicationClassName = applicationClassName;
         if(null != stage)
         {
            init();
         }
         else
         {
            addEventListener("addedToStage",onAddedToStage);
         }
      }
      
      public static function get FALLBACK_XML() : XML
      {
         return <config>
						<version>@build.version@</version>
						<network>
							<api-root version="2.0">api.audiotool.com</api-root>
							<repo-root>http://repository.audiotool.com/</repo-root>
							<allow-domain>*</allow-domain>
							<load-policy>http://audiotool.s3.amazonaws.com/</load-policy>
						</network>
						<log methodnames="true">
							<output>
								<console>
									<min-level>warn</min-level>
								</console>
								<sos host="127.0.0.1" port="4444">
									<min-level>trace</min-level>
									<max-level>fatal</max-level>
								</sos>
							</output>
							<category name="network">
								<min-level>warn</min-level>
							</category>
						</log>
					</config>;
      }
      
      protected final function elapsedTime() : int
      {
         return getTimer() - _Δ;
      }
      
      protected final function bootProgress() : Number
      {
         return progress;
      }
      
      protected function onBootBegin() : void
      {
      }
      
      protected function onBootResize(width:Number, height:Number) : void
      {
      }
      
      protected function onBootProgress(progress:Number) : void
      {
      }
      
      protected function onBootComplete() : void
      {
      }
      
      private function onAddedToStage(event:Event) : void
      {
         removeEventListener("addedToStage",onAddedToStage);
         init();
      }
      
      private function init() : void
      {
         trace("[INFO] Welcome to the Audiotool Boot Loader");
         trace("[INFO] https://www.audiotool.com");
         stage.scaleMode = "noScale";
         stage.align = "TL";
         stage.frameRate = 60;
         stage.showDefaultContextMenu = false;
         stage.addEventListener("resize",onStageResize);
         progress = 0;
         stop();
         loadConfig();
         onBootBegin();
      }
      
      private function onStageResize(event:Event) : void
      {
         onBootResize(stage.stageWidth,stage.stageHeight);
      }
      
      private function loadConfig() : void
      {
         trace("[INFO] Loading configuration ./app-config.xml");
         configLoader = new URLLoader(new URLRequest("./app-config.xml"));
         addConfigLoaderListeners();
      }
      
      private function addConfigLoaderListeners() : void
      {
         configLoader.addEventListener("complete",onConfigComplete,false,0,true);
         configLoader.addEventListener("ioError",onConfigIOError,false,0,true);
         configLoader.addEventListener("securityError",onConfigSecurityError,false,0,true);
      }
      
      private function removeConfigLoaderListeners() : void
      {
         configLoader.removeEventListener("complete",onConfigComplete);
         configLoader.removeEventListener("ioError",onConfigIOError);
         configLoader.removeEventListener("securityError",onConfigSecurityError);
      }
      
      private function onConfigComplete(event:Event) : void
      {
         removeConfigLoaderListeners();
         parseConfig(new XML(String(configLoader.data)));
      }
      
      private function onConfigIOError(event:IOErrorEvent) : void
      {
         trace("[WARNING] ",event.text);
         removeConfigLoaderListeners();
         parseConfig(FALLBACK_XML);
      }
      
      private function onConfigSecurityError(event:SecurityErrorEvent) : void
      {
         trace("[WARNING] ",event.text);
         removeConfigLoaderListeners();
         parseConfig(FALLBACK_XML);
      }
      
      private function parseConfig(configXML:XML) : void
      {
         repositoryRoot = configXML.network.child(new QName(null,"repo-root")).toString();
         var version:String = configXML.version.toString();
         if(0 == version.length)
         {
            trace("[WARNING] No version given. Setting to \"1.1\".");
            version = "1.1";
         }
         if(repositoryRoot.charAt(repositoryRoot.length - 1) != "/")
         {
            repositoryRoot = repositoryRoot + ("/" + version + "/");
         }
         else
         {
            repositoryRoot = repositoryRoot + (version + "/");
         }
         CONFIG_XML = configXML;
         loadSWFBytes();
      }
      
      private function loadSWFBytes() : void
      {
         var _loc5_:* = null;
         var i:int = 0;
         var _loc1_:* = null;
         var _loc2_:* = null;
         swfFilesLoaded = 0;
         var j:int = dependencies.length;
         while(true)
         {
            j--;
            if(j <= -1)
            {
               break;
            }
            _loc5_ = dependencies[j] as Array;
            i = _loc5_.length;
            while(true)
            {
               i--;
               if(i <= -1)
               {
                  break;
               }
               _loc1_ = _loc5_[i];
               _loc2_ = new URLLoader(requestFor(_loc1_));
               _loc2_.dataFormat = "binary";
               watchSWFByteLoader(_loc2_);
               classMap[_loc1_] = _loc2_;
               swfTotal = swfTotal + 1;
            }
         }
      }
      
      private function requestFor(dependency:String) : URLRequest
      {
         var _loc2_:String = repositoryRoot + dependency + ".swf";
         return new URLRequest(_loc2_);
      }
      
      private function watchSWFByteLoader(loader:URLLoader) : void
      {
         loader.addEventListener("complete",onSWFBytesComplete);
         loader.addEventListener("ioError",onSWFBytesError);
         loader.addEventListener("securityError",onSWFBytesError);
         loader.addEventListener("progress",onSWFBytesProgress);
      }
      
      private function unwatchSWFByteLoader(loader:URLLoader) : void
      {
         loader.removeEventListener("complete",onSWFBytesComplete);
         loader.removeEventListener("ioError",onSWFBytesError);
         loader.removeEventListener("securityError",onSWFBytesError);
         loader.removeEventListener("progress",onSWFBytesProgress);
      }
      
      private function onSWFBytesProgress(event:ProgressEvent) : void
      {
         updateSWFBytesProgress();
      }
      
      private function updateSWFBytesProgress() : void
      {
         var _loc2_:* = null;
         progress = 0;
         var _loc4_:int = 0;
         var _loc3_:* = classMap;
         for(var path in classMap)
         {
            _loc2_ = classMap[path] as URLLoader;
            progress = progress + (0 == _loc2_.bytesTotal?0:Number(_loc2_.bytesLoaded / _loc2_.bytesTotal));
         }
         progress = progress * (0.5 / swfTotal);
         onBootProgress(progress);
      }
      
      private function onSWFBytesError(event:ErrorEvent) : void
      {
         trace("[ERROR]",event.text);
         unwatchSWFByteLoader(event.target as URLLoader);
         destroy();
      }
      
      private function onSWFBytesComplete(event:Event) : void
      {
         swfFilesLoaded = swfFilesLoaded + 1;
         var _loc2_:* = swfFilesLoaded + 1 == swfTotal;
         unwatchSWFByteLoader(event.target as URLLoader);
         if(_loc2_)
         {
            loadSWFClasses();
         }
      }
      
      private function loadSWFClasses() : void
      {
         updateSWFClassProgress();
         swfClassRowIndex = 0;
         swfClassLoaded = 0;
         nextSWFClasses();
      }
      
      private function nextSWFClasses() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         swfClassRowLoaded = 0;
         swfClassRowTotal = 0;
         var _loc5_:Array = dependencies[swfClassRowIndex] as Array;
         var i:int = _loc5_.length;
         while(true)
         {
            i--;
            if(i <= -1)
            {
               break;
            }
            _loc1_ = _loc5_[i];
            _loc2_ = (classMap[_loc1_] as URLLoader).data;
            _loc3_ = new Loader();
            watchSWFClassLoader(_loc3_.contentLoaderInfo);
            _loc3_.loadBytes(_loc2_,loaderContext);
            delete classMap[_loc1_];
            swfClassRowTotal = swfClassRowTotal + 1;
         }
      }
      
      private function watchSWFClassLoader(loaderInfo:LoaderInfo) : void
      {
         loaderInfo.addEventListener("complete",onSWFClassComplete);
         loaderInfo.addEventListener("ioError",onSWFClassError);
         loaderInfo.addEventListener("securityError",onSWFClassError);
      }
      
      private function unwatchSWFClassLoader(loaderInfo:LoaderInfo) : void
      {
         loaderInfo.removeEventListener("complete",onSWFClassComplete);
         loaderInfo.removeEventListener("ioError",onSWFClassError);
         loaderInfo.removeEventListener("securityError",onSWFClassError);
      }
      
      private function onSWFClassError(event:ErrorEvent) : void
      {
         trace("[ERROR]",event.text);
         unwatchSWFClassLoader(event.target as LoaderInfo);
         destroy();
      }
      
      private function onSWFClassComplete(event:Event) : void
      {
         unwatchSWFClassLoader(event.target as LoaderInfo);
         swfClassLoaded = swfClassLoaded + 1;
         updateSWFClassProgress();
         swfClassRowLoaded = swfClassRowLoaded + 1;
         if(swfClassRowLoaded + 1 == swfClassRowTotal)
         {
            swfClassRowIndex = swfClassRowIndex + 1;
            if(swfClassRowIndex + 1 == dependencies.length)
            {
               addEventListener("enterFrame",onEnterFrame);
            }
            else
            {
               nextSWFClasses();
            }
         }
      }
      
      private function updateSWFClassProgress() : void
      {
         progress = 0.5 + 0.5 * swfClassLoaded / swfTotal;
         onBootProgress(progress);
      }
      
      private function onEnterFrame(event:Event) : void
      {
         if(framesLoaded == totalFrames)
         {
            trace("[INFO] ------------------------------------------------------------------------");
            trace("[INFO] BOOT SUCCESS");
            trace("[INFO] ------------------------------------------------------------------------");
            trace("[INFO] Total time: " + Math.ceil((getTimer() - _Δ) / 1000) + "s");
            trace("[INFO] Final Memory: " + (System.totalMemory >> 20).toString() + "m");
            removeEventListener("enterFrame",onEnterFrame);
            onBootComplete();
            nextFrame();
            setTimeout(initApplication,16);
         }
      }
      
      private function initApplication() : void
      {
         var _loc1_:Class = getDefinitionByName(applicationClassName) as Class;
         addChild(DisplayObject(new _loc1_()));
         destroy();
      }
      
      private function destroy() : void
      {
         stage.removeEventListener("resize",onStageResize);
         dependencies = null;
         applicationClassName = null;
      }
   }
}
