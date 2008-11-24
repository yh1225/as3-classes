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
	import org.flintparticles.utils.interpolateColors;	

	/**
	 * The ColorChange action alters the color of the particle as it ages.
	 * It should be used in conjunction with the Age action.
	 */

	public class ColorChange extends Action
	{
		private var _startColor:uint;
		private var _endColor:uint;
		
		/**
		 * The constructor creates a ColorChange action for use by 
		 * an emitter. To add a ColorChange to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param startColor The 32bit (ARGB) color of the particle at the beginning of its life.
		 * @param endColor The 32bit (ARGB) color of the particle at the end of its life.
		 */
		public function ColorChange( startColor:uint, endColor:uint )
		{
			_startColor = startColor;
			_endColor = endColor;
		}
		
		/**
		 * The color of the particle at the beginning of its life.
		 */
		public function get startColor():uint
		{
			return _startColor;
		}
		public function set startColor( value:uint ):void
		{
			_startColor = value;
		}
		
		/**
		 * The color of the particle at the end of its life.
		 */
		public function get endColor():uint
		{
			return _endColor;
		}
		public function set endColor( value:uint ):void
		{
			_endColor = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			particle.color = interpolateColors( _startColor, _endColor, particle.energy );
		}
	}
}
