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

package org.flintparticles.activities
{
	import org.flintparticles.emitters.Emitter;

	/**
	 * The MoveEmitter activity moves the emitter at a constant velocity.
	 */
	public class MoveEmitter extends Activity
	{
		private var _velX:Number;
		private var _velY:Number;
		
		/**
		 * The constructor creates a MoveEmitter activity for use by 
		 * an emitter. To add a MoveEmitter to an emitter, use the
		 * emitter's addActvity method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addActivity()
		 * 
		 * @param x The x coordinate of the velocity to move the emitter, 
		 * in pixels per second.
		 * @param y The y coordinate of the velocity to move the emitter, 
		 * in pixels per second.
		 */
		public function MoveEmitter( x:Number, y:Number )
		{
			_velX = x;
			_velY = y;
		}
		
		/**
		 * The x coordinate of the velocity to move the emitter, 
		 * in pixels per second
		 */
		public function get x():Number
		{
			return _velX;
		}
		public function set x( value:Number ):void
		{
			_velX = value;
		}
		
		/**
		 * The y coordinate of the velocity to move the emitter, 
		 * in pixels per second
		 */
		public function get y():Number
		{
			return _velY;
		}
		public function set y( value:Number ):void
		{
			_velY = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter : Emitter, time : Number ) : void
		{
			emitter.x += _velX * time;
			emitter.y += _velY * time;
		}
	}
}