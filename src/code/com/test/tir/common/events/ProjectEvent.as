/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.common.events
{
	import flash.events.Event;

	public class ProjectEvent extends Event
	{
		public static const GAME_STARTED:String = "game.started";
		public static const GAME_EXIT:String = "game.exit";
		
		public static const APPLICATION_IS_READY:String = "application.is.ready";

        public static const PANEL_ADD:String = "panel.add";
		public static const PANEL_DEL:String = "panel.del";
		public static const PANEL_SHOW:String = "panel.show";
		public static const PANEL_HIDE:String = "panel.hide";

		public static const GAME_DATA_UPDATE:String = "game.data.update";
		
		private var _data:Object;

		public function ProjectEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_data = data;
			super(type, bubbles, cancelable);
		}

		public function get data():Object
		{
			return _data;
		}
	}
}