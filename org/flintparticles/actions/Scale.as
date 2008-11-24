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
	 * The Scale action adjusts the size of the particle as it ages. This action
	 * should be used in conjunction with the Age action.
	 */

	public class Scale extends Action
	{
		private var _diffScale:Number;
		private var _endScale:Number;
		
		/**
		 * The constructor creates a Scale action for use by 
		 * an emitter. To add a Scale to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param startScale The scale factor for the particle at the start of it's life.
		 * 1 is normal size.
		 * @param endScale The scale factor for the particle at the end of it's life.
		 * 1 is normal size.
		 */
		public function Scale( startScale:Number = 1, endScale:Number = 1 )
		{
			_diffScale = startScale - endScale;
			_endScale = endScale;
		}
		
		/**
		 * The alpha value for the particle at the start of its life.
		 * Should be between 0 and 1.
		 */
		public function get startScale():Number
		{
			return _endScale + _diffScale;
		}
		public function set startScale( value:Number ):void
		{
			_diffScale = value - _endScale;
		}
		
		/**
		 * The alpha value for the particle at the end of its life.
		 * Should be between 0 and 1.
		 */
		public function get endScale():Number
		{
			return _endScale;
		}
		public function set endScale( value:Number ):void
		{
			_diffScale = _endScale + _diffScale - value;
			_endScale = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			particle.scale = _endScale + _diffScale * particle.energy;
		}
	}
}
