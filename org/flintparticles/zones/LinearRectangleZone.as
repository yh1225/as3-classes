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
	import org.flintparticles.zones.RectangleZone;	

	/**
	 * The LinearRectangleZone defines a rectangle shaped zone in which locations are returned in a 
	 * regular linear pattern, rather than the random pattern of the standard RectangleZone.
	 */
	public class LinearRectangleZone extends RectangleZone 
	{
		private var _direction:String;
		private var _start:String;
		private var _stepX:Number;
		private var _stepY:Number;
		private var _x:Number;
		private var _y:Number;
		private var updateFunction:Function;
		
		/**
		 * The constructor creates a LinearRectangleZone zone.
		 * 
		 * @param left The left coordinate of the rectangle defining the region of the zone.
		 * @param top The top coordinate of the rectangle defining the region of the zone.
		 * @param right The right coordinate of the rectangle defining the region of the zone.
		 * @param bottom The bottom coordinate of the rectangle defining the region of the zone.
		 * @param start The position in the zone to start getting locations - may be any corner
		 * of the rectangle. The allowed values are defined in the ZoneConstants class as
		 * ZoneConstants.TOP_LEFT, ZoneConstants.TOP_RIGHT, ZoneConstants.BOTTOM_LEFT
		 * and ZoneConstants.BOTTOM_RIGHT.
		 * @param direction. The direction to advance first. If ZoneConstants.HORIZONTAL, the locations
		 * advance horizontally across the zone, moving vertically when wrapping around at the end. If
		 * ZoneConstants.VERTICAL, the locations advance vertically up/down the zone, moving horizontally 
		 * when wrapping around at the top/bottom.
		 */
		public function LinearRectangleZone( left:Number, top:Number, right:Number, bottom:Number,
				start:String = "topLeft", direction:String = "horizontal",
				horizontalStep:Number = 1, verticalStep:Number = 1 )
		{
			super( left, top, right, bottom );
			_start = start;
			_direction = direction;
			_stepX = Math.abs( horizontalStep );
			_stepY = Math.abs( verticalStep );
			init();
		}
		
		private function init():void
		{
			switch( _start )
			{
				case ZoneConstants.TOP_LEFT:
					if( _direction == ZoneConstants.VERTICAL )
					{
						_x = left;
						_y = top - _stepY;
						updateFunction = updateLocationTopLeftVertical;
					}
					else
					{
						_x = left - _stepX;
						_y = top;
						updateFunction = updateLocationTopLeftHorizontal;
					}
					break;

				case ZoneConstants.TOP_RIGHT:
					if( _direction == ZoneConstants.VERTICAL )
					{
						_x = right - 1;
						_y = top - _stepY;
						updateFunction = updateLocationTopRightVertical;
					}
					else
					{
						_x = right - 1 + _stepX;
						_y = top;
						updateFunction = updateLocationTopRightHorizontal;
					}
					break;

				case ZoneConstants.BOTTOM_LEFT:
					if( _direction == ZoneConstants.VERTICAL )
					{
						_x = left;
						_y = bottom - 1 + _stepY;
						updateFunction = updateLocationBottomLeftVertical;
					}
					else
					{
						_x = left - _stepX;
						_y = bottom - 1;
						updateFunction = updateLocationBottomLeftHorizontal;
					}
					break;

				case ZoneConstants.BOTTOM_RIGHT:
					if( _direction == ZoneConstants.VERTICAL )
					{
						_x = right - 1;
						_y = bottom - 1 + _stepY;
						updateFunction = updateLocationBottomRightVertical;
					}
					else
					{
						_x = right - 1 + _stepX;
						_y = bottom - 1;
						updateFunction = updateLocationBottomRightHorizontal;
					}
					break;
			}
		}
		
		/*
		 * One of these methods will be used in the getLocation function,
		 * depending on the start point and direction.
		 */
		private function updateLocationTopLeftHorizontal():void
		{
			_x += _stepX;
			if( _x >= right )
			{
				_x -= width;
				_y += _stepY;
				if( _y >= bottom )
				{
					_y -= height;
				}
			}
		}
		private function updateLocationTopRightHorizontal():void
		{
			_x -= _stepX;
			if( _x < left )
			{
				_x += width;
				_y += _stepY;
				if( _y >= bottom )
				{
					_y -= height;
				}
			}
		}
		private function updateLocationBottomLeftHorizontal():void
		{
			_x += _stepX;
			if( _x >= right )
			{
				_x -= width;
				_y -= _stepY;
				if( _y < top )
				{
					_y += height;
				}
			}
		}
		private function updateLocationBottomRightHorizontal():void
		{
			_x -= _stepX;
			if( _x < left )
			{
				_x += width;
				_y -= _stepY;
				if( _y < top )
				{
					_y += height;
				}
			}
		}
		private function updateLocationTopLeftVertical():void
		{
			_y += _stepY;
			if( _y >= bottom )
			{
				_y -= height;
				_x += _stepX;
				if( _x >= right )
				{
					_x -= width;
				}
			}
		}
		private function updateLocationTopRightVertical():void
		{
			_y += _stepY;
			if( _y >= bottom )
			{
				_y -= height;
				_x -= _stepX;
				if( _x < left )
				{
					_x += width;
				}
			}
		}
		private function updateLocationBottomLeftVertical():void
		{
			_y -= _stepY;
			if( _y < top )
			{
				_y += height;
				_x += _stepX;
				if( _x >= right )
				{
					_x -= width;
				}
			}
		}
		private function updateLocationBottomRightVertical():void
		{
			_y -= _stepY;
			if( _y < top )
			{
				_y += height;
				_x -= _stepX;
				if( _x < left )
				{
					_x += width;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getLocation():Point
		{
			updateFunction();
			return new Point( _x, _y );
		}
	}
}
