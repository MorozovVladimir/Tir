/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.view.panels.scene
{
	import com.test.tir.common.managers.UserInterfaceManager;
	import com.test.tir.common.managers.panels.PanelsManager;
	import com.test.tir.common.params.PanelNames;
	import com.test.tir.common.params.UIItemNames;

	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	public class LobbyScene extends AbstractScene
	{
		public function LobbyScene(panelName: String, panelData: Object)
		{
			super(panelName, panelData);
		}

		override protected function initView(): void
		{
			super.initView();
			(sceneClip["btnStart"] as SimpleButton).addEventListener(MouseEvent.CLICK, startClickHandler);
		}

		private function startClickHandler(event: MouseEvent): void
		{
			PanelsManager.switchPanel(PanelNames.SCENE_GAME, panelName);
		}

		override protected function initUI(): void
		{
			super.initUI();

			UserInterfaceManager.showItem(UIItemNames.CONTROLS_GAME, false);
			UserInterfaceManager.showItem(UIItemNames.CONTROLS_LOBBY, true);
		}

		override public function destroy(): void
		{
			(sceneClip["btnStart"] as SimpleButton).removeEventListener(MouseEvent.CLICK, startClickHandler);
			super.destroy();
		}
	}
}