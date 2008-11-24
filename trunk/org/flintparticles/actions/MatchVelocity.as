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
	 * The MatchVelocity action applies an acceleration to the particle to match
	 * its velocity to that of its nearest neighbours.
	 */

	public class MatchVelocity extends Action
	{
		private var _max:Number;
		private var _acc:Number;
		private var _maxSq:Number;
		
		/**
		 * The constructor creates a MatchVelocity action for use by 
		 * an emitter. To add a MatchVelocity to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param maxDistance The maximum distance, in pixels, over which this action operates.
		 * The particle will match its velocity other particles that are this close or closer to it.
		 * @param acceleration The acceleration force applied to adjust velocity to match that
		 * of the other particles.
		 */
		public function MatchVelocity( maxDistance:Number, acceleration:Number )
		{
			_max = maxDistance;
			_acc = acceleration;
			_maxSq = maxDistance * maxDistance;
		}
		
		/**
		 * The maximum distance, in pixels, over which this action operates.
		 * The particle will match its velocity other particles that are this close or closer to it.
		 */
		public function get maxDistance():Number
		{
			return _max;
		}
		public function set maxDistance( value:Number ):void
		{
			_max = value;
		}
		
		/**
		 * The acceleration force applied to adjust velocity to match that
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
			var distanceSq:Number;
			var i:int;
			var len:int = particles.length;
			var dx:Number;
			var dy:Number;
			var velX:Number = 0;
			var velY:Number = 0;
			var count:int = 0;
			var factor:Number;
			for( i = particle.spaceSortX - 1; i >= 0; --i )
			{
				other = particles[sortedX[i]];
				if( ( dx = particle.x - other.x ) > _max ) break;
				dy = other.y - particle.y;
				if( dy > _max || dy < -_max ) continue;
				distanceSq = dy * dy + dx * dx;
				if( distanceSq <= _maxSq && distanceSq > 0 )
				{
					velX += other.velX;
					velY += other.velY;
					++count;
				}
			}
			for( i = particle.spaceSortX + 1; i < len; ++i )
			{
				other = particles[sortedX[i]];
				if( ( dx = other.x - particle.x ) > _max ) break;
				dy = other.y - particle.y;
				if( dy > _max || dy < -_max ) continue;
				distanceSq = dy * dy + dx * dx;
				if( distanceSq <= _maxSq && distanceSq > 0 )
				{
					velX += other.velX;
					velY += other.velY;
					++count;
				}
			}
			if( count != 0 )
			{
				velX = velX / count - particle.velX;
				velY = velY / count - particle.velY;
				if( velX != 0 || velY != 0 )
				{
					factor = time * _acc / Math.sqrt( velX * velX + velY * velY );
					if( factor > 1 ) factor = 1;
					particle.velX += factor * velX;
					particle.velY += factor * velY;
				}
			}
		}
	}
}
