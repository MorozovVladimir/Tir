/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.common.managers.panels
{
	import com.greensock.TweenMax;
	import com.test.tir.api.view.IPanel;
	import com.test.tir.common.params.PanelNames;
	import com.test.tir.common.params.PanelTypes;
	import com.test.tir.view.panels.popups.*;
	import com.test.tir.view.panels.scene.*;
	import com.test.tir.view.panels.ui.UserInterface;

	import flash.display.Sprite;
	import flash.events.EventDispatcher;

	import net.hires.debug.Stats;

	public class PanelsManager extends EventDispatcher
	{
		private static var _placeTarget:Sprite;

		private static var uiContainer:Sprite;
		private static var sceneContainer:Sprite;
		private static var popupContainer:Sprite;
		private static var blendContainer:Sprite;
		private static var errorContainer:Sprite;

		private static var blendCounter:int;
		private static var panels: Array = [];
		private static var resReadyFlag: Boolean = false;

		private static function createPanel(name:String, data:Object):IPanel
		{
			var panel: IPanel;
			switch (name)
			{
				case PanelNames.SCENE_GAME: 				panel = new GameScene (name, data); break;
				case PanelNames.SCENE_LOBBY: 				panel = new LobbyScene (name, data); break;
				case PanelNames.USER_INTERFACE: 			panel = new UserInterface (name, data); break;
				
				case PanelNames.POPUP_DISABLE: 				panel = new DisableGamePopup (name, data); break;
			
				case PanelNames.POPUP_GAME_OVER_WIN: 		panel = new GameOverPopup (name, data); break;
				case PanelNames.POPUP_GAME_OVER_LOSE: 		panel = new GameOverPopup (name, data); break;
			}
			
			return panel;
		}

		public static function addPanel(name:String, data:Object = null, show:Boolean = true, onBottom:Boolean = false):void
		{
			if (!resReady)
			{
				TweenMax.delayedCall(1, addPanel, [name, data, show, onBottom]);
				return;
			}
			
			if (getPanelByName(name))
			{
				showPanel(name, data, onBottom);
				return;
			}
			
			panels.push(createPanel(name, data));
			if (show) showPanel(name, data, onBottom);
		}

		public static function showPanel(name:String, data:Object = null, onBottom:Boolean = false):void
		{
			if (!getPanelByName(name)) 
			{
				return;
			}

			var panel:IPanel = getPanelByName(name);
			
			if (data) panel.data = data;

			if (panel.type == PanelTypes.PANEL_UI)    uiContainer.addChild(panel.displayObj);
			if (panel.type == PanelTypes.PANEL_BLEND) blendContainer.addChild(panel.displayObj);
			if (panel.type == PanelTypes.PANEL_SCENE) sceneContainer.addChild(panel.displayObj);

			if (panel.type == PanelTypes.PANEL_POPUP)
			{
				if (!onBottom)
					popupContainer.addChild(panel.displayObj);
				else
					popupContainer.addChildAt(panel.displayObj, 0);
			}
			
			panel.show();
		}

		public static function hidePanel(name:String):void
		{
			var panel: IPanel = getPanelByName(name);
			if (!panel) return;

			panel.hide();
		}

		public static function removePanel(name:String):void
		{
			if (!getPanelByName(name)) return;

			var panel:IPanel = getPanelByName(name);
			panel.destroy();

			if(panel.displayObj && panel.displayObj.parent)
                panel.displayObj.parent.removeChild(panel.displayObj);

			var cnt: int = panels.length;
			for (var i: int; i < cnt; i++)
			{
				if (panels[i] && panels[i].name == name)
				{
					panels.splice(i, 1);
				}
			}
	}

		public static function switchPanel(newPanel:String, oldPanel:String, data:Object = null, removeOldPanel:Boolean = true):void
		{
			addPanel(newPanel, data);

			if (removeOldPanel) removePanel(oldPanel);
			else   				hidePanel(oldPanel);
		}

		public static function getPanelByName(name:String):IPanel
		{
			for each (var panel: IPanel in panels)
			{
				if (panel.name == name) return panel;
			}
			
			return null;
		}

		public static function set resReady (value: Boolean): void { resReadyFlag = value; }
		public static function get resReady (): Boolean { return resReadyFlag ; }

		public static function set placeTarget(value: Sprite): void
		{
			_placeTarget = value;

			sceneContainer = _placeTarget.addChild(new Sprite()) as Sprite;
			uiContainer = _placeTarget.addChild(new Sprite()) as Sprite;
			popupContainer = _placeTarget.addChild(new Sprite()) as Sprite;
			blendContainer = _placeTarget.addChild(new Sprite()) as Sprite;
			errorContainer = _placeTarget.addChild(new Sprite()) as Sprite;

			_placeTarget.addChild(new Stats());
		}

		public static function get placeTarget(): Sprite { return _placeTarget; }
	}
}