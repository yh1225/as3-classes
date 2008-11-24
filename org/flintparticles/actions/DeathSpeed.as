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
	 * The DeathSpeed action marks the particle as dead if it is travelling faster than 
	 * the specified speed. The behaviour can be switched to instead mark as dead 
	 * particles travelling slower than the specified speed.
	 */

	public class DeathSpeed extends Action
	{
		private var _limit:Number;
		private var _limitSq:Number;
		private var _isMinimum:Boolean;
		
		/**
		 * The constructor creates a DeathSpeed action for use by 
		 * an emitter. To add a DeathSpeed to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param speed The speed limit for the action in pixels per second.
		 * @param isMinimum If true, particles travelling slower than the speed limit
		 * are killed, otherwise particles travelling faster than the speed limit are
		 * killed.
		 */
		public function DeathSpeed( speed:Number, isMinimum:Boolean = false )
		{
			_limit = speed;
			_limitSq = speed * speed;
			_isMinimum = isMinimum;
		}
		
		/**
		 * The speed limit beyond which the particle dies
		 */
		public function get limit():Number
		{
			return _limit;
		}
		public function set limit( value:Number ):void
		{
			_limit = value;
			_limitSq = value * value;
		}
		
		/**
		 * Whether the speed is a minimum (true) or maximum (false) speed.
		 */
		public function get isMinimum():Boolean
		{
			return _isMinimum;
		}
		public function set isMinimum( value:Boolean ):void
		{
			_isMinimum = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var speedSq:Number = particle.velX * particle.velX + particle.velY * particle.velY;
			if ( ( _isMinimum && speedSq < _limitSq ) || ( !_isMinimum && speedSq > _limitSq ) )
			{
				if( speedSq > _limitSq )
				{
					particle.isDead = true;
				}
			}
		}
	}
}
