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

package org.flintparticles.counters
{
	import org.flintparticles.emitters.Emitter;	
	
	/**
	 * The Pulse counter causes the emitter to emit pulses of particles at a regular
	 * interval.
	 */
	public class Pulse implements Counter
	{
		private var _timeToNext:Number;
		private var _period:Number;
		private var _quantity:Number;
		private var _stop:Boolean;
		
		/**
		 * The constructor creates a Pulse counter for use by an emitter. To
		 * add a Pulse counter to an emitter use the emitter's counter property.
		 * 
		 * @param period The time, in seconds, between each pulse.
		 * @param quantity The number of particles to emit at each pulse.
		 */
		public function Pulse( period:Number, quantity:uint )
		{
			_stop = false;
			_quantity = quantity;
			_period = period;
		}
		
		/**
		 * Stops the emitter from emitting particles
		 */
		public function stop():void
		{
			_stop = true;
		}
		
		/**
		 * Resumes the emitter after a stop
		 */
		public function resume():void
		{
			_stop = false;
		}
		
		/**
		 * The time, in seconds, between each pulse.
		 */
		public function get period():Number
		{
			return _period;
		}
		public function set period( value:Number ):void
		{
			_period = value;
		}
		
		/**
		 * The number of particles to emit at each pulse.
		 */
		public function get quantity():uint
		{
			return _quantity;
		}
		public function set quantity( value:uint ):void
		{
			_quantity = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function startEmitter( emitter:Emitter ):uint
		{
			_timeToNext = _period;
			return _quantity;
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateEmitter( emitter:Emitter, time:Number ):uint
		{
			if( _stop )
			{
				return 0;
			}
			var count:uint = 0;
			_timeToNext -= time;
			while( _timeToNext <= 0 )
			{
				count += _quantity;
				_timeToNext += _period;
			}
			return count;
		}
	}
}