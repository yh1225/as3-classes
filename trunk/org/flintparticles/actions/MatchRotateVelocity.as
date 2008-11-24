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

	/**
	 * The MatchRotateVelocity action applies an angular acceleration to the particle to match
	 * its angular velocity to that of its nearest neighbours.
	 */

	public class MatchRotateVelocity extends Action
	{
		private var _min:Number;
		private var _acc:Number;
		
		/**
		 * The constructor creates a MatchRotateVelocity action for use by 
		 * an emitter. To add a MatchRotateVelocity to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param maxDistance The maximum distance, in pixels, over which this action operates.
		 * The particle will match its angular velocity other particles that are this close or 
		 * closer to it.
		 * @param acceleration The angular acceleration applied to adjust velocity to match that
		 * of the other particles.
		 */
		public function MatchRotateVelocity( maxDistance:Number, acceleration:Number )
		{
			_min = maxDistance;
			_acc = acceleration;
		}
		
		/**
		 * The maximum distance, in pixels, over which this action operates.
		 * The particle will match its angular velocity other particles that are this 
		 * close or closer to it.
		 */
		public function get maxDistance():Number
		{
			return _min;
		}
		public function set maxDistance( value:Number ):void
		{
			_min = value;
		}
		
		/**
		 * The angular acceleration applied to adjust velocity to match that
		 * of the other particles.
		 */
		public function get acceleration():Number
		{
			return _acc;
		}
		public function set acceleration( value:Number ):void
		{
			_acc = value;
		}

		/**
		 * @inheritDoc
		 * 
		 * <p>Returns a value of 10, so that the MutualGravity action executes before other actions.</p>
		 */
		override public function getDefaultPriority():Number
		{
			return 10;
		}

		/**
		 * @inheritDoc
		 */
		override public function addedToEmitter( emitter:Emitter ) : void
		{
			emitter.spaceSort = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var particles:Array = emitter.particles;
			var sortedX:Array = emitter.spaceSortedX;
			var other:Particle;
			var i:int;
			var len:int = particles.length;
			var dx:Number;
			var dy:Number;
			var vel:Number = 0;
			var count:int = 0;
			var factor:Number;
			for( i = particle.spaceSortX - 1; i >= 0; --i )
			{
				other = particles[sortedX[i]];
				if( ( dx = particle.x - other.x ) > _min ) break;
				dy = other.y - particle.y;
				if( dy > _min || dy < -_min ) continue;
				vel += other.angVelocity;
				++count;
			}
			for( i = particle.spaceSortX + 1; i < len; ++i )
			{
				other = particles[sortedX[i]];
				if( ( dx = other.x - particle.x ) > _min ) break;
				dy = other.y - particle.y;
				if( dy > _min || dy < -_min ) continue;
				vel += other.angVelocity;
				++count;
			}
			if( count != 0 )
			{
				vel = vel / count - particle.angVelocity;
				if( vel != 0 )
				{
					var velSign:Number = 1;
					if( vel < 0 )
					{
						velSign = -1;
						vel = -vel;
					}
					factor = time * _acc;
					if( factor > vel ) factor = vel;
					particle.angVelocity += factor * velSign;
				}
			}
		}
	}
}
