/**
 * ...
 * @author Morozov V.
 */
package com.test.tir.common.managers
{
	import flash.events.EventDispatcher;

	public class CommonManager extends EventDispatcher
	{
		private static var _applicationIsReady:Boolean;

		public static function get applicationIsReady():Boolean { return _applicationIsReady; }
		public static function set applicationIsReady(value:Boolean):void { _applicationIsReady = value; }
	}
}