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
	
	import org.flintparticles.emitters.Emitter;
	import org.flintparticles.particles.Particle;	

	/**
	 * The TurnAwayFromMouse action causes the particle to constantly adjust its direction
	 * so that it travels away from the mouse pointer.
	 */

	public class TurnAwayFromMouse extends Action
	{
		private var _power:Number;
		
		/**
		 * The constructor creates a TurnAwayFromMouse action for use by 
		 * an emitter. To add a TurnAwayFromMouse to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param power The strength of the turn action. Higher values produce a sharper turn.
		 */
		public function TurnAwayFromMouse( power:Number )
		{
			_power = power;
		}
		
		/**
		 * The strength of theturn action. Higher values produce a sharper turn.
		 */
		public function get power():Number
		{
			return _power;
		}
		public function set power( value:Number ):void
		{
			_power = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			if( ! ( emitter.renderer is DisplayObject ) )
			{
				return;
			}
			var dispObj:DisplayObject = DisplayObject( emitter.renderer );
			var turnLeft:Boolean = ( ( particle.y - dispObj.mouseY ) * particle.velX + ( dispObj.mouseX - particle.x ) * particle.velY > 0 );
			var newAngle:Number;
			if ( turnLeft )
			{
				newAngle = Math.atan2( particle.velY, particle.velX ) + _power * time;
				
			}
			else
			{
				newAngle = Math.atan2( particle.velY, particle.velX ) - _power * time;
			}
			var len:Number = Math.sqrt( particle.velX * particle.velX + particle.velY * particle.velY );
			particle.velX = len * Math.cos( newAngle );
			particle.velY = len * Math.sin( newAngle );
		}
	}
}
