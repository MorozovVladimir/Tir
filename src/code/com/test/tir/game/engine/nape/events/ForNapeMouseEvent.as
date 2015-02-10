/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.game.engine.nape.events
{
	import flash.events.MouseEvent;

	import nape.geom.Vec2;

	public class ForNapeMouseEvent extends MouseEvent
	{
		public var mousePoint: Vec2;

		public function ForNapeMouseEvent(type: String, mousePoint: Vec2, bubbles: Boolean = false, cancelable: Boolean = false)
		{
			this.mousePoint = mousePoint;

			super(type, bubbles, cancelable);
		}
	}
}