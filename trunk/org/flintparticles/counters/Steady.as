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
	 * The Steady counter causes the emitter to emit particles continuously
	 * at a steady rate. It can be used to simulate any continuous particle
	 * stream. The rate can also be varied by setting a range of value for the
	 * emission rate.
	 */
	public class Steady implements Counter
	{
		private var _timeToNext:Number;
		private var _rateMin:Number;
		private var _rateMax:Number;
		private var _stop:Boolean;
		
		/**
		 * The constructor creates a Steady counter for use by an emitter. To
		 * add a Steady counter to an emitter use the emitter's counter property.
		 * <p>If two parameters are passed to the constructor then a random
		 * value between the two is used. This allows for random variation
		 * in the emission rate over the lifetime of the emitter. Otherwise the 
		 * single value passed in is used.</p>
		 * @param rateMin The minimum number of particles to emit
		 * per second.
		 * @param rateMax The maximum number of particles to emit
		 * per second. If not set then the emitter
		 * will emit exactly the rateMin number of particles per second.
		 */
		public function Steady( rateMin:Number, rateMax:Number = NaN )
		{
			_stop = false;
			_rateMin = rateMin;
			_rateMax = isNaN( rateMax ) ? rateMin : rateMax;
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
		 * The minimum number of particles to emit per second.
		 */
		public function get rateMin():Number
		{
			return _rateMin;
		}
		public function set rateMin( value:Number ):void
		{
			_rateMin = value;
		}
		
		/**
		 * The maximum number of particles to emit per second.
		 */
		public function get rateMax():Number
		{
			return _rateMax;
		}
		public function set rateMax( value:Number ):void
		{
			_rateMax = value;
		}
		
		/**
		 * When setting, this property sets both rateMin and rateMax to the same value.
		 * When reading, this property is the average of rateMin and rateMax.
		 */
		public function get rate():Number
		{
			return _rateMin == _rateMax ? _rateMin : ( _rateMax + _rateMin ) * 0.5;
		}
		public function set rate( value:Number ):void
		{
			_rateMax = _rateMin = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function startEmitter( emitter:Emitter ):uint
		{
			_timeToNext = newTimeToNext();
			return 0;
		}
		
		private function newTimeToNext():Number
		{
			var newRate:Number = ( _rateMin == _rateMax ) ? _rateMin : _rateMin + Math.random() * ( _rateMax - _rateMin );
			return 1 / newRate;
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
				++count;
				_timeToNext += newTimeToNext();
			}
			return count;
		}
	}
}