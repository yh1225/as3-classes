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
	 * The TargetVelocity action adjusts the velocity of the particle towards the target velocity.
	 */
	public class TargetVelocity extends Action
	{
		private var _velX:Number;
		private var _velY:Number;
		private var _rate:Number;
		
		/**
		 * The constructor creates a TargetVelocity action for use by 
		 * an emitter. To add a TargetVelocity to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param velX The x coordinate of the target velocity, in pixels per second.
		 * @param velY The y coordinate of the target velocity, in pixels per second.
		 * @param rate Adjusts how quickly the particle reaches the target velocity.
		 * Larger numbers cause it to approach the target velocity more quickly.
		 */
		public function TargetVelocity( targetVelocityX:Number, targetVelocityY:Number, rate:Number = 0.1 )
		{
			_velX = targetVelocityX;
			_velY = targetVelocityY;
			_rate = rate;
		}
		
		/**
		 * The y coordinate of the target velocity, in pixels per second.
		 */
		public function get targetVelocityY():Number
		{
			return _velY;
		}
		public function set targetVelocityY( value:Number ):void
		{
			_velY = value;
		}
		
		/**
		 * The x coordinate of the target velocity, in pixels per second.s
		 */
		public function get targetVelocityX():Number
		{
			return _velX;
		}
		public function set targetVelocityX( value:Number ):void
		{
			_velX = value;
		}
		
		/**
		 * Adjusts how quickly the particle reaches the target angular velocity.
		 * Larger numbers cause it to approach the target angular velocity more quickly.
		 */
		public function get rate():Number
		{
			return _rate;
		}
		public function set rate( value:Number ):void
		{
			_rate = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			particle.velX += ( _velX - particle.velX ) * _rate * time;
			particle.velY += ( _velY - particle.velY ) * _rate * time;
		}
	}
}
