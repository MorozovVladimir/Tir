/**
 * ...
 * @author Morozov V.
 */
package com.test.tir.common.managers.assets.types
{
	import flash.events.IEventDispatcher;

	public interface IAsset extends IEventDispatcher
	{
		function set loadCoeff(value: Number): void;
		function get name(): String;
		function get checkLoad(): Boolean;
		function get data(): *;
		function get percent(): int;
		function checkData(loadCallBack: Function): void;
		function destory(): void;
	}
}