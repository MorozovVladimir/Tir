/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.view.panels.ui.items
{
	import com.test.tir.api.view.IUserInterfaceItem;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.EventDispatcher;
	import flash.text.TextField;

	public class UserInterfaceItem extends EventDispatcher implements IUserInterfaceItem
	{
		protected var uiItemClip:MovieClip;
		protected var uiItemName:String;

		private var isShow:Boolean;

		public function UserInterfaceItem(uiItemName:String, uiItemClip:MovieClip)
		{
			this.uiItemName = uiItemName;
			this.uiItemClip = uiItemClip;
			
			createControls ();
		}

		protected function createControls (): void { }
		
		public function init():void	{ }

		public function set show(value:Boolean):void { uiItemClip.visible = isShow = value; }
		public function get show():Boolean { return isShow; }

		public function getChildrenMovieClip(name:String):MovieClip { return uiItemClip.getChildByName(name) as MovieClip; }
		public function getChildrenTextField(name:String):TextField { return uiItemClip.getChildByName(name) as TextField; }
		public function getChildrenSimpleButton(name:String):SimpleButton { return uiItemClip.getChildByName(name) as SimpleButton; }
		public function addChildren(clip: DisplayObject): void { uiItemClip.addChild(clip); }

		public function get view (): MovieClip { return uiItemClip; }

		public function destroy():void
		{
			uiItemClip = null;
		}
	}
}