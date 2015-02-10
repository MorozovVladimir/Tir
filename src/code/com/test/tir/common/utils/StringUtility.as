/**
 * Created with IntelliJ IDEA.
 * User: Morozov V.
 * Date: 03.12.13
 * Time: 11:55
 */
package com.test.tir.common.utils
{
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class StringUtility
	{
		public static function removeSpaces(sSrc: String): String
		{
			var sNew: String = sSrc;
			while (sNew.search(" ") > 0)
			{
				sNew = sNew.replace(" ", "");
			}
			return sNew;
		}

		public static function setTextInField(txt: TextField, str: String): void
		{
			if (!txt || !str) return;

			txt.text = str;

			if (txt.textWidth < txt.width && txt.textHeight < txt.height) return;

			txt.appendText("...");

			while (txt.textWidth > txt.width - 5 || txt.textHeight > txt.height)
			{
				txt.text = txt.text.substring(0, txt.text.length - 4);
				txt.appendText("...");
				if (txt.text == "...") return;
			}
		}

		public static function setTextInFieldResize(txt: TextField, str: String): void
		{
			if (!txt || !str) return;

			txt.text = str;

			if (txt.textWidth < txt.width && txt.textHeight < txt.height) return;

			while (txt.textWidth > txt.width - 5 || txt.textHeight > txt.height)
			{
				var format: TextFormat = new TextFormat();
				format = txt.defaultTextFormat;
				format.size = int(txt.defaultTextFormat.size) - 1;
				txt.defaultTextFormat = format;
				txt.text = txt.text;

				if (format.size <= 1) return;
			}
		}

        public static function voice(count:int):String
        {
            if (count == 11 || count == 12 || count == 13 || count == 14)
                return "голосов";

            var value:String = count.toString();
            value = value.substr(value.length - 1,1);

            if (value == '2' || value == '3' || value == '4')
                return "голоса";
            if (value == '5' || value == '6' || value == '7'|| value == '8'|| value == '9'|| value == '0')
                return "голосов";

            return "голос";
        }

        //в секундах
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


        public static function getDayTextArr(day:int):Array
        {
            var base:Array = ["4 дня назад","3 Дня назад","2 Дня назад","Вчера","Сегодня","Завтра","Через 2 дня","Через 3 дня","Через 4 дня"];

            var out:Array=[];
            for (var i:int=0; i<5; i++)
            {
                out.push(base[4-day+i]);
            }

            return out;
        }


	}
}
