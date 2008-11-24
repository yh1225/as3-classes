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

package org.flintparticles.particles
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;	

	/**
	 * The Particle class is a set of public properties shared by all particles.
	 * It is deliberately lightweight, with only one method. The Initializers
	 * and Actions modify these properties directly. This means that the same
	 * particles can be used in many different emitters, allowing Particle 
	 * objects to be reused.
	 * 
	 * Particles are usually created by the ParticleCreator class. This class
	 * just simplifies the reuse of Particle objects which speeds up the
	 * application. 
	 */
	public class Particle
	{
		/**
		 * The x coordinate of the particle in pixels.
		 */
		public var x:Number = 0;
		/**
		 * The y coordinate of the particle in pixels.
		 */
		public var y:Number = 0;
		/**
		 * The x coordinate of the velocity of the particle in pixels per second.
		 */
		public var velX:Number = 0;
		/**
		 * The y coordinate of the velocity of the particle in pixels per second.
		 */
		public var velY:Number = 0;
		
		/**
		 * The rotation of the particle in radians.
		 */
		public var rotation:Number = 0;
		/**
		 * The angular velocity of the particle in radians per second.
		 */
		public var angVelocity:Number = 0;

		/**
		 * The 32bit ARGB color of the particle. The initial value is 0xFFFFFFFF (white).
		 */
		public var color:uint = 0xFFFFFFFF;
		
		/**
		 * The scale of the particle ( 1 is normal size ).
		 */
		public var scale:Number = 1;
		
		/**
		 * The DisplayObject used to display the image.
		 */
		public var image:DisplayObject = null;
		
		/**
		 * The lifetime of the particle, in seconds.
		 */
		public var lifetime:Number = 0;
		/**
		 * The age of the particle, in seconds.
		 */
		public var age:Number = 0;
		/**
		 * The energy of the particle.
		 */
		public var energy:Number = 1;
		
		/**
		 * Whether the particle is dead and should be removed from the stage.
		 */
		public var isDead:Boolean = false;
		
		/**
		 * The position in the emitter's horizontal spacial sorted array
		 */
		public var spaceSortX:uint;
		
		/**
		 * The dictionary object enables actions and activities to add additional properties to the particle.
		 * Any object adding properties to the particle should use a reference to itself as the dictionary
		 * key, thus ensuring it doesn't clash with other object's properties. If multiple properties are
		 * needed, the dictionary value can be an object with a number of properties.
		 */
		public function get dictionary():Dictionary
		{
			if( _dictionary == null )
			{
				_dictionary = new Dictionary();
			}
			return _dictionary;
		}
		private var _dictionary:Dictionary = null;
		
		/**
		 * Creates a particle. Alternatively particles can be reused by using the ParticleCreator to create
		 * and manage them. Usually the emitter will create the particles and the user doesn't need
		 * to create them.
		 */
		public function Particle()
		{
		}
		
		/**
		 * Sets the particles properties to their default values.
		 */
		public function initialize():void
		{
			x = 0;
			y = 0;
			velX = 0;
			velY = 0;
			rotation = 0;
			angVelocity = 0;
			color = 0xFFFFFFFF;
			scale = 1;
			lifetime = 0;
			age = 0;
			energy = 1;
			isDead = false;
			image = null;
			spaceSortX = 0;
			_dictionary = null;
		}
		
		/**
		 * A transformation matrix for the position, scale and rotation of the particle.
		 */
		public function get matrixTransform():Matrix
		{
			var cos:Number = scale * Math.cos( rotation );
			var sin:Number = scale * Math.sin( rotation );
			return new Matrix( cos, sin, -sin, cos, x, y );
		}
		
		/**
		 * A ColorTransform object that converts white to the colour of the particle.
		 */
		public function get colorTransform():ColorTransform
		{
			return new ColorTransform( ( ( color >>> 16 ) & 255 ) / 255,
			                           ( ( color >>> 8 ) & 255 ) / 255,
			                           ( ( color ) & 255 ) / 255,
			                           ( ( color >>> 24 ) & 255 ) / 255,
			                           0,0,0,0 );
		}
	}
}
