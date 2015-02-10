/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.view.panels.ui.items
{
	import com.test.tir.common.events.ProjectEvent;
	import com.test.tir.common.managers.EventManager;
	import com.test.tir.common.managers.panels.PanelsManager;
	import com.test.tir.common.params.PanelNames;
	import com.test.tir.game.data.GameData;
	import com.test.tir.view.components.TimerControl;
	import com.test.tir.view.panels.scene.GameScene;

	import flash.display.MovieClip;
	import flash.text.TextField;

	public class UserGameControls extends UserInterfaceItem
	{
		private var txtTargetCount: TextField;
		private var timer: TimerControl;

		public function UserGameControls(uiItemName:String, uiItemClip:MovieClip)
		{
			super(uiItemName, uiItemClip);
		}

		override public function init():void
		{
			super.init();

			txtTargetCount = getChildrenTextField("txtTargetCnt");
			timer = new TimerControl(getChildrenTextField("txtTimer"), null, timerFinishHandler);

			EventManager.DISPATCHER.addEventListener(ProjectEvent.GAME_DATA_UPDATE, updateParams);
		}

		private function timerFinishHandler(): void
		{
			(PanelsManager.getPanelByName(PanelNames.SCENE_GAME) as GameScene).game.gameOver();
		}

		override public function set show(value: Boolean): void
		{
			super.show = value;
			if(value)
			{
				updateParams();
				timer.startTimer(GameData.TIME);
			}
			else
			{
				timer.stop();
			}
		}

		private function updateParams(event: ProjectEvent = null): void
		{
			txtTargetCount.text = GameData.countTargetLost.toString();
			if(GameData.countTargetLost == 0) timer.stop();
		}
	}
}