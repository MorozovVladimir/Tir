/**
 * Created with IntelliJ IDEA.
 * User: Morozov V.
 * Date: 05.02.15
 * Time: 20:44
 */
package com.test.tir.game.engine
{
	import com.test.tir.common.managers.assets.ExternalAssetManager;
	import com.test.tir.common.params.AssetNames;
	import com.test.tir.game.engine.effects.Effect;
	import com.test.tir.game.engine.nape.PhysicalSpace;
	import com.test.tir.game.engine.nape.bodies.BulletBody;
	import com.test.tir.game.engine.nape.bodies.CannonBody;
	import com.test.tir.game.engine.nape.bodies.TargetBody;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.setTimeout;

	import starling.core.Starling;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.extensions.Particle;
	import starling.extensions.ParticleSystem;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class GameField extends Sprite
	{
		private var bg: Quad;
		private var physicalSpace: PhysicalSpace;

		private var assets: AssetManager;
		private var effects: Array = [];

		public function GameField()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e: Event): void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			bg = new Quad(800, 600, 0x003366);
			addChild(bg);

			createAssets();

			physicalSpace = new PhysicalSpace(this);

			addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler);
			addEventListener(TouchEvent.TOUCH, touchHandler);
		}

		private function createAssets (): void
		{
			assets = new AssetManager();

			createTexture(CannonBody.ASSET_NAME);
			createTexture(TargetBody.ASSET_NAME);
			createTexture(BulletBody.ASSET_NAME);
		}

		private function createTexture (name: String): void
		{
			var bmd: BitmapData = ExternalAssetManager.getItemByLinkage(AssetNames.GAME_ASSET, name) as BitmapData;
			assets.addTexture(name, Texture.fromBitmapData(bmd));
		}

		private function touchHandler(event: TouchEvent): void
		{
			var touch: Touch = event.getTouch(stage);
			if (!touch) return;

			var mousePoint: Point = touch.getLocation(stage);

			switch (touch.phase)
			{
				case TouchPhase.BEGAN:
					physicalSpace.touchBegan(mousePoint);
					break;
				case TouchPhase.ENDED:
					physicalSpace.touchEnded(mousePoint);
					break;
				case TouchPhase.HOVER:
					physicalSpace.touchMoved(mousePoint);
					break;
				case TouchPhase.MOVED:
					physicalSpace.touchMoved(mousePoint);
					break;
			}
		}

		private function enterFrameHandler(event: Event): void
		{
			if(physicalSpace) physicalSpace.update();
		}

		public function createImage (name: String, top: Boolean): DisplayObject
		{
			var img: Image = new Image(assets.getTexture(name));
			if(top) addChild(img);
			else	addChildAt(img, 1);

			return img;
		}

		public function createEffect (name: String, top: Boolean = true, pos: Point = null): Effect
		{
			pos = (!pos) ? new Point() : pos;

			var effect: Effect = new Effect(name);
			effect.x = pos.x; effect.y = pos.y;

			if(top) addChild(effect);
			else	addChildAt(effect, 2);

			return effect;
		}

		public function deleteImage (value: DisplayObject): void
		{
			removeChild(value);
			value.dispose();
		}

		public function pause(): void
		{
			removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler);
			removeEventListener(TouchEvent.TOUCH, touchHandler);
		}

		public function destroy(): void
		{
			removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler);
			removeEventListener(TouchEvent.TOUCH, touchHandler);

			assets.dispose(); assets = null;

			bg.dispose(); bg = null;

			physicalSpace.destroy();
			physicalSpace = null;
		}
	}
}
