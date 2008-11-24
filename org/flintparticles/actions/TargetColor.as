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
	 * The TargetColor action adjusts the color of the particle towards the target color.
	 */
	public class TargetColor extends Action
	{
		private var _red:uint;
		private var _green:uint;
		private var _blue:uint;
		private var _alpha:uint;
		private var _rate:Number;
		
		/**
		 * The constructor creates a TargetColor action for use by 
		 * an emitter. To add a TargetColor to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param targetColor The target color. This is a 32 bit color of the form 0xAARRGGBB.
		 * @param rate Adjusts how quickly the particle reaches the target color.
		 * Larger numbers cause it to approach the target color more quickly.
		 */
		public function TargetColor( targetColor:uint, rate:Number = 0.1 )
		{
			_red = ( targetColor >>> 16 ) & 255;
			_green = ( targetColor >>> 8 ) & 255;
			_blue = ( targetColor ) & 255;
			_alpha = ( targetColor >>> 24 ) & 255;
			_rate = rate;
		}
		
		/**
		 * The target color. This is a 32 bit color of the form 0xAARRGGBB.
		 */
		public function get targetColor():Number
		{
			return ( _alpha << 24 ) | ( _red << 16 ) | ( _green << 8 ) | _blue;
		}
		public function set targetColor( value:Number ):void
		{
			_red = ( value >>> 16 ) & 255;
			_green = ( value >>> 8 ) & 255;
			_blue = ( value ) & 255;
			_alpha = ( value >>> 24 ) & 255;
		}
		
		/**
		 * Adjusts how quickly the particle reaches the target color.
		 * Larger numbers cause it to approach the target color more quickly.
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
			if( ! particle.dictionary[this] )
			{
				particle.dictionary[this] = new ColorFloat( particle.color );
			}
			var dicObj:ColorFloat = ColorFloat( particle.dictionary[this] );
			
			var inv:Number = _rate * time;
			var ratio:Number = 1 - inv;
			
			dicObj.red = dicObj.red * ratio + _red * inv;
			dicObj.green = dicObj.green * ratio + _green * inv;
			dicObj.blue = dicObj.blue * ratio + _blue * inv;
			dicObj.alpha = dicObj.alpha * ratio + _alpha * inv;
			particle.color = dicObj.getColor();
		}
	}
}

class ColorFloat
{
	public var red:Number;
	public var green:Number;
	public var blue:Number;
	public var alpha:Number;
	
	public function ColorFloat( color:uint )
	{
		red = ( color >>> 16 ) & 255;
		green = ( color >>> 8 ) & 255;
		blue = ( color ) & 255;
		alpha = ( color >>> 24 ) & 255;
	}
	
	public function getColor():uint
	{
		return ( Math.round( alpha ) << 24 ) | ( Math.round( red ) << 16 ) | ( Math.round( green ) << 8 ) | Math.round( blue );
	}
}
