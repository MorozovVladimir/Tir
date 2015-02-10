/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.core
{
	import com.greensock.events.LoaderEvent;
	import com.test.tir.api.view.ILoaderRespondent;
	import com.test.tir.common.params.LoaderConstants;
	import com.test.tir.view.loaders.MainLoader;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;

	public class TirPreloader extends MovieClip implements ILoaderRespondent
	{
		public static var mainLoader:MainLoader;
		private var loadPercent:int;

		public var main:*;

		public function TirPreloader()
		{


			init();
		}
		
		private function init (): void
		{
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.align = StageAlign.TOP;
			stage.quality = StageQuality.HIGH;
			stage.tabChildren = stage.showDefaultContextMenu = false;

			addEventListener(Event.ENTER_FRAME, checkFrame);
			
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			loadProgressBar();
		}
		
		private function loadProgressBar():void
		{
			mainLoader = new MainLoader();

			mainLoader.addRespondent(this);
			mainLoader.addEventListener(LoaderEvent.COMPLETE, onLoadingCompleteHandler);
			addChild(mainLoader);
		}

		public function get percent():int { return loadPercent; }

		private function progress(e:ProgressEvent):void
		{
			loadPercent = (e.bytesLoaded * 100 / e.bytesTotal) * LoaderConstants.APP_MAIN;
			dispatchEvent(new Event(LoaderEvent.PROGRESS));
		}

		private function ioError(e:IOErrorEvent):void
		{
			trace(e.text);
		}

		private function checkFrame(e:Event):void
		{
			if (currentFrame == totalFrames)
			{
				stop();
				loadingFinished();
			}
		}

		private function loadingFinished():void
		{
			loadPercent = LoaderConstants.APP_MAIN * 100;
			dispatchEvent(new Event(LoaderEvent.PROGRESS));

			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);

			startup();
		}

		private function startup():void
		{
			var mainClass:Class = getDefinitionByName("com.test.tir.core.TirMain") as Class;
			main = new mainClass();
			dispatchEvent(new Event('ready', true));
			addChild(main as DisplayObject);
		}

		private function onLoadingCompleteHandler(event:Event):void
		{
			mainLoader.removeEventListener(LoaderEvent.COMPLETE, onLoadingCompleteHandler);
			mainLoader.destroy();
			removeChild(mainLoader);
			mainLoader = null;
		}
	}
}