/**
 * Created with IntelliJ IDEA.
 * User: Morozov V.
 * Date: 05.02.15
 * Time: 21:20
 */
package com.test.tir.game.engine.nape.bodies
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.test.tir.game.data.GameData;
	import com.test.tir.game.engine.nape.PhysicalSpace;

	import flash.geom.Rectangle;

	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;

	public class TargetBody extends PhysicalBody
	{
		public static var ASSET_NAME: String = "TargetBm";

		private const MIN_SEED: int = 10;
		private const MIN_RADIUS: int = 20;
		private const BATTLE_RECT: Rectangle = new Rectangle(50, 75, 700, 310);

		public function TargetBody(space: PhysicalSpace, material: Material)
		{
			this.assetName = ASSET_NAME;

			super(space, material);
		}

		override protected function createBody(): void
		{
			bodyInst = new Body(BodyType.DYNAMIC, Vec2.get(BATTLE_RECT.x + Math.round(Math.random() * BATTLE_RECT.width), BATTLE_RECT.y + Math.round(Math.random() * BATTLE_RECT.height)));
			bodyInst.shapes.add(new Circle(MIN_RADIUS + Math.random() * 10, null, material, PhysicalSpace.TARGET_FILTER));
			bodyInst.cbTypes.add(PhysicalSpace.CB_TARGET_TYPE);
			bodyInst.angularVel = bodyInst.gravMass = 0;
			bodyInst.allowRotation = false;
			bodyInst.applyImpulse(rndHorizontalImpulse);

			super.createBody();
		}

		override protected function createView (name: String, top: Boolean = true): void
		{
			super.createView(name);

			viewClip.scaleX = viewClip.scaleY = bodyInst.bounds.width/viewClip.width;
		}

		public function createExplode (): void
		{
			GameData.countTargetLost--;
			bodyInst.space = null;
			TweenMax.to(viewClip, 1,  { ease:Linear.easeIn,
										bezier:[ { x: Math.random() * 700, y: Math.random() * 300 }, { x:(Math.random() > 0.5) ? -30 : 830, y:-30 } ],
										orientToBezier:false, onComplete:destroy});
		}

		private function get rndHorizontalImpulse (): Vec2
		{
			var imp: Vec2 = Vec2.get(MIN_SEED * ((Math.random() > 0.5) ? 1 : -1), 0);
			imp.muleq(1 + Math.random() * 1);

			return imp;
		}
	}
}