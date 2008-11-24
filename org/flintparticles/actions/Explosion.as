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
	import org.flintparticles.activities.FrameUpdatable;
	import org.flintparticles.activities.UpdateOnFrame;
	import org.flintparticles.emitters.Emitter;
	import org.flintparticles.particles.Particle;	

	/**
	 * The Explosion action applies a force on the particle to push it away from
	 * a single point - the center of the explosion. The force occurs instantaneously at the central point 
	 * of the explosion and then ripples out in a shock wave.
	 */

	public class Explosion extends Action implements FrameUpdatable
	{
		private var _updateActivity:UpdateOnFrame;
		private var _x:Number;
		private var _y:Number;
		private var _power:Number;
		private var _depth:Number;
		private var _invDepth:Number;
		private var _epsilonSq:Number;
		private var _oldRadius:Number = 0;
		private var _radius:Number = 0;
		private var _radiusChange:Number = 0;
		private var _expansionRate:Number = 500;
		private var _lowerBoundarySq:Number;
		private var _upperBoundarySq:Number;
		
		/**
		 * The constructor creates an Explosion action for use by 
		 * an emitter. To add an Explosion to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param power The strength of the explosion - larger numbers produce a stronger force.
		 * @param x The x coordinate of the center of the explosion.
		 * @param y The y coordinate of the center of the explosion.
		 * @param expansionRate The rate at which the shockwave moves out from the explosion, in pixels per second.
		 * @param depth The depth (front-edge to back-edge) of the shock wave.
		 * @param epsilon The minimum distance for which the explosion force is calculated. 
		 * Particles closer than this distance experience the explosion as it they were 
		 * this distance away. This stops the explosion effect blowing up as distances get 
		 * small.
		 * @param maxRadius When the shockwave is this far from the center of the explosion, the explosion stops
		 * and removes itself from the emitter.
		 */
		public function Explosion( power:Number, x:Number, y:Number, expansionRate:Number = 300, depth:Number = 10, epsilon:Number = 1 )
		{
			_power = power;
			_x = x;
			_y = y;
			_expansionRate = expansionRate;
			_depth = depth * 0.5;
			_invDepth = 1 / _depth;
			_epsilonSq = epsilon * epsilon;
		}
		
		/**
		 * The strength of the explosion - larger numbers produce a stronger force.
		 */
		public function get power():Number
		{
			return _power;
		}
		public function set power( value:Number ):void
		{
			_power = value;
		}
		
		/**
		 * The strength of the explosion - larger numbers produce a stronger force.
		 */
		public function get expansionRate():Number
		{
			return _expansionRate;
		}
		public function set expansionRate( value:Number ):void
		{
			_expansionRate = value;
		}
		
		/**
		 * The strength of the explosion - larger numbers produce a stronger force.
		 */
		public function get depth():Number
		{
			return _depth * 2;
		}
		public function set depth( value:Number ):void
		{
			_depth = value * 0.5;
			_invDepth = 1 / _depth;
		}
		
		/**
		 * The x coordinate of the center of the explosion.
		 */
		public function get x():Number
		{
			return _x;
		}
		public function set x( value:Number ):void
		{
			_x = value;
		}
		
		/**
		 * The y coordinate of the center of the explosion.
		 */
		public function get y():Number
		{
			return _y;
		}
		public function set y( value:Number ):void
		{
			_y = value;
		}
		
		/**
		 * The minimum distance for which the explosion force is calculated. 
		 * Particles closer than this distance experience the explosion as it they were 
		 * this distance away. This stops the explosion effect blowing up as distances get 
		 * small.
		 */
		public function get epsilon():Number
		{
			return Math.sqrt( _epsilonSq );
		}
		public function set epsilon( value:Number ):void
		{
			_epsilonSq = value * value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addedToEmitter( emitter:Emitter ):void
		{
			_updateActivity = new UpdateOnFrame( this );
			emitter.addActivity( _updateActivity );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removedFromEmitter( emitter:Emitter ):void
		{
			if( _updateActivity )
			{
				emitter.removeActivity( _updateActivity );
			}
		}
		
		/**
		 * Called every frame before the particles are updated. This method is called via the FrameUpdateable
		 * interface which is called by the emitter by using an UpdateOnFrame activity.
		 */
		public function frameUpdate( emitter:Emitter, time:Number ):void
		{
			_oldRadius = _radius;
			_radiusChange = _expansionRate * time;
			_radius += _radiusChange;
			var lowerBoundary:Number = _oldRadius - _depth;
			if( lowerBoundary < 0 )
			{
				_lowerBoundarySq = 0;
			}
			else
			{
				_lowerBoundarySq = lowerBoundary * lowerBoundary;
			}
			var upperBoundary:Number = _radius + _depth;
			_upperBoundarySq = upperBoundary * upperBoundary;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var x:Number = particle.x - _x;
			var y:Number = particle.y - _y;
			var dSq:Number = x * x + y * y;
			if( dSq == 0 )
			{
				return;
			}
			if( dSq < _lowerBoundarySq || dSq > _upperBoundarySq )
			{
				return;
			}
			
			var d:Number = Math.sqrt( dSq );
			var offset:Number = d < _radius ? _depth - _radius + d : _depth - d + _radius;
			var oldOffset:Number = d < _oldRadius ? _depth - _oldRadius + d : _depth - d + _oldRadius;
			offset *= _invDepth;
			oldOffset *= _invDepth;
			if( offset < 0 )
			{
				time = time * ( _radiusChange + offset ) / _radiusChange;
				offset = 0;
			}
			if( oldOffset < 0 )
			{
				time = time * ( _radiusChange + oldOffset ) / _radiusChange;
				oldOffset = 0;
			}
			
			var factor:Number;
			if( d < _oldRadius || d > _radius )
			{
				factor = time * power * ( offset + oldOffset ) / ( _radius * 2 * d );
			}
			else
			{
				var ratio:Number = ( 1 - oldOffset ) / _radiusChange;
				var f1:Number = ratio * time * power * ( oldOffset + 1 ) / ( _radius * 2 * d );
				var f2:Number = ( 1 - ratio ) * time * power * ( offset + 1 ) / ( _radius * 2 * d );
				factor = f1 + f2;
			}
			particle.velX += x * factor;
			particle.velY += y * factor;
		}
	}
}
