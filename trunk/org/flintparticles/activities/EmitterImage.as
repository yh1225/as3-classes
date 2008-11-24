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

package org.flintparticles.activities
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import org.flintparticles.emitters.Emitter;	

	/**
	 * The EmitterImage activity draws an image at the point where the emitter is.
	 */
	public class EmitterImage extends Activity
	{
		private var _image:DisplayObject;
		
		/**
		 * The constructor creates an EmitterImage activity for use by 
		 * an emitter. To add an EmitterImage to an emitter, use the
		 * emitter's addActvity method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addActivity()
		 * 
		 * @param image The display object to use as the image.
		 */
		public function EmitterImage( image:DisplayObject )
		{
			_image = image;
		}
		
		/**
		 * The display object to use as the image.
		 */
		public function get image():DisplayObject
		{
			return _image;
		}
		public function set image( value:DisplayObject ):void
		{
			_image = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize( emitter : Emitter ) : void
		{
			if( _image.parent )
			{
				_image.parent.removeChild( _image );
			}
			if( emitter.renderer is DisplayObjectContainer )
			{
				var dispObj:DisplayObjectContainer = DisplayObjectContainer( emitter.renderer );
				dispObj.addChild( _image );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter : Emitter, time : Number ) : void
		{
			if( !_image.parent )
			{
				if( emitter.renderer is DisplayObjectContainer )
				{
					var dispObj:DisplayObjectContainer = DisplayObjectContainer( emitter.renderer );
					dispObj.addChild( _image );
				}
			}
			_image.x = emitter.x;
			_image.y = emitter.y;
			_image.rotation = emitter.rotation;
		}
	}
}