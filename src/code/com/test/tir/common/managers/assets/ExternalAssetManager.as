/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.common.managers.assets
{
	import br.com.stimuli.loading.BulkLoader;

	import com.greensock.events.LoaderEvent;
	import com.test.tir.common.managers.assets.types.*;
	import com.test.tir.core.TirPreloader;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class ExternalAssetManager
	{
		public static const mainLoader: BulkLoader = new BulkLoader('test_tir_loader', 5, BulkLoader.LOG_SILENT);
		private static var assets: Dictionary = new Dictionary();

		public static function initialize (value: XMLList, callBack: Function): void
		{
			var asset:IAsset;
			for each(var assetXML:XML in value.asset)
			{
				asset = ExternalAssetManager.createAsset(assetXML.@name, assetXML.@path, (assetXML.@checkLoad == "1"), false, assetXML.@type, callBack);
				if (asset.checkLoad)
				{
					asset.addEventListener(LoaderEvent.PROGRESS, resourceProgressHandler);
					asset.addEventListener(LoaderEvent.COMPLETE, assetCompleteHandler);
					asset.addEventListener(LoaderEvent.FAIL, assetFailHandler);
				}
			}
		}

		private static function assetCompleteHandler(event:*):void
		{
			var asset:IAsset = event.target as IAsset;
			asset.removeEventListener(LoaderEvent.PROGRESS, resourceProgressHandler);
			asset.removeEventListener(LoaderEvent.COMPLETE, assetCompleteHandler);
			asset.removeEventListener(LoaderEvent.FAIL, assetFailHandler);
		}

		private static function assetFailHandler(event:Event):void
		{
			trace("FAIL " + event);
		}

		private static function resourceProgressHandler(event:Event = null):void
		{
			TirPreloader.mainLoader.update();
		}

		public static function createAsset(name: String, path: String, checkLoad: Boolean = false, useCache: Boolean = false, type: String = "media", loadCallBack: Function = null): IAsset
		{
			var asset: IAsset;
			if (assets[name] && useCache && assets[name].data != null)
			{
				asset = assets[name];
				asset.checkData(loadCallBack);
				return asset;
			}

			var assetClass: Class = getClassByType(type);
			asset = new assetClass(name, checkLoad, path, loadCallBack);
			assets[name] = asset;

			startLoad();

			return asset;
		}

		private static function getClassByType(type: String): Class
		{
			if (type == BulkLoader.TYPE_IMAGE) return ImageAsset;
			if (type == BulkLoader.TYPE_SOUND) return SoundAsset;
			if (type == BulkLoader.TYPE_XML) return XMLAsset;

			return SimpleAsset;
		}

		public static function getAssets():Dictionary
		{
			return assets;
		}

		public static function isMustLoadAll():int
		{
			for each(var asset:IAsset in assets)
			{
				if (!asset.checkLoad) continue;
				if (asset.percent < 100) return 1;
				if (asset.percent >= 100 && !asset.data) return 2;
			}

			return 0;
		}

		public static function get allMustLoadAllPercent():int
		{
			var cnt: int;
			var percent: int;
			for each(var asset:IAsset in assets)
			{
				if (!asset.checkLoad) continue;
				percent += asset.percent;
				cnt++;
			}

			return percent / cnt;
		}

		public static function getItemByLinkage(assetName:String, linkage:String):Object
		{
			var itemClass:Class = getClassByLinkage(assetName, linkage);
			return itemClass ? new itemClass() : null;
		}

		public static function getClassByLinkage(assetName:String, linkage:String):Class
		{
			var itemClass:Class;
			var asset:IAsset = assets[assetName];
            if(!asset || !asset.data) return null;

			var library:DisplayObject = asset.data as DisplayObject;
			try
			{
				itemClass = library.loaderInfo.applicationDomain.getDefinition(linkage) as Class;
			}
            catch (err:Error)
			{
				itemClass = null;
			}

			return itemClass;
		}

		public static function getAssetByName(name: String): IAsset
		{
			if(!assets[name]) null;
			return assets[name];
		}

		public static function startLoad(): void
		{
			if (!mainLoader.isRunning) mainLoader.start();
		}
	}
}