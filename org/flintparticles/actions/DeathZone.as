/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord (Big Room)
 * Copyright (c) Big Room Ventures Ltd. 2008
 * http://flintparticles.org
 * 
 * 
 * Licence Agreement
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package org.flintparticles.actions 
{
	import org.flintparticles.emitters.Emitter;
	import org.flintparticles.particles.Particle;
	import org.flintparticles.zones.Zone;	

	/**
	 * The DeathZone action marks the particle as dead if it is inside
	 * a zone.
	 */

	public class DeathZone extends Action
	{
		private var _zone:Zone;
		private var _invertZone:Boolean;
		
		/**
		 * The constructor creates a DeathZone action for use by 
		 * an emitter. To add a DeathZone to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * @see org.flintparticles.zones
		 * 
		 * @param zone The zone to use. Any item from the org.flintparticles.zones
		 * package can be used.
		 * @param zoneIsSafe If true, the zone is treated as the safe area
		 * and being outside the zone results in the particle dying.
		 */
		public function DeathZone( zone:Zone, zoneIsSafe:Boolean = false )
		{
			_zone = zone;
			_invertZone = zoneIsSafe;
		}
		
		/**
		 * The zone.
		 */
		public function get zone():Zone
		{
			return _zone;
		}
		public function set zone( value:Zone ):void
		{
			_zone = value;
		}
		
		/**
		 * If true, the zone is treated as the safe area and being ouside the zone
		 * results in the particle dying. Otherwise, being inside the zone causes the
		 * particle to die.
		 */
		public function get zoneIsSafe():Boolean
		{
			return _invertZone;
		}
		public function set zoneIsSafe( value:Boolean ):void
		{
			_invertZone = value;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * <p>Returns a value of -20, so that the DeathZone executes after all movement has occured.</p>
		 */
		override public function getDefaultPriority():Number
		{
			return -20;
		}

		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var inside:Boolean = _zone.contains( particle.x, particle.y );
			if ( _invertZone )
			{
				inside = !inside;
			}
			if ( inside )
			{
				particle.isDead = true;
			}
		}
	}
}
