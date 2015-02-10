/**
 * Created with IntelliJ IDEA.
 * User: Morozov V.
 * Date: 09.02.15
 * Time: 19:03
 */
package com.test.tir.game.engine.effects
{
	import com.test.tir.common.managers.assets.ExternalAssetManager;
	import com.test.tir.common.params.AssetNames;

	import flash.geom.Point;

	import starling.core.Starling;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.extensions.ParticleSystem;
	import starling.textures.Texture;

	public class Effect extends Sprite
	{
		private var _particleSystem: PDParticleSystem;

		public function Effect(name: String)
		{
			create(name);
		}

		private function create (name: String): void
		{
			var config:XML = XML(ExternalAssetManager.getAssetByName(AssetNames.PARTICLE_DATA_PREF + name).data);
			var texture:Texture = Texture.fromBitmap(ExternalAssetManager.getAssetByName(AssetNames.PARTICLE_IMAGE_PREF + name).data);
			_particleSystem = new PDParticleSystem(config, texture);
			_particleSystem.start();
			addChild(_particleSystem);

			Starling.juggler.add(_particleSystem);

			addEventListener(Event.COMPLETE, completeHandler);
		}

		public function get particleSystem (): ParticleSystem { return _particleSystem; }

		private function completeHandler(event: Event): void
		{
			 destroy();
		}

		public function destroy(): void
		{
			if (particleSystem)
			{
				particleSystem.removeEventListener(Event.COMPLETE, completeHandler);
				particleSystem.stop();
				particleSystem.removeFromParent(true);

				Starling.juggler.remove(particleSystem);
			}

			removeFromParent(true);
		}
	}
}
