
package com.test.tir.api.view
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	import flash.geom.Transform;

	public interface IDisplayObject extends IEventDispatcher
	{
		function set alpha (value: Number): void;
		function set blendMode (value: String): void;
		function set height (value: Number): void;
		function set rotation (value: Number): void;
		function set scaleX (value: Number): void;
		function set scaleY (value: Number): void;
		function set scrollRect (value: Rectangle): void;
		function set transform (value: Transform): void;
		function set width (value: Number): void;
		function set visible (value: Boolean): void;
		function set x (value: Number): void;
		function set y (value: Number): void;
		
		function get displayObj(): DisplayObject;
	}
}