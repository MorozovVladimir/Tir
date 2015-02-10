/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.view.panels.scene
{
	import com.test.tir.common.managers.UserInterfaceManager;
	import com.test.tir.common.params.UIItemNames;
	import com.test.tir.game.GameController;

	import flash.system.System;

	public class GameScene extends AbstractScene
	{
		private var gameController: GameController;

		public function GameScene(panelName: String, panelData: Object)
		{
			super(panelName, panelData);
		}

		override protected function init(): void
		{
			super.init();
		}

		override protected function openPanel(): void
		{
			super.openPanel();
			gameController = new GameController();
		}

		override protected function initUI(): void
		{
			super.initUI();

			UserInterfaceManager.showItem(UIItemNames.CONTROLS_GAME, true);
			UserInterfaceManager.showItem(UIItemNames.CONTROLS_LOBBY, false);
		}

		public function get game (): GameController {return gameController; }

		override public function destroy(): void
		{
			gameController.destroy();
			gameController = null;

			System.gc();

			super.destroy();
		}
	}
}