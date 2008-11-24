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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import org.flintparticles.particles.Particle;	

	/**
	 * The FullStagePixelRenderer is a custom PixelRenderer whose canvas exactly covers
	 * the stage. This canvas sizing is only reliable when the display region for the swf 
	 * is exactly the same size as the swf itself, so that no scaling occurs.
	 * 
	 * <p>It is more efficient to use a PixelRenderer with an appropriately defined canvas.
	 * This class exists to allow the continued use of functionality that existed in the
	 * PixelRenderer in early versions of Flint.</p>
	 * 
	 * <p>This renderer uses properties of the stage object. It throws an exception if it is
	 * not in the same security sandbox as the Stage owner (the main SWF file). To avoid 
	 * this, the Stage owner can grant permission to the domain containing this renderer
	 * by calling the Security.allowDomain() method or the Security.allowInsecureDomain()
	 * method.</p>
	 */
	public class FullStagePixelRenderer extends FullStageBitmapRenderer
	{
		/**
		 * The constructor creates a FullStagePixelRenderer. After creation it should be
		 * added to the display list of a DisplayObjectContainer to place it on 
		 * the stage and should be applied to an Emitter using the Emitter's
		 * renderer property.
		 */
		public function FullStagePixelRenderer()
		{
			super();
		}
		
		/**
		 * Used internally to draw the particles.
		 */
		override protected function drawParticle( particle:Particle ):void
		{
			_bitmap.bitmapData.setPixel32( Math.round( particle.x - _canvas.x ), Math.round( particle.y - _canvas.y ), particle.color );
		}
	}
}