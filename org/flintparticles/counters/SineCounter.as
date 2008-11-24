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
	 * The Sine counter causes the emitter to emit particles continuously
	 * at a rate that varies according to a sine wave.
	 */
	public class SineCounter implements Counter
	{
		private var _emitted:Number;
		private var _rateMin:Number;
		private var _rateMax:Number;
		private var _period:Number;
		private var _stop:Boolean;
		private var _timePassed:Number;
		private var _factor:Number;
		private var _scale:Number;
		
		/**
		 * The constructor creates a SineCounter counter for use by an emitter. To
		 * add a SineCounter counter to an emitter use the emitter's counter property.
		 * @period The period of the sine wave used, in seconds.
		 * @param rateMax The number of particles emitted per second at the peak of
		 * the sine wave.
		 * @param rateMin The number of particles to emit per second at the bottom
		 * of the sine wave.
		 */
		public function SineCounter( period:Number, rateMax:Number, rateMin:Number = 0 )
		{
			_stop = false;
			_period = period;
			_rateMin = rateMin;
			_rateMax = rateMax;
			_factor = 2 * Math.PI / period;
			_scale = 0.5 * ( _rateMax - _rateMin );
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
			_emitted = 0;
		}
		
		/**
		 * The number of particles to emit per second at the bottom
		 * of the sine wave.
		 */
		public function get rateMin():Number
		{
			return _rateMin;
		}
		public function set rateMin( value:Number ):void
		{
			_rateMin = value;
			_scale = 0.5 * ( _rateMax - _rateMin );
		}
		
		/**
		 * The number of particles emitted per second at the peak of
		 * the sine wave.
		 */
		public function get rateMax():Number
		{
			return _rateMax;
		}
		public function set rateMax( value:Number ):void
		{
			_rateMax = value;
			_scale = 0.5 * ( _rateMax - _rateMin );
		}
		
		/**
		 * The period of the sine wave used, in seconds.
		 */
		public function get period():Number
		{
			return _period;
		}
		public function set period( value:Number ):void
		{
			_period = value;
			_factor = 2 * Math.PI / _period;
		}
		
		/**
		 * @inheritDoc
		 */
		public function startEmitter( emitter:Emitter ):uint
		{
			_timePassed = 0;
			_emitted = 0;
			return 0;
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
			_timePassed += time;
			var count:uint = Math.floor( _rateMax * _timePassed + _scale * ( 1 - Math.cos( _timePassed * _factor ) ) / _factor );
			var ret:uint = count - _emitted;
			_emitted = count;
			trace( ret );
			return ret;
		}
	}
}