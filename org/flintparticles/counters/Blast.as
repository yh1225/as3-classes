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
	 * The Blast counter causes the emitter to emit a single burst of
	 * particles when it starts and then emit no further particles.
	 * It is used, for example, to simulate an explosion.
	 */
	public class Blast implements Counter
	{
		private var _startMin:uint;
		private var _startMax:uint;
		
		/**
		 * The constructor creates a Blast counter for use by an emitter. To
		 * add a Blast counter to an emitter use the emitter's counter property.
		 * <p>If two parameters are passed to the constructor then a random
		 * value between the two is used. This allows for some variation
		 * between emitters using the same Blast settings. Otherwise the 
		 * single value passed in is used.</p>
		 * @param startMin The minimum number of particles to emit
		 * when the emitter starts.
		 * @param startMax The maximum number of particles to emit
		 * when the emitter starts. If not set then the emitter
		 * will emit exactly the startMin number of particles.
		 */
		public function Blast( startMin:Number, startMax:Number = NaN )
		{
			_startMin = startMin;
			_startMax = startMax;
		}
		
		/**
		 * The minimum number of particles to emit
		 * when the emitter starts.
		 */
		public function get startMin():Number
		{
			return _startMin;
		}
		public function set startMin( value:Number ):void
		{
			_startMin = value;
		}
		
		/**
		 * The maximum number of particles to emit
		 * when the emitter starts.
		 */
		public function get startMax():Number
		{
			return _startMax;
		}
		public function set startMax( value:Number ):void
		{
			_startMax = value;
		}
		
		/**
		 * When setting, this property sets both startMin and startMax to the same value.
		 * When reading, this property is the average of startMin and startMax.
		 */
		public function get startCount():Number
		{
			return _startMin == _startMax ? startMin : ( startMax + startMin ) * 0.5;
		}
		public function set startCount( value:Number ):void
		{
			startMax = _startMin = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function startEmitter( emitter:Emitter ):uint
		{
			if( _startMax )
			{
				return Math.round( _startMin + Math.random() * ( _startMax - _startMin ) );
			}
			return Math.round( _startMin );
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateEmitter( emitter:Emitter, time:Number ):uint
		{
			return 0;
		}
	}
}