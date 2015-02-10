/**
 * Created with IntelliJ IDEA.
 * User: Morozov V.
 * Date: 05.02.15
 * Time: 21:20
 */
package com.test.tir.game.engine.nape.bodies
{
	import com.test.tir.common.managers.EventManager;
	import com.test.tir.common.params.AssetNames;
	import com.test.tir.game.GameController;
	import com.test.tir.game.engine.nape.PhysicalSpace;
	import com.test.tir.game.engine.nape.events.ForNapeMouseEvent;

	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;

	public class CannonBody extends PhysicalBody
	{
		public static var ASSET_NAME: String = "CannonBm";

		private static const SHOT_DELAY: int = 1000;

		private var carriage: Circle;
		private var barrel: Circle;
		private var trunk: Polygon;

		private var mouseJoint: PivotJoint;
		private var groundJoin: PivotJoint;

		private var fireTimer: Timer;
		private var isMakeShot: Boolean = true;
		private var delayClickTimeout: int;

		public function CannonBody(space: PhysicalSpace, material: Material = null)
		{
			this.assetName = ASSET_NAME;
			this.fireTimer = new Timer(SHOT_DELAY, 100);

			super(space, material);
		}

		override protected function createBody(): void
		{
			var mainPos: Vec2 = new Vec2(400, 550);

			bodyInst = new Body(BodyType.DYNAMIC, mainPos);
			bodyInst.shapes.add(trunk = new Polygon(Polygon.rect(-10, -80, 20, 60), Material.steel()));
			bodyInst.shapes.add(carriage = new Circle(40, null, Material.steel()));
			bodyInst.shapes.add(barrel = new Circle(10, Vec2.get(0, -80), Material.steel()));

			super.createBody();

			createJoins(mainPos);

			mouseEventIntention(EventManager.DISPATCHER.addEventListener);
			fireTimer.addEventListener(TimerEvent.TIMER, shot);
		}

		override protected function createView (name: String, top: Boolean = true): void
		{
			super.createView(name);
			viewClip.pivotY += 10;
		}

		private function createJoins(mainPos: Vec2): void
		{
			groundJoin = new PivotJoint(space.spaceInst.world, bodyInst, bodyInst.localPointToWorld(carriage.localCOM), bodyInst.worldPointToLocal(mainPos))
			groundJoin.stiff = true;
			groundJoin.ignore = true;
			groundJoin.space = space.spaceInst;

			mouseJoint = new PivotJoint(space.spaceInst.world, bodyInst, Vec2.get(200, 200), Vec2.get(bodyInst.localCOM.x, bodyInst.localCOM.y - 70));
			mouseJoint.stiff = false;
			mouseJoint.maxForce = 100000;
			mouseJoint.damping = 2;
			mouseJoint.frequency = 0.5;
			mouseJoint.space = space.spaceInst;
		}

		private function mouseEventIntention(method: Function): void
		{
			method(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			method(MouseEvent.MOUSE_UP, mouseUpHandler);
			method(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}

		private function mouseDownHandler(event: ForNapeMouseEvent): void
		{
			fireTimer.start();
			if(isMakeShot)
			{
				shot();
				isMakeShot = false;
			}
		}

		private function mouseUpHandler(event: MouseEvent): void
		{
			fireTimer.reset();
		}

		private function mouseMoveHandler(event: ForNapeMouseEvent): void
		{
			mouseJoint.anchor1 = event.mousePoint;
		}

		override protected function graphicUpdate(): void
		{
			super.graphicUpdate();
		}

		private function shot (event: TimerEvent = null): void
		{
			if(!GameController.isPlay) return;

			clearTimeout(delayClickTimeout);
			delayClickTimeout = setTimeout(function(): void { isMakeShot = true; }, SHOT_DELAY);

			var initPos: Vec2 = bodyInst.localPointToWorld(mouseJoint.anchor2);
			var direction:Vec2 = bodyInst.worldCOM.sub(barrel.worldCOM);

			var bullet: BulletBody = new BulletBody(space, Material.steel(), initPos, direction, bodyInst.rotation);
		}

		override public function destroy(): void
		{
			fireTimer.stop();
			fireTimer.removeEventListener(TimerEvent.TIMER, shot);
			fireTimer = null;

			clearTimeout(delayClickTimeout);

			mouseEventIntention(EventManager.DISPATCHER.removeEventListener);

			groundJoin.space = mouseJoint.space = null;
			groundJoin = mouseJoint = null;

			carriage = null;
			trunk = null;

			super.destroy();
		}
	}
}