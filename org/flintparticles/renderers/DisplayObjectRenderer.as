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
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Transform;
	
	import org.flintparticles.particles.Particle;	

	/**
	 * The DisplayObjectRenderer adds particles to its display list 
	 * and lets the flash player render them in its usual way.
	 * 
	 * <p>Particles may be represented by any DisplayObject and each particle 
	 * must use a different DisplayObject instance. The DisplayObject
	 * to be used should not be defined using the SharedImage initializer
	 * because this shares one DisplayObject instance between all the particles.
	 * The ImageClass initializer is commonly used because this creates a new 
	 * DisplayObject for each particle.</p>
	 * 
	 * <p>The DisplayObjectRenderer has mouse events disabled for itself and any 
	 * display objects in its display list. To enable mouse events for the renderer
	 * or its children set the mouseEnabled or mouseChildren properties to true.</p>
	 */
	public class DisplayObjectRenderer extends Sprite implements Renderer
	{
		/**
		 * The constructor creates a DisplayObjectRenderer. After creation it should
		 * be added to the display list of a DisplayObjectContainer to place it on 
		 * the stage and should be applied to an Emitter using the Emitter's
		 * renderer property.
		 * 
		 * @see org.flintparticles.emitters.Emitter#renderer
		 */
		public function DisplayObjectRenderer()
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function renderParticles( particles:Array ):void
		{
			var particle:Particle;
			var len:int = particles.length;
			for( var i:int = 0; i < len; ++i )
			{
				particle = particles[i];
				particle.image.transform.colorTransform = particle.colorTransform;
				particle.image.transform.matrix = particle.matrixTransform;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function addParticle( particle:Particle ):void
		{
			addChildAt( particle.image, 0 );
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeParticle( particle:Particle ):void
		{
			removeChild( particle.image );
		}
	}
}