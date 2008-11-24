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
	 * The TurnTowardsPoint action causes the particle to constantly adjust its direction
	 * so that it travels towards a particular point.
	 */

	public class TurnTowardsPoint extends Action
	{
		private var _x:Number;
		private var _y:Number;
		private var _power:Number;
		
		/**
		 * The constructor creates a TurnTowardsPoint action for use by 
		 * an emitter. To add a TurnTowardsPoint to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param power The strength of the turn action. Higher values produce a sharper turn.
		 * @param x The x coordinate of the point towards which the particle turns.
		 * @param y The y coordinate of the point towards which the particle turns.
		 */
		public function TurnTowardsPoint( x:Number, y:Number, power:Number )
		{
			_power = power;
			_x = x;
			_y = y;
		}
		
		/**
		 * The strength of theturn action. Higher values produce a sharper turn.
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
		 * The x coordinate of the point that the particle turns towards.
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
		 * The y coordinate of the point that the particle turns towards.
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
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var turnLeft:Boolean = ( ( particle.y - _y ) * particle.velX + ( _x - particle.x ) * particle.velY > 0 );
			var newAngle:Number;
			if ( turnLeft )
			{
				newAngle = Math.atan2( particle.velY, particle.velX ) - _power * time;
				
			}
			else
			{
				newAngle = Math.atan2( particle.velY, particle.velX ) + _power * time;
			}
			var len:Number = Math.sqrt( particle.velX * particle.velX + particle.velY * particle.velY );
			particle.velX = len * Math.cos( newAngle );
			particle.velY = len * Math.sin( newAngle );
		}
	}
}
