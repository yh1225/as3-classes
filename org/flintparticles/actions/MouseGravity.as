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
	import flash.display.DisplayObject;
	
	import org.flintparticles.emitters.Emitter;
	import org.flintparticles.particles.Particle;	

	/**
	 * The MouseGravity action applies a force on the particle to draw it towards
	 * the mouse. The force applied is inversely proportional to the square
	 * of the distance from the particle to the mouse.
	 */

	public class MouseGravity extends Action
	{
		private var _power:Number;
		private var _epsilonSq:Number;
		private var _gravityConst:Number = 10000; // scales the power to more useable levels
		
		/**
		 * The constructor creates a MouseGravity action for use by 
		 * an emitter. To add a MouseGravity to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param power The strength of the force - larger numbers produce a stringer force.
		 * @param epsilon The minimum distance for which gravity is calculated. Particles closer
		 * than this distance experience a gravity force as it they were this distance away.
		 * This stops the gravity effect blowing up as distances get small. For realistic gravity 
		 * effects you will want a small epsilon ( ~1 ), but for stable visual effects a larger
		 * epsilon (~100) is often better.
		 */
		public function MouseGravity( power:Number, epsilon:Number = 100 )
		{
			_power = power * _gravityConst;
			_epsilonSq = epsilon * epsilon;
		}
		
		/**
		 * The strength of the gravity force.
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
		 * The minimum distance for which the gravity force is calculated. 
		 * Particles closer than this distance experience the gravity as it they were 
		 * this distance away. This stops the gravity effect blowing up as distances get 
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
			if( ! ( emitter.renderer is DisplayObject ) )
			{
				return;
			}
			var dispObj:DisplayObject = DisplayObject( emitter.renderer );
			var x:Number = dispObj.mouseX - particle.x;
			var y:Number = dispObj.mouseY - particle.y;
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
