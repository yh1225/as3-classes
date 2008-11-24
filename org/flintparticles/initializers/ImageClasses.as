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

package org.flintparticles.initializers 
{
	import org.flintparticles.emitters.Emitter;
	import org.flintparticles.particles.Particle;
	import org.flintparticles.utils.construct;	

	/**
	 * The ImageClasses Initializer sets the DisplayObject to use to draw
	 * the particle. It selects one of multiple images that are passed to it.
	 * It is used with the DisplayObjectRenderer. When using the
	 * BitmapRenderer it is more efficient to use the SharedImage Initializer.
	 */

	public class ImageClasses extends Initializer
	{
		private var _images:Array;
		private var _ratios:Array;
		private var _parameters:Array;
		
		/**
		 * The constructor creates a ImageClasses initializer for use by 
		 * an emitter. To add a ImageClasses to all particles created by 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param images An array containing the classes to use for 
		 * each particle created by the emitter.
		 * @param parameters the parameters to use when calling the image class constructors.
		 * Each entry in this array is an array of parameters. A null entry indicates that
		 * no parameters are required. A null value for the parameters array indicates
		 * that none of the image classes require parameters.
		 * @param ratios The weighting to apply to each displayObject. If no weighting
		 * values are passed, the images are used with equal probability.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addInitializer()
		 */
		public function ImageClasses( images:Array, parameters:Array = null, ratios:Array = null )
		{
			_images = images;
			_ratios = new Array();
			var empty:Array = new Array();
			var i:int;
			var len:int = images.length;
			if( parameters == null )
			{
				_parameters = new Array();
				for( i = 0; i < len; ++i )
				{
					_parameters.push( empty );
				}
			}
			else
			{
				_parameters = parameters;
				for( i = _parameters.length; i < len; ++i )
				{
					_parameters.push( empty );
				}
			}
			if( ratios != null && ratios.length == len )
			{
				var total:Number = 0;
				for( i = 0; i < len; ++i )
				{
					total += ratios[i];
				}
				for( i = 0; i < len; ++i )
				{
					_ratios.push( ratios[i] / total );
				}
			}
			else
			{
				for( i = 0; i < len; ++i )
				{
					_ratios.push( (i + 1) / len );
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize( emitter:Emitter, particle:Particle ):void
		{
			var rand:Number = Math.random();
			var len:uint = _images.length;
			for( var i:uint = 0; i < len; ++i )
			{
				if( _ratios[i] >= rand )
				{
					particle.image = construct( _images[i], _parameters[i] );
					return;
				}
			}
			particle.image = construct( _images[ len - 1 ], _parameters[ len - 1 ] ); // in case of rounding error
		}
	}
}
