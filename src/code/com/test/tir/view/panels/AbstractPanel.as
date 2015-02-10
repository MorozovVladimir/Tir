/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.view.panels
{
	import com.test.tir.api.view.IPanel;
	import com.test.tir.common.managers.panels.PanelsManager;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class AbstractPanel extends Sprite implements IPanel
	{
		protected var panelName:String;
		protected var panelData:Object;
		protected var panelType:String;

		public function AbstractPanel(panelName:String, panelData:Object) 
		{
			this.panelName = panelName;
			this.panelData = panelData;
			
			init();
			
			super();
		}

		protected function init():void 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			initView();
		}

		protected function initView(): void {}
		
		private function onAddedToStageHandler(event:Event):void
		{
			openPanel();
		}

		protected function openPanel():void { }

		public function remove():void 
		{
			PanelsManager.removePanel(panelName);
		}

		public function destroy():void 
		{
			panelData = null;
		}

		public function show():void { visible = true; }
		public function hide():void { visible = false;}

		override public function get name():String { return panelName; }
		public function get type():String { return panelType; }
		public function get displayObj():DisplayObject { return this; }

		public function set data(value:Object):void { panelData = value; }
		public function get data():Object { return panelData; }
	}
}