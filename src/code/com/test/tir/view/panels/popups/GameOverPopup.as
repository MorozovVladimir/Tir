package com.test.tir.view.panels.popups
{
	import com.test.tir.game.data.GameData;

	public class GameOverPopup extends AbstractPopup
	{
		public function GameOverPopup(panelName:String, panelData:Object)
		{
			super(panelName, panelData);
		}

		override protected function initView():void
		{
			super.initView();

			getChildrenTextField("txtResult").text = GameData.COUNT_TARGET - GameData.countTargetLost + " из " + GameData.COUNT_TARGET;
		}
	}
}