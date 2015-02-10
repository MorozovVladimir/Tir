package com.test.tir.common.managers.shared
{
	import flash.net.SharedObject;

	public class SharedObjectManager
	{
		private static var sharedObjectInst: SharedObject;

		public static function set locale (value: String): void
		{
			sharedObjectInst = SharedObject.getLocal(value);
		}

		public static function saveData(name: String, data: Object): void
		{
			sharedObjectInst.data[name] = data;
			try
			{
				sharedObjectInst.flush();
			} catch (e: Error)
			{
				trace("error saving data");
			}
		}

		public static function loadData(name: String): Object
		{
			return sharedObjectInst.data[name];
		}

		public static function clearData(): void
		{
			sharedObjectInst.clear();
		}

		public static function loadOrSetDefaultData(name: String, data: *): *
		{
			if (loadData(name) == null)
			{
				saveData(name, data);
				return data;
			}
			else
			{
				return loadData(name);
			}
		}
	}
}