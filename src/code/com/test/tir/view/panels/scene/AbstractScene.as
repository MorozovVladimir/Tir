/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.view.panels.scene
{
	import com.test.tir.common.managers.assets.ExternalAssetManager;
	import com.test.tir.common.params.AssetNames;
	import com.test.tir.common.params.PanelTypes;
	import com.test.tir.view.panels.AbstractPanel;

	import flash.display.Sprite;

	public class AbstractScene extends AbstractPanel
	{
		public var sceneClip: Sprite;
		
		public function AbstractScene(panelName:String, panelData:Object)
		{
			super(panelName, panelData);
			panelType = PanelTypes.PANEL_SCENE;
		}
		
		override protected function initView():void
		{
			sceneClip = ExternalAssetManager.getItemByLinkage(AssetNames.SCENES_ASSET, panelName) as Sprite;
            if(sceneClip) addChild(sceneClip);
			
			super.initView();
		}

		override public function show (): void
		{
			super.show();
			initUI();
		}

		protected function initUI(): void { }
		
		override public function destroy():void 
		{
			if (sceneClip) removeChild(sceneClip);
			sceneClip = null;
		}
	}
}