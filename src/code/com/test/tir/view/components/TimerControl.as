/**
 * Created with IntelliJ IDEA.
 * User: Morozov V.
 * Date: 30.11.14
 * Time: 17:38
 */
package com.test.tir.view.components
{
	import com.test.tir.common.utils.StringUtility;

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	public class TimerControl
	{
		private var timer: int;

		private var startTime: int;
		private var roundTime: int;

		private var txtTime: TextField;
		private var mcTimeBar: MovieClip;

		private var finishCall: Function;

		public function TimerControl(txtTime: TextField, mcTimeBar: MovieClip = null, finishCall: Function = null)
		{
			this.txtTime = txtTime;
			this.mcTimeBar = mcTimeBar;
			this.finishCall = finishCall;
		}

		public function startTimer(value: int): void
		{
			startTime = getTimer();
			roundTime = value;

			timerTick();
		}

		public function stop(): void
		{
			clearTimeout(timer);
		}

		private function timerTick (): void
		{
			if(!txtTime) return;

			var r: int = roundTime - (getTimer() - startTime);
			var time: int = r / 1000 * 60;
			txtTime.text = StringUtility.formatTime((time < 0) ? 0 : time, true);
			if(mcTimeBar) mcTimeBar.gotoAndStop(Math.round(r * 100 / roundTime));

			if(r > 0) timer = setTimeout(timerTick, 10);
			else if(finishCall != null) finishCall();
		}

		public function destroy (): void
		{
			txtTime = null;
			mcTimeBar = null;

			clearTimeout(timer);
		}
	}
}
