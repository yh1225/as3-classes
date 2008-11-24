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
	 * The Activity class is the abstract base class for all emitter activities. Instances of the 
	 * Activity class should not be directly created because the Activity class itself simply defines 
	 * default methods that do nothing. Classes that extend the Activity class implement their 
	 * own functionality for the methods they want to use.
	 * 
	 * <p>An Activity is a class that is used to modify the 
	 * behaviour of the emitter over time. It may, for example, move or
	 * rotate the emitter.</p>
	 * 
	 * <p>Activities are added to the emitter by using its addActivity method.</p> 
 	 * 
	 * @see org.flintparticles.emitters.Emitter#addActivity()
	 */
	public class Activity
	{
		/**
		 * The constructor creates an Activity object. But you shouldn't use it because the Activity
		 * class is abstract.
		 */
		public function Activity()
		{
		}

		/**
		 * The getDefaultPriority method is used to order the execution of activities.
		 * It is called within the emitter's addActivity method when the user doesn't
		 * manually set a priority. It need not be called directly by the user.
	 	 * 
		 * @see org.flintparticles.emitters.Emitter#addActivity()
		 */
		public function getDefaultPriority():Number
		{
			return 0;
		}
		
		/**
		 * The addedToEmitter method is called from the emitter when the Activity is added to it
		 * It is called within the emitter's addActivity method and need not
		 * be called by the user.
		 * 
		 * @param emitter The Emitter that the Activity was added to.
		 */
		public function addedToEmitter( emitter:Emitter ):void
		{
		}
		
		/**
		 * The removedFromEmitter method is called by the emitter when the Activity is removed from it
		 * It is called within the emitter's removeActivity method and need not
		 * be called by the user.
		 * 
		 * @param emitter The Emitter that the Activity was removed from.
		 */
		public function removedFromEmitter( emitter:Emitter ):void
		{
		}
		
		/**
		 * The initialize method is used by the emitter to start the activity.
		 * It is called within the emitter's start method and need not
		 * be called by the user.
		 * 
		 * @param emitter The Emitter that is using the activity.
		 */
		public function initialize( emitter:Emitter ):void
		{
		}
		
		/**
		 * The update method is used by the emitter to apply the activity.
		 * It is called within the emitter's update loop and need not
		 * be called by the user.
		 * 
		 * @param emitter The Emitter that is using the activity.
		 * @param time The duration of the frame - used for time based updates.
		 */
		public function update( emitter:Emitter, time:Number ):void
		{
		}
	}
}