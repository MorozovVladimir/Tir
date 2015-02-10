/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.api.view
{
	import flash.events.IEventDispatcher;

	public interface ILoaderRespondent extends IEventDispatcher
	{
		function get percent (): int;
	}
}