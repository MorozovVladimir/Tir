/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.common.managers.assets.types
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;

	import com.greensock.events.LoaderEvent;
	import com.test.tir.api.view.ILoaderRespondent;
	import com.test.tir.common.managers.assets.ExternalAssetManager;
	import com.test.tir.common.utils.CommonUtility;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.setTimeout;

	public class Asset extends EventDispatcher implements IAsset, ILoaderRespondent
	{
		protected static const loader: BulkLoader = ExternalAssetManager.mainLoader;

		protected var assetName: String;
		protected var checkLoadFlag: Boolean;
		protected var priority: int;

		protected var resultData: *;
		protected var pathUrl: String;

		protected var loaderItem: *;
		private var _loadCoeff: Number = 1;
		private var loadCallBack: Function;

		public function Asset(assetName: String, checkLoadFlag: Boolean, path: String = "", loadCallBack: Function = null)
		{
			this.pathUrl = CommonUtility.checkUrl(path);
			this.assetName = assetName;
			this.checkLoadFlag = checkLoadFlag;
			this.loadCallBack = loadCallBack;

			init();
		}

		protected function init(): void
		{
			eventIntention(loaderItem.addEventListener);
		}

		public function checkData(loadCallBack: Function): void
		{
			this.loadCallBack = loadCallBack;
			setTimeout(onComplete, 10);
		}

		protected function onComplete(event: Event = null): void
		{
			finishLoading();
			dispatchEvent(new Event(LoaderEvent.COMPLETE));
			if(loadCallBack != null) loadCallBack(this);
		}

		protected function onError(event: *): void
		{
			resultData = null;
			finishLoading();
			dispatchEvent(new Event(LoaderEvent.FAIL));
		}

		protected function onProgress(event: Event = null): void
		{
			dispatchEvent(new Event(LoaderEvent.PROGRESS));
		}

		private function onIOError(event: IOErrorEvent): void
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, IOErrorEvent(event).text));
			trace(IOErrorEvent(event).text);
		}

		private function eventIntention(method: Function): void
		{
			method(BulkProgressEvent.COMPLETE, onComplete);
			method(BulkProgressEvent.PROGRESS, onProgress);
			method(IOErrorEvent.IO_ERROR, onIOError);
			method(SecurityErrorEvent.SECURITY_ERROR, onError);
		}

		protected function finishLoading(): void
		{
			eventIntention(loaderItem.removeEventListener);
		}

		public function set loadCoeff(value: Number): void { _loadCoeff = value; }
		public function get name(): String { return assetName; }
		public function get checkLoad(): Boolean { return checkLoadFlag; }
		public function get percent(): int { return loaderItem.percentLoaded * 100 * _loadCoeff; }
		public function get data(): * { return resultData; }

		public function destory(): void
		{
			loadCallBack = null;
			resultData = null;
			loaderItem = null;
		}
	}
}