/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.common.managers
{
	import com.test.tir.api.view.IUserInterfaceItem;
	import com.test.tir.common.params.UIItemNames;
	import com.test.tir.view.panels.ui.items.UserGameControls;
	import com.test.tir.view.panels.ui.items.UserInfo;
	import com.test.tir.view.panels.ui.items.UserLobbyControls;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	public class UserInterfaceManager
	{
		public static var uiItems: Dictionary;
		private static var uiClip: Sprite;

		public static function init(clip: Sprite): void
		{
			uiClip = clip;

			uiItems = new Dictionary();

			createItems();
			initItems();
		}

		public static function showItem(name: String, flag: Boolean): void
		{
			if (!getUiItemByName(name)) return;

			getUiItemByName(name).show = flag;
		}

		public static function getUiItemByName(name: String): IUserInterfaceItem
		{
			if (!uiItems || !uiItems[name]) return null;

			return uiItems[name] as IUserInterfaceItem;
		}

		private static function initItems(): void
		{
			for each (var item: IUserInterfaceItem in uiItems)
			{
				item.init();
			}
		}

		private static function createItems(): void
		{
			addItem(UIItemNames.USER_INFO, UserInfo, uiClip["userInfoClip"]);
			addItem(UIItemNames.CONTROLS_GAME, UserGameControls, uiClip["gameControlsClip"]);
			addItem(UIItemNames.CONTROLS_LOBBY, UserLobbyControls, uiClip["lobbyControlsClip"]);
		}

		private static function addItem(name: String, classValue: Class, clip: MovieClip): void
		{
			uiItems[name] = new classValue(name, clip);
		}
	}
}