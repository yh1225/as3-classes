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
	 * The Fade action adjusts the particle's alpha as it ages. This action
	 * should be used in conjunction with the Age action.
	 */

	public class Fade extends Action
	{
		private var _diffAlpha:Number;
		private var _endAlpha:Number;
		
		/**
		 * The constructor creates a Fade action for use by 
		 * an emitter. To add a Fade to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param startAlpha The alpha value for the particle at the
		 * start of its life. Should be between 0 and 1.
		 * @param endAlpha The alpha value of the particle at the end of its
		 * life. Should be between 0 and 1.
		 */
		public function Fade( startAlpha:Number = 1, endAlpha:Number = 0 )
		{
			_diffAlpha = startAlpha - endAlpha;
			_endAlpha = endAlpha;
		}
		
		/**
		 * The alpha value for the particle at the start of its life.
		 * Should be between 0 and 1.
		 */
		public function get startAlpha():Number
		{
			return _endAlpha + _diffAlpha;
		}
		public function set startAlpha( value:Number ):void
		{
			_diffAlpha = value - _endAlpha;
		}
		
		/**
		 * The alpha value for the particle at the end of its life.
		 * Should be between 0 and 1.
		 */
		public function get endAlpha():Number
		{
			return _endAlpha;
		}
		public function set endAlpha( value:Number ):void
		{
			_diffAlpha = _endAlpha + _diffAlpha - value;
			_endAlpha = value;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * <p>Returns a value of -5, so that the Fade executes after color changes.</p>
		 */
		override public function getDefaultPriority():Number
		{
			return -5;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var alpha:Number = _endAlpha + _diffAlpha * particle.energy;
			particle.color = ( particle.color & 0xFFFFFF ) | ( Math.round( alpha * 255 ) << 24 );
		}
	}
}
