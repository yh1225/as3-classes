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

package org.flintparticles.renderers 
{
	import org.flintparticles.particles.Particle;		

	/**
	 * The Renderer interface must be implemented by all renderers. A renderer 
	 * is a class that draws the particles that are managed by an emitter. A 
	 * renderer is set for an emitter by assigning it to the emitter's 
	 * renderer property.
	 * 
	 * @see org.flintparticles.emitters.Emitter#renderer
	 */
	public interface Renderer
	{
		/**
		 * The addParticle method is called when a particle is added to the emitter that
		 * this renderer is assigned to.
		 * @param particle The particle.
		 */
		function addParticle( particle:Particle ):void;

		/**
		 * The removeParticle method is called when a particle is removed from the 
		 * emitter that this renderer is assigned to.
		 * @param particle The particle.
		 */
		function removeParticle( particle:Particle ):void;

		/**
		 * The renderParticles method is called every frame so the renderer can
		 * draw the particles that are in the emitter that this renderer is
		 * assigned to.
		 * @param particles The particles to draw.
		 */
		function renderParticles( particles:Array ):void;
	}
}
