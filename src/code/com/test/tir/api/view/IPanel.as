/**
 * ...
 * @author Morozov V.
 */
package com.test.tir.api.view
{
	public interface IPanel extends IDisplayObject
	{
		function get name (): String;
		function get type (): String;
		function set data (value: Object): void;

		function show (): void;
		function hide (): void;
		function remove (): void;
		function destroy (): void;
	}
}