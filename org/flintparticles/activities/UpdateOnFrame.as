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
	import org.flintparticles.emitters.Emitter;	

	/**
	 * The UpdateOnFrame activity is used to call a frameUpdate method of any class that implements the
	 * FrameUpdatable interface. This is most often used to update an action once every frame - the action
	 * implements FrameUpdatable and adds an UpdateOnFrame activity to the emitter in its addedToEmitter method.
	 * See the Explosion Action for an example of this.
	 * 
	 * @see org.flintparticles.actions.Explosion
	 */
	public class UpdateOnFrame extends Activity
	{
		private var action:FrameUpdatable;
		/**
		 * The constructor creates an UpdateOnFrame activity.
		 * @param fu The object that shouldbe updated every frame.
		 */
		public function UpdateOnFrame( fu:FrameUpdatable )
		{
			action = fu;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, time:Number ):void
		{
			action.frameUpdate( emitter, time );
		}
	}
}