package com.test.tir.view.panels.popups
{
	public class DisableGamePopup extends AbstractPopup
	{
		public function DisableGamePopup(panelName:String, panelData:Object)
		{
			super(panelName, panelData);
			openSoundName = "";
		}

		override protected function init():void
		{
			super.init();
			alpha = (data && !data.alpha) ? data.alpha : 1;
		}

	}
}