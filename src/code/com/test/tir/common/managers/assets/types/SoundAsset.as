package com.test.tir.common.managers.assets.types
{
	import br.com.stimuli.loading.loadingtypes.SoundItem;

	import flash.media.SoundLoaderContext;

	public class SoundAsset extends Asset
	{
		public function SoundAsset(assetName: String, checkLoadFlag: Boolean, path: String = "", loadCallBack: Function = null)
		{
			super(assetName, checkLoadFlag, path, loadCallBack);

			this.priority = (checkLoadFlag ? 10 : 1);
		}

		override protected function init(): void
		{
			if (!pathUrl || pathUrl == "") return;

			var lc: SoundLoaderContext = new SoundLoaderContext();
			lc.checkPolicyFile = true;
			loaderItem = loader.add(pathUrl, {id: assetName, maxTries: 5, priority: priority, context: lc }) as SoundItem;

			super.init();
		}

		override protected function finishLoading(): void
		{
			resultData = loader.getSound(assetName, false);
			super.finishLoading();
		}
	}
}