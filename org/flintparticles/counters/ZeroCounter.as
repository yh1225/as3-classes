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
	 * The Zero counter causes the emitter to emit no particles. Because the emitter
	 * requires a counter, this counter is used as the default and should be used whenever
	 * you don't want a counter.
	 */
	public class ZeroCounter implements Counter
	{
		/**
		 * The constructor creates a Zero counter for use by an emitter. To
		 * add a Zero counter to an emitter use the emitter's counter property.
		 */
		public function ZeroCounter()
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function startEmitter( emitter:Emitter ):uint
		{
			return 0;
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