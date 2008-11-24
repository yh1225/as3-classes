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
	
	import org.flintparticles.emitters.Emitter;
	
	/**
	 * The FollowMouse activity causes the emitter to follow
	 * the position of the mouse pointer. The effect is for
	 * it to emit particles from the mouse pointer location.
	 */
	public class FollowMouse extends Activity
	{
		/**
		 * The constructor creates a FollowMouse activity for use by 
		 * an emitter. To add a FollowMouse to an emitter, use the
		 * emitter's addActvity method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addActivity()
		 */
		public function FollowMouse()
		{
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter : Emitter, time : Number ) : void
		{
			if( emitter.renderer is DisplayObject )
			{
				var dispObj:DisplayObject = DisplayObject( emitter.renderer );
				emitter.x = dispObj.mouseX;
				emitter.y = dispObj.mouseY;
			}
		}
	}
}
