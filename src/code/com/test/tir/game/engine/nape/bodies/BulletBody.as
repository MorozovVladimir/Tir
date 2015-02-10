/**
 * Created with IntelliJ IDEA.
 * User: Morozov V.
 * Date: 07.02.15
 * Time: 22:33
 */
package com.test.tir.game.engine.nape.bodies
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.test.tir.common.params.AssetNames;
	import com.test.tir.game.data.GameData;
	import com.test.tir.game.engine.effects.Effect;
	import com.test.tir.game.engine.nape.PhysicalSpace;

	import flash.utils.setTimeout;

	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;

	import starling.extensions.ParticleSystem;

	public class BulletBody extends PhysicalBody
	{
		public static var ASSET_NAME: String = "BulletBm";

		private var initPos: Vec2;
		private var direction: Vec2;
		private var rotation: Number;

		private var trailEffect: Effect;

		public function BulletBody(space: PhysicalSpace, material: Material, initPos: Vec2, direction: Vec2, rotation: Number)
		{
			this.initPos = initPos;
			this.direction = direction.muleq(33 + GameData.SPEED / 3);
			this.rotation = rotation;

			this.assetName = ASSET_NAME;

			super(space, material);
		}

		override protected function createBody(): void
		{
			bodyInst = new Body(BodyType.DYNAMIC, initPos);
			bodyInst.shapes.add(new Circle(8, null, material, PhysicalSpace.SHOT_FILTER));
			bodyInst.cbTypes.add(PhysicalSpace.CB_SHOT_TYPE);
			bodyInst.rotation = rotation;
			bodyInst.allowRotation = false;
			bodyInst.applyImpulse(direction, initPos);

			super.createBody();

			createTrailEffect();
		}

		private function createTrailEffect (): void
		{
			trailEffect = space.gameFieldInst.createEffect(AssetNames.PARTICLE_BULLET);
			trailEffect.particleSystem.advanceTime(2);
		}

		override protected function graphicUpdate(): void
		{
			super.graphicUpdate();

			if(!trailEffect || !viewClip) return;

			trailEffect.x = viewClip.x;
			trailEffect.y = viewClip.y;
			trailEffect.rotation = viewClip.rotation;

			trailEffect.particleSystem.maxCapacity = Math.min( Math.abs(body.velocity.y), 100) - 25;

			if(trailEffect.particleSystem.maxCapacity < 1) trailEffect.destroy();
		}

		public function createExplode (): void
		{
			space.gameFieldInst.createEffect(AssetNames.PARTICLE_EXPLODE, true, bodyInst.position.toPoint()).particleSystem.start(.3);
			destroy();
		}

		override public function destroy (): void
		{
			initPos = direction = null;

			trailEffect.destroy(); trailEffect = null;

			super.destroy();
		}
	}
}
