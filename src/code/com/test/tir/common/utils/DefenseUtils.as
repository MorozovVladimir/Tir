package com.test.tir.common.utils
{
	import flash.external.ExternalInterface;

	public class DefenseUtils
	{
		public function DefenseUtils()
		{
		}
		
		private static function get random():Boolean { return Math.random() > 0.5; }
		private static function get check():Boolean { return random; }
		
		public static function defenseDomain(xmlData:XMLList, handler:Function = null):void
		{
			if (check)
			{
				var domain:String = "";
				if (ExternalInterface.available)
				{
					domain = ExternalInterface.call("eval", "document.domain");
					domain = domain.indexOf("." + xmlData.@url.toString()) > 0 ? domain : "";
					
					if (handler != null)
					{
						handler(domain == "");
					}
				}
			}
		}
		
		public static function suicide(value:Boolean):void
		{
			if (value)
			{
				while ( -1) 
				{ 
					trace(hostString);
				}
			}
		}
		
		public static function get hostString():String
		{
			var domain:String = "";
			
			if (ExternalInterface.available)
				domain = ExternalInterface.call('window.location.href.toString');
			else
				domain = "local";
			
			return "url : " + domain + "\n";
		}
	}
}