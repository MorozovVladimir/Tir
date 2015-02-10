/**
 * ...
 * @author Morozov V.
 */
package com.test.tir.common.utils
{
	import com.test.tir.common.managers.FlashVarsManager;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class CommonUtility
	{
		public static function getRandom( nLow: Number, nHigh: Number ): int
		{
			var rand: int = Math.floor( ( Math.random() * (  nHigh  - nLow + 1 ) ) + nLow);
			return rand;
		}
		
		public static function getRandomNumber( nLow: Number, nHigh: Number ): Number
		{
			var rand: Number = ( Math.random() * (  nHigh  - nLow) ) + nLow;
			return rand;
		}
		
		public static function changeTextToBitmap(clip: TextField, offset: Point = null): Bitmap
		{
			if (!offset) offset = new Point();
			
			var bm:Bitmap = getBitmap(clip, offset);
			bm.x = clip.x;
			bm.y = clip.y;
			
			if (!clip.parent) return bm;
			
			clip.parent.addChild(bm);
			clip.parent.removeChild(clip);
			
			return bm;
		}
		
		public static function getBitmap(clip: *, offset: Point = null):Bitmap
		{
			if (!offset) offset = new Point();
			
			var bmData:BitmapData = new BitmapData(clip.width + offset.x * 2, clip.height + offset.y * 2, true, 0);
			bmData.draw(clip, new Matrix(1, 0, 0, 1, offset.x, offset.y));
			
			return new Bitmap(bmData, PixelSnapping.AUTO, true);
		}
		
		public static function removeSpaces (sSrc: String): String
		{
			var sNew: String = sSrc;
			while (sNew.search(" ") > 0) sNew = sNew.replace(" ", "");
			return sNew;
		}
		
		public static function setTextInField (txt: TextField, str: String): void
		{
			if (!txt || !str) return;
			
			txt.text = str;
			
			if (txt.textWidth < txt.width && txt.textHeight < txt.height) return;
			
			while (txt.textWidth > txt.width - 5 || txt.textHeight > txt.height)
			{
				txt.text = txt.text.substring(0, txt.text.length - 4);
				txt.appendText("...");
				if (txt.text == "...") return;
			}
		}
		
		public static function setTextInFieldResize (txt: TextField, str: String): void
		{
			if (!txt || !str) return;
			
			txt.text = str;
			
			if (txt.textWidth < txt.width && txt.textHeight < txt.height) return;
			
			while (txt.textWidth > txt.width - 5 || txt.textHeight > txt.height)
			{
				var format:TextFormat = new TextFormat();
				format = txt.defaultTextFormat;
				format.size = int(txt.defaultTextFormat.size) - 1;
				txt.defaultTextFormat = format;
				txt.text = txt.text;
				
				if (format.size <= 1) return;
			}
		}
		
		public static function setFrameChecker (clip: MovieClip, frameName: String, callBack: Function): void
		{
			function frameChecker (event: Event): void
			{
				if (clip.currentLabel == frameName)
				{
					callBack(clip);
					clip.removeEventListener(Event.ENTER_FRAME, frameChecker);
				}
			}
			
			clip.addEventListener(Event.ENTER_FRAME, frameChecker);
		}
		
		public static function checkUrl (url: String): String
		{
			var resUrl: String;
			if (url.search("http://") == 0 && url.search("https://") == 0)
				resUrl = url;
			else if(url != "")
				resUrl = FlashVarsManager.getData(FlashVarsManager.PATH_URL) + url;
			
			return CommonUtility.fixUrl(url);
		}

		public static function fixUrl(url:String):String
		{
			return url.replace('Main.swf/[[DYNAMIC]]/', '');
		}
		
		public static function formatNumbers (num: Number, delim: String = " "): String
		{
			if (num < 1000) return num.toString();
			
			var res: String = num.toString();
			var tmp: Array = [];
			var str: String;
			for (var i: int = res.length; i >= 0; i-=3)
			{
				str = res.substring(i - 3, i);
				if(str.length > 0) tmp.push(str);
			}
			
			return tmp.reverse().join(delim);
		}

		public static function formatTime(time:int, showHours:Boolean = false):String
		{
			var hours:int = ((showHours) ? Math.floor(time / 3600) : 0);
			var minutes:int = Math.floor((time - hours * 3600) / 60);
			var seconds:int = time - hours * 3600 - minutes * 60;
			
			var res: String = (showHours) ? addLeadingZero(hours.toString()) + ":" : "";
			return res + addLeadingZero(minutes.toString()) + ":" + addLeadingZero(seconds.toString());
		}
		
		private static function addLeadingZero(number:String):String 
		{
			return ((number.length == 1) ? ("0" + number) : number);
		}
		
		public static function string2Array (src:String): Array 
		{
			//trace("Parent.string2Array : "+arguments)
			src = src.split("\t").join("").split("\r").join("").split("\n").join("").split(" ").join("");
			var resArray:Array = new Array();
			var datArray:Array = String(src).split("&");
			for ( var i: int; i < datArray.length; i++ ) 
			{
				var arr:Array = datArray[i].split("=");
				if ( ! arr[0] ) continue;
				if ( arr[1] != null ) resArray[String(unescape(arr[0]))] = unescape(arr[1]);
				else resArray.push(unescape(arr[0]));
			}
			return resArray;
		}
		
		public static function removeAllChildren(conteiner:DisplayObjectContainer):void 
		{
			if (conteiner)
			{
				for(var i:int = conteiner.numChildren - 1; i >=0; i--)
				{
					conteiner.removeChildAt(i);
				}
			}
		}
		
		public static function fromCharCode(value: String): String
		{
			var tmp: Array = String(value).split(",");
			if (tmp.length < 2) return value;
			
			var res: String = ""
			var cnt: int = tmp.length;
			for (var i:int = 0; i < cnt; i++) 
			{ 
				res += String.fromCharCode(tmp[i]);
				
			}
			
			return res;
		}
		
		public static function getCharCode(value: String): String
		{
			var res:Array = []; 
			var cnt: int = value.length;
			for (var i:int = 0; i < cnt; i++) 
			{ 
				res.push(value.charCodeAt(i)); 
			}
			
			return res.join(",");
		}
	}
}