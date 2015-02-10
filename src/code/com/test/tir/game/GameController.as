/**
 * Created with IntelliJ IDEA.
 * User: Morozov V.
 * Date: 05.02.15
 * Time: 20:15
 */
package com.test.tir.game
{
	import com.test.tir.common.events.ProjectEvent;
	import com.test.tir.common.managers.EventManager;
	import com.test.tir.common.managers.FlashVarsManager;
	import com.test.tir.common.managers.panels.PanelsManager;
	import com.test.tir.common.params.PanelNames;
	import com.test.tir.game.data.GameData;
	import com.test.tir.game.engine.*;

	import flash.display.Sprite;
	import flash.utils.setTimeout;

	import starling.core.Starling;

	public class GameController extends Sprite
	{
		private static var starlingInst: Starling;

		public function GameController()
		{
			init();
		}

		private function init(): void
		{
			starlingInst = new Starling(GameField, FlashVarsManager.gameStage);
			starlingInst.enableErrorChecking = false;
			starlingInst.antiAliasing = 1;

			EventManager.DISPATCHER.addEventListener(ProjectEvent.GAME_DATA_UPDATE, checkGameOver);

			start();
		}

		private function start(): void
		{
			GameData.countTargetLost = GameData.COUNT_TARGET;
			starlingInst.start();
		}

		private function checkGameOver(event: ProjectEvent): void
		{
			if(GameData.countTargetLost == 0)
				gameOver(PanelNames.POPUP_GAME_OVER_WIN);
		}

		public function gameOver (type: String = PanelNames.POPUP_GAME_OVER_LOSE): void
		{
			(starlingInst.root as GameField).pause();
			//starlingInst.stop();

			setTimeout(PanelsManager.addPanel, 1000, type, {removeCallBack: restart});
		}

		private function restart(): void
		{
			PanelsManager.switchPanel(PanelNames.SCENE_LOBBY, PanelNames.SCENE_GAME);
		}

		public static function get isPlay (): Boolean { return ( starlingInst) ? starlingInst.isStarted : false; }

		public function destroy(): void
		{
			EventManager.DISPATCHER.removeEventListener(ProjectEvent.GAME_DATA_UPDATE, checkGameOver);

			(starlingInst.root as GameField).destroy();
			starlingInst.dispose();
			starlingInst = null;
		}
	}
}
