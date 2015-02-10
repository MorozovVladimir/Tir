/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.view.loaders
{
	import gui.main.PreloaderMainClip;

	public class MainLoader extends AbstractLoader
	{
		private var preloaderClip:PreloaderMainClip;

		public function MainLoader()
		{
			super();
		}

		override protected function init():void
		{
			preloaderClip = new PreloaderMainClip();
			addChild(preloaderClip);
			setValue(0);
		}

		override protected function setValue (value: int): void
		{
            if(!preloaderClip) return;
			preloaderClip.progressBarClip.gotoAndStop(value + 1);
			preloaderClip.progressPercentText.text = value.toString() + "%";
		}
		
		override public function destroy():void
		{
			removeChild(preloaderClip);
			preloaderClip = null;
		}
	}
}