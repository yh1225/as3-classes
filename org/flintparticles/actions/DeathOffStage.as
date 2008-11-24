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

package org.flintparticles.actions 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import org.flintparticles.emitters.Emitter;
	import org.flintparticles.particles.Particle;	

	/**
	 * The DeathOffStage action marks the particle as dead if it is outside the stage.
	 * This action is only reliable when the display region for the swf is exactly the
	 * same size as the swf itself, so that no scaling occurs.
	 * 
	 * <p>Warning: The DeathOffStage action is very slow. A DeathZone action with an appropriate
	 * RectangleZone is more efficient.</p>
	 * 
	 * <p>This renderer uses properties of the stage object. It throws an exception if it is
	 * not in the same security sandbox as the Stage owner (the main SWF file). To avoid 
	 * this, the Stage owner can grant permission to the domain containing this renderer
	 * by calling the Security.allowDomain() method or the Security.allowInsecureDomain()
	 * method.</p>
	 */

	public class DeathOffStage extends Action
	{
		private var _padding:Number;
		private var _left:Number = NaN;
		private var _right:Number = NaN;
		private var _top:Number = NaN;
		private var _bottom:Number = NaN;
		
		/**
		 * The constructor creates a DeathOffStage action for use by 
		 * an emitter. To add a DeathOffStage to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param padding An additional distance, in pixels, to add around the stage
		 * to allow for the size of the particles.
		 */
		public function DeathOffStage( padding:Number = 10 )
		{
			_padding = padding;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * <p>Returns a value of -20, so that the DeathOffStage executes after all movement has occured.</p>
		 */
		override public function getDefaultPriority():Number
		{
			return -20;
		}

		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			if( isNaN( _top ) )
			{
				if( ! ( emitter.renderer is DisplayObject ) )
				{
					return;
				}
				var dispObj:DisplayObject = DisplayObject( emitter.renderer );
				if( ! dispObj.stage || !dispObj.stage.stageWidth )
				{
					return;
				}
				var tl:Point = dispObj.globalToLocal( new Point( 0, 0 ) );
				var br:Point = dispObj.globalToLocal( new Point( dispObj.stage.stageWidth, dispObj.stage.stageHeight ) );
				_left = tl.x - _padding;
				_right = br.x + _padding;
				_top = tl.y - _padding;
				_bottom = br.y + _padding;
			}
			
			if( particle.x < _left || particle.x > _right || particle.y < _top || particle.y > _bottom )
			{
				particle.isDead = true;
			}
		}
	}
}
