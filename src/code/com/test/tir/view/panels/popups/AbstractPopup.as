/**
 * ...
 * @author Morozov V.
 */

package com.test.tir.view.panels.popups
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.test.tir.common.managers.assets.ExternalAssetManager;
	import com.test.tir.common.params.AssetNames;
	import com.test.tir.common.params.PanelNames;
	import com.test.tir.common.params.PanelTypes;
	import com.test.tir.view.panels.AbstractPanel;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	public class AbstractPopup extends AbstractPanel
	{
		protected var position:Point;
		protected var view:Sprite;
		protected var bgClip:Sprite;
		protected var openSoundName:String;

		private var closeBtn:SimpleButton;

		public function AbstractPopup(panelName:String, panelData:Object)
		{
			panelType = PanelTypes.PANEL_POPUP;
			openSoundName = "popupOpenSnd";

			super(panelName, panelData);
		}
		
		override protected function init():void
		{
			bgClip = ExternalAssetManager.getItemByLinkage(AssetNames.POPUP_ASSET, PanelNames.POPUP_DISABLE) as Sprite;
			addChildAt(bgClip, 0);

			super.init();
			
			closeBtn = getChildrenSimpleButton("btnClose");
			if(closeBtn) closeBtn.addEventListener(MouseEvent.CLICK, closeClickHandler);
		}
		
		override protected function initView():void
		{
			view = ExternalAssetManager.getItemByLinkage(AssetNames.POPUP_ASSET, panelName) as Sprite;
			addChild(view);
			
			if (!position) position = new Point(Math.round((bgClip.width - view.width) / 2), Math.round((bgClip.height - view.height) / 2));
			
			view.x = -view.width;
			view.y = position.y;
			
			super.initView();
		}
		
		override protected function openPanel():void
		{
			if (!view) 
			{
				remove();
				return;
			}
			expandStart();
			playOpenSound();
		}

		protected function expandStart():void
		{
			TweenLite.to(view, 0.5, {x: position.x, y: position.y, ease: Back.easeOut, onComplete:expandComplete});
		}

		protected function expandComplete():void
		{
			TweenLite.killTweensOf(view);
		}

		override public function remove():void
		{
			if (data && data.hasOwnProperty("removeCallBack") && data.removeCallBack != null) data.removeCallBack();
			super.remove();
		}
		
		protected function closeClickHandler (event: MouseEvent): void
		{
			remove();
		}
		
		protected function playOpenSound():void
		{

		}

		public function getChildrenMovieClip(name:String):MovieClip
		{
			return view.getChildByName(name) as MovieClip;
		}

		public function getChildrenTextField(name:String):TextField
		{
			return view.getChildByName(name) as TextField;
		}

		public function getChildrenSimpleButton(name:String):SimpleButton
		{
			return view.getChildByName(name) as SimpleButton;
		}

		override public function destroy():void
		{
			if (closeBtn) closeBtn.removeEventListener(MouseEvent.CLICK, closeClickHandler);
			
			removeChild(view);
			view = null;

			if (bgClip)
			{
				removeChild(bgClip);
				bgClip = null;
			}
			
			super.destroy();
		}
	}
}