/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.common.managers.assets.types
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	import flash.system.LoaderContext;

	public class ImageAsset extends Asset
	{
		public function ImageAsset(assetName: String, checkLoadFlag: Boolean, path: String = "", loadCallBack: Function = null)
		{
			super(assetName, checkLoadFlag, path, loadCallBack);

			this.priority = (checkLoadFlag ? 100 : 11);
		}

		override protected function init(): void
		{
			if (!pathUrl || pathUrl == "") return;

			var lc: LoaderContext = new LoaderContext(true);
			loaderItem = loader.add(pathUrl, {id: assetName, maxTries: 5, priority: priority, context: lc, type: BulkLoader.TYPE_IMAGE  }) as LoadingItem;

			super.init();
		}

		override protected function finishLoading(): void
		{
			resultData = loader.getContent(assetName);
			super.finishLoading();
		}
	}
}