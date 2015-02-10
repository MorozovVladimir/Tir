/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.common.managers
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;

	public class FlashVarsManager
	{
		public static const PATH_URL: String = "pathUrl";

		private static var _stage: Stage;
		private static var projectStage: DisplayObject;
		private static var params: Dictionary = new Dictionary();

		private static function checkDomainPath(name: String): void
		{
			var url: String = "";

			if (!getData(name))
			{
				var arr: Array = projectStage.loaderInfo.url.split("/");
				var n: int = arr.length - 1;

				for (var i: int = 0; i < n; i++)
				{
					url += arr[i] + "/";
				}

				setData(name, url);
			}
		}

		public static function replaceUndefinedData(name: String, value: String): void
		{
			if (!getData(name)) setData(name, value);
		}

		public static function setData(name: String, value: String): void
		{
			params[name] = value;
		}

		public static function getData(value: String, def: String = null): String
		{
			if (params[value]) return params[value];
			if (projectStage.loaderInfo.parameters[value]) return String(projectStage.loaderInfo.parameters[value]);

			return def;
		}

		public static function getCustomArgs(): Object
		{
			var result: Object = null;
			var customUserArgs: String;

			if (ExternalInterface.available)
			{
				customUserArgs = ExternalInterface.call("window.location.search.toString");
				if (customUserArgs.charAt(0) == "?") customUserArgs = customUserArgs.substr(1);
			}

			if (customUserArgs != null) result = tryParseCustomArgs(customUserArgs);

			return result;
		}

		private static function tryParseCustomArgs(args: String): Object
		{
			var keyValuePairs: Array = args.split("&");
			var result: Object = {};
			for each (var str: String in keyValuePairs)
			{
				var keyValue: Array = str.split("=");
				var key: String = keyValue[0];
				result[key] = keyValue[1];
			}

			return result;
		}

		public static function set gameStage(value: Stage): void
		{
			_stage = value;
			projectStage = _stage.root;
			checkDomainPath(PATH_URL);
			//checkDomainPath(FlashVarsNames.DOMAIN_URL);
		}

		public static function get gameStage(): Stage {
			return _stage;
		}

		public static function get flashVars(): Object { return projectStage.loaderInfo.parameters; }
	}
}