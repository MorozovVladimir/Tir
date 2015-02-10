/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.core
{
	import br.com.stimuli.loading.BulkLoader;

	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.test.tir.api.view.ILoaderRespondent;
	import com.test.tir.common.managers.*;
	import com.test.tir.common.managers.assets.ExternalAssetManager;
	import com.test.tir.common.managers.assets.types.IAsset;
	import com.test.tir.common.managers.panels.PanelsManager;
	import com.test.tir.common.managers.shared.SharedObjectManager;
	import com.test.tir.common.params.*;
	import com.test.tir.game.data.GameData;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	import flash.utils.getTimer;

	[Frame(factoryClass="com.test.tir.core.TirPreloader")]
	[SWF(width="800", height="600", frameRate="30")]
	
	public class TirMain extends Sprite implements ILoaderRespondent
	{
		public static var APP_WIDTH:int;
		public static var APP_HEIGHT:int;

		public function TirMain():void
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");

			XML.ignoreWhitespace = true;

			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			APP_WIDTH = stage.stageWidth;
			APP_HEIGHT = stage.stageHeight;

			initCommonClasses();
		}
		
		private function initCommonClasses():void
		{
			FlashVarsManager.gameStage = stage;
			PanelsManager.placeTarget = this;
			SharedObjectManager.locale = "TestTir";

			TirPreloader.mainLoader.addRespondent(this);
			TirPreloader.mainLoader.addEventListener(LoaderEvent.COMPLETE, onLoadingCompleteHandler, false, 0, true);

			ExternalAssetManager.createAsset("config", FilesPath.PROJECT_CONFIG + "?" + getTimer(), true, false, BulkLoader.TYPE_XML, onConfigLoaded);
		}

		private function onConfigLoaded(asset: IAsset):void
		{
			if (!asset.data) return;

			var xmlData:XML = XML(asset.data);

			GameData.initialize(xmlData.params);
			ExternalAssetManager.initialize(xmlData.assets, assetCompleteHandler);

			checkResourceLoad();
		}

		private function assetCompleteHandler(asset: IAsset):void
		{
			if(!asset) return;
			checkResourceLoad();
		}

		private function checkResourceLoad(cnt:int = 0):void
		{
			dispatchEvent(new Event(LoaderEvent.PROGRESS));

			TweenMax.killDelayedCallsTo(checkResourceLoad);
			var loadRes:int = ExternalAssetManager.isMustLoadAll();
			if (loadRes == 0)
			{
				TweenMax.delayedCall(1, allResLoad);
				return;
			}
			else if (loadRes == 2 && cnt > 20)
			{
				ExternalAssetManager.startLoad();
			}

			TweenMax.delayedCall(1, checkResourceLoad, [++cnt]);
		}

		private function allResLoad():void
		{
			PanelsManager.resReady = true;
			createScenes();
		}

		private static function createScenes():void
		{
			PanelsManager.addPanel(PanelNames.USER_INTERFACE, null, false);
			PanelsManager.addPanel(PanelNames.SCENE_LOBBY, null, false);
		}

		private function onLoadingCompleteHandler(event:Event):void
		{
			CommonManager.applicationIsReady = true;
			PanelsManager.showPanel(PanelNames.USER_INTERFACE);
			PanelsManager.showPanel(PanelNames.SCENE_LOBBY);
		}

		public function get percent():int
		{
			return ExternalAssetManager.allMustLoadAllPercent * LoaderConstants.APP_RESOURCE;
		}
	}
}