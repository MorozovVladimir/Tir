/**
 * Created with IntelliJ IDEA.
 * User: Morozov V.
 * Date: 05.02.15
 * Time: 21:07
 */
package com.test.tir.game.engine.nape.bodies
{
	import com.test.tir.core.TirMain;
	import com.test.tir.game.engine.nape.PhysicalSpace;

	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;

	public class FieldBody extends PhysicalBody
	{
		public function FieldBody(space: PhysicalSpace, material: Material = null)
		{
			super(space, material);
		}

		override protected function createBody(): void
		{
			var w: int = TirMain.APP_WIDTH;
			var h: int = TirMain.APP_HEIGHT;

			bodyInst = new Body(BodyType.STATIC);
			bodyInst.shapes.add(new Polygon(Polygon.rect(0, 0, -5, h), material));
			bodyInst.shapes.add(new Polygon(Polygon.rect(0, 50, w, -5), material));
			bodyInst.shapes.add(new Polygon(Polygon.rect(w, 0, 5, h), material));
			bodyInst.shapes.add(new Polygon(Polygon.rect(0, h, w, 5), material));
			bodyInst.cbTypes.add(PhysicalSpace.CB_FIELD_BORDER_TYPE);

			super.createBody();
		}
	}
}
