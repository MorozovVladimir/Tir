/**
 * Created with IntelliJ IDEA.
 * User: Morozov V.
 * Date: 05.02.15
 * Time: 21:07
 */
package com.test.tir.game.engine.nape.bodies
{
	import com.test.tir.game.engine.nape.PhysicalSpace;

	import nape.phys.Body;
	import nape.phys.Material;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.extensions.ParticleSystem;

	public class PhysicalBody
	{
		protected var space: PhysicalSpace;
		protected var material: Material;
		protected var bodyInst: Body;

		protected var assetName: String;
		protected var viewClip: DisplayObject;

		public function PhysicalBody(space: PhysicalSpace, material: Material)
		{
			this.space = space;
			this.material = material;

			if(space.gameFieldInst)
			{
				createBody();
				createView(assetName);
			}
		}

		public function get body(): Body { return bodyInst; }

		protected function createBody(): void
		{
			bodyInst.align();
			bodyInst.userData.inst = this;
			bodyInst.userData.graphicUpdate = graphicUpdate;
			bodyInst.space = space.spaceInst;
		}

		protected function createView (name: String, top: Boolean = true): void
		{
			if(!name || !space.gameFieldInst) return;

			viewClip = space.gameFieldInst.createImage(name, top);
			viewClip.pivotX = viewClip.width >> 1;
			viewClip.pivotY = viewClip.height >> 1;

			graphicUpdate();
		}

		protected function graphicUpdate(): void
		{
			viewClip.x = body.worldCOM.x;
			viewClip.y = body.worldCOM.y;
			viewClip.rotation = bodyInst.rotation;
		}

		public function destroy(): void
		{
			if(viewClip) space.gameFieldInst.deleteImage(viewClip);

			space = null;
			material = null;
			viewClip = null;

			if (bodyInst)
			{
				bodyInst.userData.inst = null;
				bodyInst.userData.graphicUpdate = null;
				bodyInst.space = null;
				bodyInst = null;
			}
		}
	}
}