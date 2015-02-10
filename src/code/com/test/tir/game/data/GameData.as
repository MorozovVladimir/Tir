/**
 * ...
 * @author Morozov V.
 */
package com.test.tir.game.data
{
	import com.test.tir.common.events.ProjectEvent;
	import com.test.tir.common.managers.EventManager;

	public class GameData
	{
		public static var COUNT_TARGET: int;
		public static var SPEED: int;
		public static var TIME: int;

		private static var params: XMLList;

		private static var _countTargetLost: int;

		public static function initialize(xmlList: XMLList): void
		{
			params = xmlList;

			COUNT_TARGET = Math.max(Math.min(params.@countTarget, 10000), 1);
			SPEED = Math.max(Math.min(params.@speed, 100), 1);
			TIME = Math.max(Math.min(params.@time, 5), 0.1) * 60 * 1000;
		}

		public static function get countTargetLost (): int { return _countTargetLost; }
		public static function set countTargetLost (value: int): void
		{
			_countTargetLost = value;
			EventManager.DISPATCHER.dispatchEvent(new ProjectEvent(ProjectEvent.GAME_DATA_UPDATE));
		}
	}
}
