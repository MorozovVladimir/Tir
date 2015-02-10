/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.common.managers.assets.types
{
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class SimpleAsset extends Asset
	{
		public function SimpleAsset(assetName: String, checkLoadFlag: Boolean, path: String = "", loadCallBack: Function = null)
		{
			super(assetName, checkLoadFlag, path, loadCallBack);

			this.priority = (checkLoadFlag ? 1000 : 110);
		}

		override protected function init(): void
		{
			if (!pathUrl || pathUrl == "") return;

			var lc: LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			loaderItem = loader.add(pathUrl, {id: assetName, maxTries: 5, priority: priority, context: lc }) as LoadingItem;

			super.init();
		}

		override protected function finishLoading(): void
		{
			resultData = loader.getContent(assetName);
			super.finishLoading();
		}
	}
}