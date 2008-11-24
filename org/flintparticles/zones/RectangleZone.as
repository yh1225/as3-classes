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

package org.flintparticles.zones 
{
	import flash.geom.Point;

	/**
	 * The RectangleZone zone defines a rectangular shaped zone.
	 */

	public class RectangleZone implements Zone 
	{
		private var _left : Number;
		private var _top : Number;
		private var _right : Number;
		private var _bottom : Number;
		private var _width : Number;
		private var _height : Number;
		
		/**
		 * The constructor creates a RectangleZone zone.
		 * 
		 * @param left The left coordinate of the rectangle defining the region of the zone.
		 * @param top The top coordinate of the rectangle defining the region of the zone.
		 * @param right The right coordinate of the rectangle defining the region of the zone.
		 * @param bottom The bottom coordinate of the rectangle defining the region of the zone.
		 */
		public function RectangleZone( left:Number, top:Number, right:Number, bottom:Number )
		{
			_left = left;
			_top = top;
			_right = right;
			_bottom = bottom;
			_width = right - left;
			_height = bottom - top;
		}
		
		/**
		 * The left coordinate of the rectangle defining the region of the zone.
		 */
		public function get left() : Number
		{
			return _left;
		}

		public function set left( value : Number ) : void
		{
			_left = value;
			_width = right - left;
		}

		/**
		 * The right coordinate of the rectangle defining the region of the zone.
		 */
		public function get right() : Number
		{
			return _right;
		}

		public function set right( value : Number ) : void
		{
			_right = value;
			_width = right - left;
		}

		/**
		 * The top coordinate of the rectangle defining the region of the zone.
		 */
		public function get top() : Number
		{
			return _top;
		}

		public function set top( value : Number ) : void
		{
			_top = value;
			_height = bottom - top;
		}

		/**
		 * The bottom coordinate of the rectangle defining the region of the zone.
		 */
		public function get bottom() : Number
		{
			return _bottom;
		}

		public function set bottom( value : Number ) : void
		{
			_bottom = value;
			_height = bottom - top;
		}

		/**
		 * The width of the rectangle defining the region of the zone.
		 */
		public function get width() : Number
		{
			return _width;
		}

		/**
		 * The height of the rectangle defining the region of the zone.
		 */
		public function get height() : Number
		{
			return _height;
		}

		/**
		 * @inheritDoc
		 */
		public function contains( x:Number, y:Number ):Boolean
		{
			return x >= _left && x < _right && y >= _top && y < _bottom;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLocation():Point
		{
			return new Point( _left + Math.random() * _width, _top + Math.random() * _height );
		}
		
		/**
		 * @inheritDoc
		 */
		public function getArea():Number
		{
			return _width * _height;
		}
	}
}
