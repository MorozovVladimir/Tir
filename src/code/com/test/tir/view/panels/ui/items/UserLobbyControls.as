/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.view.panels.ui.items
{
	import com.test.tir.common.utils.StringUtility;
	import com.test.tir.game.data.GameData;

	import flash.display.MovieClip;

	public class UserLobbyControls extends UserInterfaceItem
	{
		public function UserLobbyControls(uiItemName:String, uiItemClip:MovieClip)
		{
			super(uiItemName, uiItemClip);
		}
		
		override public function set show(value: Boolean): void
		{
			super.show = value;
			if(value)
			{
				getChildrenTextField("txtTargetCnt").text = GameData.COUNT_TARGET.toString();
				getChildrenTextField("txtTimer").text = StringUtility.formatTime(GameData.TIME / 1000);
			}
		}
	}
}