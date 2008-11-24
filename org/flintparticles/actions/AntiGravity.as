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
	 * The AntiGravity action applies a force on the particle to push it away from
	 * a single point - the center of the effect. The force applied is inversely 
	 * proportional to the square of the distance from the particle to the point.
	 */

	public class AntiGravity extends Action
	{
		private var _x:Number;
		private var _y:Number;
		private var _power:Number;
		private var _gravityConst:Number = 10000; // this just scales the power so we don't have to use very large numbers
		private var _epsilonSq:Number;
		
		/**
		 * The constructor creates an AntiGravity action for use by 
		 * an emitter. To add an AntiGravity to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param power The strength of the force - larger numbers produce a stronger force.
		 * @param x The x coordinate of the point away from which the force pushes the particles.
		 * @param y The y coordinate of the point away from which the force pushes the particles.
		 * @param epsilon The minimum distance for which the anti-gravity force is calculated. 
		 * Particles closer than this distance experience the anti-gravity as it they were 
		 * this distance away. This stops the anti-gravity effect blowing up as distances get 
		 * small.
		 */
		public function AntiGravity( power:Number, x:Number, y:Number, epsilon:Number = 1 )
		{
			_power = power * _gravityConst;
			_x = x;
			_y = y;
			_epsilonSq = epsilon * epsilon;
		}
		
		/**
		 * The strength of the anti-gravity force.
		 */
		public function get power():Number
		{
			return _power / _gravityConst;
		}
		public function set power( value:Number ):void
		{
			_power = value * _gravityConst;
		}
		
		/**
		 * The x coordinate of the center of the anti-gravity force.
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
		 * The y coordinate of the center of the anti-gravity force.
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
		 * The minimum distance for which the anti-gravity force is calculated. 
		 * Particles closer than this distance experience the anti-gravity as it they were 
		 * this distance away. This stops the anti-gravity effect blowing up as distances get 
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
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var x:Number = particle.x - _x;
			var y:Number = particle.y - _y;
			var dSq:Number = x * x + y * y;
			if( dSq == 0 )
			{
				return;
			}
			var d:Number = Math.sqrt( dSq );
			if( dSq < _epsilonSq ) dSq = _epsilonSq;
			var factor:Number = ( _power * time ) / ( dSq * d );
			particle.velX += x * factor;
			particle.velY += y * factor;
		}
	}
}
