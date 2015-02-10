/**
 * Created with IntelliJ IDEA.
 * User: Morozov V.
 * Date: 05.02.15
 * Time: 20:54
 */
package com.test.tir.game.engine.nape
{
	import com.test.tir.common.managers.EventManager;
	import com.test.tir.common.managers.panels.PanelsManager;
	import com.test.tir.common.params.PanelNames;
	import com.test.tir.game.data.GameData;
	import com.test.tir.game.engine.GameField;
	import com.test.tir.game.engine.nape.bodies.CannonBody;
	import com.test.tir.game.engine.nape.bodies.FieldBody;
	import com.test.tir.game.engine.nape.bodies.TargetBody;
	import com.test.tir.game.engine.nape.events.ForNapeMouseEvent;
	import com.test.tir.view.panels.scene.GameScene;

	import flash.Boot;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.callbacks.Listener;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.space.Space;
	import nape.util.BitmapDebug;
	import nape.util.Debug;

	public class PhysicalSpace
	{
		public static const CB_SHOT_TYPE: CbType = new CbType();
		public static const CB_TARGET_TYPE: CbType = new CbType();
		public static const CB_FIELD_BORDER_TYPE: CbType = new CbType();

		public static const TARGET_FILTER: InteractionFilter = new InteractionFilter(0x0010, ~0x0010);
		public static const SHOT_FILTER: InteractionFilter = new InteractionFilter(0x0100, ~0x0100);

		private var gameField: GameField;

		private var gravity: Vec2 = Vec2.get(0, 100);

		private var space: Space;
		private var mousePoint: Vec2;

		private var debug: Debug;
		private var isDebugMode: Boolean = false;

		public function PhysicalSpace(gameField: GameField)
		{
			new Boot();

			this.gameField = gameField;
			init();
		}

		private function init(): void
		{
			initSpace();
			initDebug();
		}

		private function initDebug(): void
		{
			if (!isDebugMode) return;

			debug = new BitmapDebug(800, 600, 0x999999, true);
			debug.drawConstraints = true;
			(PanelsManager.getPanelByName(PanelNames.SCENE_GAME) as GameScene).sceneClip.addChild(debug.display);
		}

		private function initSpace(): void
		{
			space = new Space(gravity);

			var field: FieldBody = new FieldBody(this, Material.wood());
			var cannonBody: CannonBody = new CannonBody(this, Material.steel());
			var targetBody: TargetBody;
			for(var i: int; i < GameData.COUNT_TARGET; i++)
			{
				targetBody = new TargetBody(this, new Material(10, 0, 0, 0.1));
			}

			space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, CB_SHOT_TYPE, CB_FIELD_BORDER_TYPE, shotOnFieldBorder));
			space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, CB_SHOT_TYPE, CB_TARGET_TYPE, shotOnTarget));
		}

		public function touchBegan(point: Point): void
		{
			EventManager.DISPATCHER.dispatchEvent(new ForNapeMouseEvent(MouseEvent.MOUSE_DOWN, mousePoint = Vec2.fromPoint(point)));
		}

		public function touchEnded(point: Point): void
		{
			EventManager.DISPATCHER.dispatchEvent(new ForNapeMouseEvent(MouseEvent.MOUSE_UP, mousePoint = Vec2.fromPoint(point)));
		}

		public function touchMoved(point: Point): void
		{
			EventManager.DISPATCHER.dispatchEvent(new ForNapeMouseEvent(MouseEvent.MOUSE_MOVE, mousePoint = Vec2.fromPoint(point)));
		}

		public function update(): void
		{
			if(!space) return;

			if(space.bodies && space.bodies.length > 0)
				space.bodies.foreach(function (body: Body): void { if (body.userData.hasOwnProperty("graphicUpdate"))body.userData.graphicUpdate(); });

			if(isDebugMode)
			{
				debug.clear();
				debug.draw(space);
				debug.flush();
			}

			space.step(1 / 35);
		}

		private function shotOnFieldBorder(value: InteractionCallback): void
		{
			try { value.int1.castBody.userData.inst.createExplode(); }
			catch (e: *) { trace(e); }
		}

		private function shotOnTarget(value: InteractionCallback): void
		{
			try
			{
				value.int2.castBody.userData.inst.createExplode();
				value.int1.castBody.userData.inst.createExplode();
			}
			catch (e: *) { trace(e); }
		}

		public function get spaceInst (): Space { return space; }
		public function get gameFieldInst (): GameField { return gameField; }

		public function destroy(): void
		{
			gravity = null;

			space.bodies.foreach(function (body: Body): void
			{
				if (body.userData.hasOwnProperty("inst") && body.userData.inst != null)
				{
					body.userData.inst.destroy();
					body = null;
				}
			});

			space.listeners.foreach(function (listener: Listener): void
			{
				space.listeners.remove(listener);
				listener = null;
			});

			space.clear();
			space = null;

			gameField = null;

			if (isDebugMode)
			{
				(PanelsManager.getPanelByName(PanelNames.SCENE_GAME) as GameScene).sceneClip.removeChild(debug.display);
				debug.clear();
				debug = null;
			}
		}
	}
}