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
	 * The Counter interface must be implemented by all counters.
	 * <p>A counter is a class that tells an emitter how many particles to
	 * emit at any time. The two methods allow the emission of particles
	 * when the emitter starts and every frame thereafter.</p>
	 * 
	 * <p>A counter is set for an emitter by assigning it to the emitter's 
	 * counter property.</p>
	 */
	public interface Counter 
	{
		/**
		 * The startEmitter method is called when the emitter starts.
		 * @param emitter The emitter
		 * @return The number of particles the emitter should emit
		 * at the moment it starts.
		 */
		function startEmitter( emitter:Emitter ):uint;
		
		/**
		 * The updateEmitter method is called every frame after the
		 * emitter has started.
		 * @param emitter The emitter
		 * @param time The time, in seconds, since the previous call to this method.
		 * @return The number of particles the emitter should emit
		 * at this time.
		 */
		function updateEmitter( emitter:Emitter, time:Number ):uint;
	}
}
