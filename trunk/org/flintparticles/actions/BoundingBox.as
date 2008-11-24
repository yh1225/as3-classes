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
	import flash.geom.Rectangle;
	
	import org.flintparticles.emitters.Emitter;
	import org.flintparticles.particles.Particle;	

	/**
	 * The BoundingBox action confines each particle to a box. The 
	 * particle bounces back off the side of the box when it reaches 
	 * the edge. The bounce treats the particle as a circular body
	 * and displays no loss of energy in the collision.
	 */

	public class BoundingBox extends Action
	{
		private var _left : Number;
		private var _top : Number;
		private var _right : Number;
		private var _bottom : Number;

		/**
		 * The constructor creates a BoundingBox action for use by 
		 * an emitter. To add a BoundingBox to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param left The left coordinate of the box. The coordinates are in the
		 * coordinate space of the object containing the emitter.
		 * @param top The top coordinate of the box. The coordinates are in the
		 * coordinate space of the object containing the emitter.
		 * @param right The right coordinate of the box. The coordinates are in the
		 * coordinate space of the object containing the emitter.
		 * @param bottom The bottom coordinate of the box. The coordinates are in the
		 * coordinate space of the object containing the emitter.
		 */
		public function BoundingBox( left:Number, top:Number, right:Number, bottom:Number )
		{
			_left = left;
			_top = top;
			_right = right;
			_bottom = bottom;
		}
		
		/**
		 * The bounding box.
		 */
		public function get box():Rectangle
		{
			return new Rectangle( _left, _top, _right - _left, _bottom - _top );
		}
		public function set box( value:Rectangle ):void
		{
			_left = value.left;
			_right = value.right;
			_top = value.top;
			_bottom = value.bottom;
		}

		/**
		 * The left coordinate of the bounding box.
		 */
		public function get left():Number
		{
			return _left;
		}
		public function set left( value:Number ):void
		{
			_left = value;
		}

		/**
		 * The top coordinate of the bounding box.
		 */
		public function get top():Number
		{
			return _top;
		}
		public function set top( value:Number ):void
		{
			_top = value;
		}

		/**
		 * The left coordinate of the bounding box.
		 */
		public function get right():Number
		{
			return _right;
		}
		public function set right( value:Number ):void
		{
			_right = value;
		}

		/**
		 * The left coordinate of the bounding box.
		 */
		public function get bottom():Number
		{
			return _bottom;
		}
		public function set bottom( value:Number ):void
		{
			_bottom = value;
		}

		/**
		 * @inheritDoc
		 * 
		 * <p>Returns a value of -20, so that the BoundingBox executes after all movement has occured.</p>
		 */
		override public function getDefaultPriority():Number
		{
			return -20;
		}

		/**
		 * @inheritDoc
		 */
		override public function update( emitter : Emitter, particle : Particle, time : Number ) : void
		{
			var halfWidth:Number;
			var halfHeight:Number;
			if( particle.image )
			{
				halfWidth = particle.scale * particle.image.width * 0.5;
				halfHeight = particle.scale * particle.image.height * 0.5;
			}
			else
			{
				halfWidth = halfHeight = 0;
			}
			var position:Number;
			if ( particle.velX > 0 && ( position = particle.x + halfWidth ) >= _right )
			{
				particle.velX = -particle.velX;
				particle.x += 2 * ( _right - position );
			}
			else if ( particle.velX < 0 && ( position = particle.x - halfWidth ) <= _left )
			{
				particle.velX = -particle.velX;
				particle.x += 2 * ( _left - position );
			}
			if ( particle.velY > 0 && ( position = particle.y + halfHeight ) >= _bottom )
			{
				particle.velY = -particle.velY;
				particle.y += 2 * ( _bottom - position );
			}
			else if ( particle.velY < 0 && ( position = particle.y - halfHeight ) <= _top )
			{
				particle.velY = -particle.velY;
				particle.y += 2 * ( _top - position );
			}
		}
	}
}
