﻿
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
	import org.flintparticles.easing.Linear;
	import org.flintparticles.emitters.Emitter;		

	/**
	 * The TimePeriod counter causes the emitter to emit particles for a period of time
	 * and then stop. The rate of emission over that period can be modified using
	 * easing equations that conform to the interface defined in Robert Penner's easing
	 * equations. An update to these equations is included in the 
	 * org.flintparticles.easing package.
	 * 
	 * @see org.flintparticles.easing
	 */
	public class TimePeriod implements Counter
	{
		private var _particles : uint;
		private var _duration : Number;
		private var _particlesPassed : uint;
		private var _timePassed : Number;
		private var _easing : Function;

		/**
		 * The constructor creates a TimePeriod counter for use by an emitter. To
		 * add a TimePeriod counter to an emitter use the emitter's counter property.
		 * @param numParticles The number of particles to emit over the full duration
		 * of the time period
		 * @param duration The duration of the time period. After this time is up the
		 * emitter will not release any more particles.
		 * @param easing An easing function used to distribute the emission of the
		 * particles over the time period. If no easing function is passed a simple
		 * linear distribution is used in which particles are emitted at a constant 
		 * rate over the time period.
		 */
		public function TimePeriod( numParticles : uint, duration : Number, easing : Function = null )
		{
			_particles = numParticles;
			_duration = duration;
			if ( easing == null )
			{
				_easing = Linear.easeNone;
			}
			else
			{
				_easing = easing;
			}
		}

		/**
		 * The number of particles to emit over the full duration
		 * of the time period.
		 */
		public function get numParticles():uint
		{
			return _particles;
		}
		public function set numParticles( value:uint ):void
		{
			_particles = value;
		}
		
		/**
		 * The duration of the time period. After this time is up the
		 * emitter will not release any more particles.
		 */
		public function get duration():Number
		{
			return _duration;
		}
		public function set duration( value:Number ):void
		{
			_duration = value;
		}
		
		/**
		 * An easing function used to distribute the emission of the
		 * particles over the time period.
		 */
		public function get easing():Function
		{
			return _easing;
		}
		public function set easing( value:Function ):void
		{
			_easing = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function startEmitter( emitter:Emitter ) : uint
		{
			_particlesPassed = 0;
			_timePassed = 0;
			return 0;
		}

		/**
		 * @inheritDoc
		 */
		public function updateEmitter( emitter:Emitter, time : Number ) : uint
		{
			if( _particlesPassed == _particles )
			{
				return 0;
			}
			
			_timePassed += time;
			
			if( _timePassed >= _duration )
			{
				var newParticles:uint = _particles - _particlesPassed;
				_particlesPassed = _particles;
				return newParticles;
			}
			
			var oldParticles:uint = _particlesPassed;
			_particlesPassed = Math.round( _easing( _timePassed, 0, _particles, _duration ) );
			return _particlesPassed - oldParticles;
		}
	}
}