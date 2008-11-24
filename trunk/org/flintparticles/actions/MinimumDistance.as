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
	import org.flintparticles.particles.Particle;
	import org.flintparticles.emitters.Emitter;	

	/**
	 * The MinimumDistance action applies an acceleration to the particle to maintain a minimum
	 * distance between it and its neighbours.
	 */

	public class MinimumDistance extends Action
	{
		private var _min:Number;
		private var _acc:Number;
		private var _minSq:Number;
		
		/**
		 * The constructor creates a ApproachNeighbours action for use by 
		 * an emitter. To add a ApproachNeighbours to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param minimum The minimum distance, in pixels, that this action maintains between 
		 * particles.
		 * @param acceleration The acceleration force applied to avoid the other particles.
		 */
		public function MinimumDistance( minimum:Number, acceleration:Number )
		{
			_min = minimum;
			_minSq = minimum * minimum;
			_acc = acceleration;
		}
		
		/**
		 * The minimum distance, in pixels, that this action maintains between 
		 * particles.
		 */
		public function get minimum():Number
		{
			return _min;
		}
		public function set minimum( value:Number ):void
		{
			_min = value;
			_minSq = value * value;
		}
		
		/**
		 * The acceleration force applied to avoid the other particles.
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
			var distanceInv:Number;
			var distanceSq:Number;
			var dx:Number;
			var dy:Number;
			var moveX:Number = 0;
			var moveY:Number = 0;
			var factor:Number;
			for( i = particle.spaceSortX - 1; i >= 0; --i )
			{
				other = particles[sortedX[i]];
				if( ( dx = particle.x - other.x ) > _min ) break;
				dy = particle.y - other.y;
				if( dy > _min || dy < -_min ) continue;
				distanceSq = dy * dy + dx * dx;
				if( distanceSq <= _minSq && distanceSq > 0 )
				{
					distanceInv = 1 / Math.sqrt( distanceSq );
					moveX += dx * distanceInv;
					moveY += dy * distanceInv;
				} 
			}
			for( i = particle.spaceSortX + 1; i < len; ++i )
			{
				other = particles[sortedX[i]];
				if( ( dx = other.x - particle.x ) > _min ) break;
				dy = particle.y - other.y;
				if( dy > _min || dy < -_min ) continue;
				distanceSq = dy * dy + dx * dx;
				if( distanceSq <= _minSq && distanceSq > 0 )
				{
					distanceInv = 1 / Math.sqrt( distanceSq );
					moveX += -dx * distanceInv;
					moveY += dy * distanceInv;
				} 
			}
			if( moveX != 0 || moveY != 0 )
			{
				factor = time * _acc / Math.sqrt( moveX * moveX + moveY * moveY );
				particle.velX += factor * moveX;
				particle.velY += factor * moveY;
			}
		}
	}
}
