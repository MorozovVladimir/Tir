/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.view.panels.ui
{
	import com.test.tir.common.managers.UserInterfaceManager;
	import com.test.tir.common.managers.assets.ExternalAssetManager;
	import com.test.tir.common.params.AssetNames;
	import com.test.tir.common.params.PanelTypes;
	import com.test.tir.view.panels.AbstractPanel;

	import flash.display.Sprite;

	public class UserInterface extends AbstractPanel
	{
		private var viewClip:Sprite;

		public function UserInterface(panelName:String, panelData:Object)
		{
			super(panelName, panelData);
			panelType = PanelTypes.PANEL_UI;
		}

		override protected function init (): void
		{
			super.init();

			UserInterfaceManager.init(viewClip);
		}

		override protected function initView():void
		{
			viewClip = ExternalAssetManager.getItemByLinkage(AssetNames.UI_ASSET, "UserInterfaceClip") as Sprite;
			addChild(viewClip);

			super.initView();
		}
	}
}