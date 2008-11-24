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
	 * The TweenPosition action adjusts the particle's position between two
	 * locations as it ages. This action
	 * should be used in conjunction with the Age action.
	 */

	public class TweenPosition extends Action
	{
		private var _diffX:Number;
		private var _endX:Number;
		private var _diffY:Number;
		private var _endY:Number;
		
		/**
		 * The constructor creates a TweenPosition action for use by 
		 * an emitter. To add a TweenPosition to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param startX The x value for the particle at the
		 * start of its life.
		 * @param startY The y value for the particle at the
		 * start of its life.
		 * @param endX The x value of the particle at the end of its
		 * life.
		 * @param endY The y value of the particle at the end of its
		 * life.
		 */
		public function TweenPosition( startX:Number, startY:Number, endX:Number, endY:Number )
		{
			_diffX = startX - endX;
			_endX = endX;
			_diffY = startY - endY;
			_endY = endY;
		}
		
		/**
		 * The x position for the particle at the start of its life.
		 */
		public function get startX():Number
		{
			return _endX + _diffX;
		}
		public function set startX( value:Number ):void
		{
			_diffX = value - _endX;
		}
		
		/**
		 * The X value for the particle at the end of its life.
		 */
		public function get endX():Number
		{
			return _endX;
		}
		public function set endX( value:Number ):void
		{
			_diffX = _endX + _diffX - value;
			_endX = value;
		}
		
		/**
		 * The y position for the particle at the start of its life.
		 */
		public function get startY():Number
		{
			return _endY + _diffY;
		}
		public function set startY( value:Number ):void
		{
			_diffY = value - _endY;
		}
		
		/**
		 * The y value for the particle at the end of its life.
		 */
		public function get endY():Number
		{
			return _endY;
		}
		public function set endY( value:Number ):void
		{
			_diffY = _endY + _diffY - value;
			_endY = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			particle.x = _endX + _diffX * particle.energy;
			particle.y = _endY + _diffY * particle.energy;
		}
	}
}
