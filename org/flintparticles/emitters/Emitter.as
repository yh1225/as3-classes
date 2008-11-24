
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

package org.flintparticles.emitters
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.getTimer;

	import org.flintparticles.actions.Action;
	import org.flintparticles.activities.Activity;
	import org.flintparticles.counters.Counter;
	import org.flintparticles.counters.ZeroCounter;
	import org.flintparticles.events.FlintEvent;
	import org.flintparticles.initializers.Initializer;
	import org.flintparticles.particles.Particle;
	import org.flintparticles.particles.ParticleCreator;
	import org.flintparticles.particles.ParticleFactory;
	import org.flintparticles.renderers.Renderer;
	import org.flintparticles.utils.DisplayObjectUtils;
	import org.flintparticles.utils.Maths;	

	/**
	 * Dispatched when a particle dies and is about to be removed from the system.
	 * As soon as the event has been handled the particle will be removed but at the
	 * time of the event it still exists so its properties (e.g. its location) can be
	 * read from it.
	 * 
	 * @eventType org.flintparticles.events.FlintEvent.PARTICLE_DEAD
	 */
	[Event(name="particleDead", type="org.flintparticles.events.FlintEvent")]

	/**
	 * Dispatched when a particle is created and has just been added to the system.
	 * 
	 * @eventType org.flintparticles.events.FlintEvent.PARTICLE_CREATED
	 */
	[Event(name="particleCreated", type="org.flintparticles.events.FlintEvent")]

	/**
	 * Dispatched when an emitter contains no particles. Used, for example, to remove an
	 * emitter when it contains no particles.
	 * 
	 * @eventType org.flintparticles.events.FlintEvent.EMITTER_EMPTY
	 */
	[Event(name="emitterEmpty", type="org.flintparticles.events.FlintEvent")]

	/**
	 * The Emitter class manages the creation and ongoing state of particles. It uses a number of
	 * utility classes to customise its behaviour.
	 * 
	 * <p>An emitter uses Initializers to customise the initial state of particles
	 * that it creates, their position, velocity, color etc. These are added to the 
	 * emitter using the addInitializer  method.</p>
	 * 
	 * <p>An emitter uses Actions to customise the behaviour of particles that
	 * it creates, to apply gravity, drag, fade etc. These are added to the emitter 
	 * using the addAction method.</p>
	 * 
	 * <p>An emitter uses Activities to customise its own behaviour in an ongoing manner, to 
	 * make it move or rotate.</p>
	 * 
	 * <p>An emitter uses a Counter to know when and how many particles to emit.</p>
	 * 
	 * <p>An emitter uses a Renderer to display the particles on screen.</p>
	 * 
	 * <p>All timings in the emitter are based on actual time passed, not on frames.</p>
	 * 
	 * <p>Most functionality is best added to an emitter using Actions,
	 * Initializers, Activities, Counters and Renderers. This offers greater 
	 * flexibility to combine behaviours witout needing to subclass 
	 * the Emitter itself.</p>
	 * 
	 * <p>The emitter also has position properties - x, y, rotation - that can be used to directly
	 * affect its location in the particle system.
	 */

	public class Emitter extends EventDispatcher
	{
		/**
		 * @private
		 * 
		 * default factory to manage the creation, reuse and destruction of particles
		 */
		protected static var _creator : ParticleCreator = new ParticleCreator( );

		/**
		 * @private
		 */
		protected var _particleFactory : ParticleFactory;

		/**
		 * @private
		 */
		protected var _initializers : Array;
		/**
		 * @private
		 */
		protected var _actions : Array;
		/**
		 * @private
		 */
		protected var _particles : Array;
		/**
		 * @private
		 */
		protected var _activities : Array;
		/**
		 * @private
		 */
		protected var _counter : Counter;
		/**
		 * @private
		 */
		protected var _renderer : Renderer;

		/**
		 * @private
		 */
		protected var _initializersPriority : Array;
		/**
		 * @private
		 */
		protected var _actionsPriority : Array;
		/**
		 * @private
		 */
		protected var _particlesPriority : Array;
		/**
		 * @private
		 */
		protected var _activitiesPriority : Array;

		private var _time : int;
		/**
		 * @private
		 */
		protected var _x : Number = 0;
		/**
		 * @private
		 */
		protected var _y : Number = 0;
		/**
		 * @private
		 */
		protected var _rotation : Number = 0;

		private var _ticker : Shape;

		/**
		 * Identifies whether the particles should be arranged
		 * into spacially sorted arrays - this speeds up proximity
		 * testing for those actions that need it.
		 */
		public var spaceSort : Boolean = false;
		/**
		 * The array of particle indices sorted based on the particles' horizontal positions.
		 * To persuade the emitter to create this array you should set the spaceSort property
		 * to true. Usually, actions that need this set to true will do so in their addedToEmitter
		 * method.
		 */
		public var spaceSortedX : Array;

		/**
		 * The constructor creates an emitter.
		 */
		public function Emitter()
		{
			_particleFactory = _creator;
			_particles = new Array( );
			_actions = new Array( );
			_initializers = new Array( );
			_activities = new Array( );
			_particlesPriority = new Array( );
			_actionsPriority = new Array( );
			_initializersPriority = new Array( );
			_activitiesPriority = new Array( );
			_counter = new ZeroCounter( );
			_ticker = new Shape( );
		}

		/**
		 * Indicates the x coordinate of the Emitter within the particle system's coordinate space.
		 */
		public function get x() : Number
		{
			return _x;
		}

		public function set x( value : Number ) : void
		{
			_x = value;
		}

		/**
		 * Indicates the y coordinate of the Emitter within the particle system's coordinate space.
		 */
		public function get y() : Number
		{
			return _y;
		}

		public function set y( value : Number ) : void
		{
			_y = value;
		}

		/**
		 * Indicates the rotation of the Emitter, in degrees, within the particle system's coordinate space.
		 */
		public function get rotation() : Number
		{
			return Maths.asDegrees( _rotation );
		}

		public function set rotation( value : Number ) : void
		{
			_rotation = Maths.asRadians( value );
		}

		/**
		 * Indicates the rotation of the Emitter, in radians, within the particle system's coordinate space.
		 */
		public function get rotRadians() : Number
		{
			return _rotation;
		}

		public function set rotRadians( value : Number ) : void
		{
			_rotation = value;
		}

		/**
		 * Adds an Initializer object to the Emitter. Initializers set the
		 * initial properties of particles created by the emitter.
		 * 
		 * @param initializer The Initializer to add
		 * @param priority Indicates the sequencing of the initializers. Higher numbers 
		 * cause an initializer to be run before other initialzers. All initializers 
		 * have a default priority which is used if no value is passed in this 
		 * parameter. The default priority is usually the one you want so this 
		 * parameter is only used when you need to override the default.
		 */
		public function addInitializer( initializer : Initializer, priority : Number = NaN ) : void
		{
			if( isNaN( priority ) )
			{
				priority = initializer.getDefaultPriority( );
			}
			for( var i : int = 0; i < _initializersPriority.length ; ++i )
			{
				if( _initializersPriority[ i ] < priority )
				{
					break;
				}
			}
			_initializers.splice( i, 0, initializer );
			_initializersPriority.splice( i, 0, priority );
			initializer.addedToEmitter( this );
		}

		/**
		 * Removes an Initializer from the Emitter.
		 * 
		 * @param initializer The Initializer to remove
		 * 
		 * @see addInitializer()
		 */
		public function removeInitializer( initializer : Initializer ) : void
		{
			for( var i : int = 0; i < _initializers.length ; ++i )
			{
				if( _initializers[i] == initializer )
				{
					_initializers.splice( i, 1 );
					_initializersPriority.splice( i, 1 );
					initializer.removedFromEmitter( this );
					return;
				}
			}
		}

		/**
		 * Adds an Action to the Emitter. Actions set the behaviour
		 * of particles created by the emitter.
		 * 
		 * @param action The Action to add
		 * @param priority Indicates the sequencing of the actions. Higher numbers cause
		 * an action to be run before other actions. All actions have a default priority
		 * which is used if no value is passed in this parameter. The default priority is usually
		 * the one you want so this parameter is only used when you need to override the default.
		 */
		public function addAction( action : Action, priority : Number = NaN ) : void
		{
			if( isNaN( priority ) )
			{
				priority = action.getDefaultPriority( );
			}
			for( var i : int = 0; i < _actionsPriority.length ; ++i )
			{
				if( _actionsPriority[ i ] < priority )
				{
					break;
				}
			}
			_actions.splice( i, 0, action );
			_actionsPriority.splice( i, 0, priority );
			action.addedToEmitter( this );
		}

		/**
		 * Removes an Action from the Emitter.
		 * 
		 * @param action The Action to remove
		 * 
		 * @see addAction()
		 */
		public function removeAction( action : Action ) : void
		{
			for( var i : int = 0; i < _actions.length ; ++i )
			{
				if( _actions[i] == action )
				{
					_actions.splice( i, 1 );
					_actionsPriority.splice( i, 1 );
					action.removedFromEmitter( this );
					return;
				}
			}
		}

		/**
		 * Adds an Activity to the Emitter. Activities set the behaviour
		 * of the Emitter.
		 * 
		 * @param activity The activity to add
		 * @param priority Indicates the sequencing of the activities. Higher numbers cause
		 * an activity to be run before other activities. All activities have a default priority
		 * which is used if no value is passed in this parameter. The default priority is usually
		 * the one you want so this parameter is only used when you need to override the default.
		 */
		public function addActivity( activity : Activity, priority : Number = NaN ) : void
		{
			if( isNaN( priority ) )
			{
				priority = activity.getDefaultPriority( );
			}
			for( var i : int = 0; i < _activitiesPriority.length ; ++i )
			{
				if( _activitiesPriority[ i ] < priority )
				{
					break;
				}
			}
			_activities.splice( i, 0, activity );
			_activitiesPriority.splice( i, 0, priority );
			activity.addedToEmitter( this );
		}

		/**
		 * Removes an Activity from the Emitter.
		 * 
		 * @param activity The Activity to remove
		 * 
		 * @see addActivity()
		 */
		public function removeActivity( activity : Activity ) : void
		{
			for( var i : int = 0; i < _activities.length ; ++i )
			{
				if( _activities[i] == activity )
				{
					_activities.splice( i, 1 );
					_activitiesPriority.splice( i, 1 );
					activity.removedFromEmitter( this );
					return;
				}
			}
		}

		/**
		 * The Counter for the Emitter. The counter defines when and
		 * with what frequency the emitter emits particles.
		 */		
		public function get counter() : Counter
		{
			return _counter;
		}

		public function set counter( value : Counter ) : void
		{
			_counter = value;
		}

		/**
		 * The Renderer for the Emitter. The renderer draws the particles.
		 */		
		public function get renderer() : Renderer
		{
			return _renderer;
		}

		public function set renderer( value : Renderer ) : void
		{
			_renderer = value;
		}

		/**
		 * This is the particle factory used by the emitter to create and dispose of particles.
		 * The default value is an instance of the ParticleCreator class that is shared by all
		 * emitters. You don't usually need to alter this unless you are not using the default
		 * particle type. Any custom particle factory should implement the ParticleFactory class.
		 * 
		 * @param particleFactory The particle factory to use
		 * 
		 * @see org.flintparticles.particles.ParticleCreator
		 */		
		public function get particleFactory() : ParticleFactory
		{
			return _particleFactory;
		}

		public function set particleFactory( value : ParticleFactory ) : void
		{
			_particleFactory = value;
		}

		/**
		 * The array of all particles created by this emitter.
		 */
		public function get particles() : Array
		{
			return _particles;
		}

		/**
		 * Adds existing display objects as particles to the emitter. This allows you, for example, 
		 * to take an existing image and subject it to the actions of the emitter.
		 * 
		 * <p>This method moves all the display objects into the emitter's renderer,
		 * removing them from their current position within the display list. It will
		 * only work if a renderer has been defined for the emitter and the renderer has
		 * been added to the display list.</p>
		 * 
		 * @param objects Each parameter is another display object for adding to the emitter.
		 * If you pass an array as the parameter, each item in the array should be another
		 * display object for adding to the emitter.
		 */
		public function addDisplayObjects( ...objects ) : void
		{
			for( var i : Number = 0; i < objects.length ; ++i )
			{
				if( objects[i] is Array )
				{
					for( var j : Number = 0; j < objects[i].length ; ++j )
					{
						if( objects[i][j] is DisplayObject )
						{
							addDisplayObject( objects[i][j] );
						}
					}
				}
				else if( objects[i] is DisplayObject )
				{
					addDisplayObject( objects[i] );
				}
			}
		}

		/*
		 * Used internally to add an individual display object to the emitter
		 */
		private function addDisplayObject( obj : DisplayObject ) : void
		{
			var particle : Particle = _particleFactory.createParticle( );
			var len : int = _initializers.length;
			for ( var i : int = 0; i < len ; ++i )
			{
				_initializers[i].initialize( this, particle );
			}
			var displayObj : DisplayObject = _renderer as DisplayObject;
			if ( obj.parent && displayObj )
			{
				var p : Point = displayObj.globalToLocal( obj.localToGlobal( new Point( 0, 0 ) ) );
				particle.x = p.x;
				particle.y = p.y;
				var r : Number = DisplayObjectUtils.globalToLocalRotation( displayObj, DisplayObjectUtils.localToGlobalRotation( obj, 0 ) );
				particle.rotation = Maths.asRadians( r );
				obj.parent.removeChild( obj );
			}
			else
			{
				particle.x = obj.x;
				particle.y = obj.y;
				particle.rotation = Maths.asRadians( obj.rotation );
			}
			particle.image = obj;
			_particles.unshift( particle );
			_renderer.addParticle( particle );
		}

		/*
		 * Used internally to create a particle.
		 */
		protected function createParticle() : Particle
		{
			var particle : Particle = _particleFactory.createParticle( );
			var len : int = _initializers.length;
			particle.x = _x;
			particle.y = _y;
			particle.rotation = _rotation;
			for ( var i : int = 0; i < len ; ++i )
			{
				_initializers[i].initialize( this, particle );
			}
			_particles.unshift( particle );
			_renderer.addParticle( particle );
			dispatchEvent( new FlintEvent( FlintEvent.PARTICLE_CREATED, particle ) );
			return particle;
		}

		/**
		 * Starts the emitter. Until start is called, the emitter will not emit any particles.
		 */
		public function start() : void
		{
			_ticker.removeEventListener( Event.ENTER_FRAME, frameLoop );
			_ticker.addEventListener( Event.ENTER_FRAME, frameLoop );
			_time = getTimer( );
			var len : int = _activities.length;
			for ( var i : int = 0; i < len ; ++i )
			{
				_activities[i].initialize( this );
			}
			len = _counter.startEmitter( this );
			for ( i = 0; i < len ; ++i )
			{
				createParticle( );
			}
		}

		/**
		 * Used internally to update the emitter. This method listens for the enterframe event.
		 * It simply calculates the duration of the frame then calls frameUpdate, passing the 
		 * frame duration to that method.
		 */
		private function frameLoop( ev : Event ) : void
		{
			// update timer
			var oldTime : int = _time;
			_time = getTimer( );
			var frameTime : Number = ( _time - oldTime ) * 0.001;
			/*			if( _renderer is DisplayObject && DisplayObject( _renderer ).stage )
			{
			var maxTime:Number = 3 / DisplayObject( _renderer ).stage.frameRate;
			if( frameTime > maxTime )
			{
			frameTime = maxTime;
			}
			}*/
			frameUpdate( frameTime );
		}

		/**
		 * Used internally and in derived classes to update the emitter.
		 * @param time The duration, in seconds, of the current frame.
		 */
		protected function frameUpdate( time : Number ) : void
		{
			var i : int;
			var particle : Particle;
			var len : int = _counter.updateEmitter( this, time );
			for( i = 0; i < len ; ++i )
			{
				createParticle( );
			}
			if( spaceSort )
			{
				spaceSortedX = _particles.sortOn( "x", Array.NUMERIC | Array.RETURNINDEXEDARRAY );
				len = _particles.length;
				for( i = 0; i < len ; ++i )
				{
					_particles[ spaceSortedX[i] ].spaceSortX = i;
				}
			}
			len = _activities.length;
			for ( i = 0; i < len ; ++i )
			{
				_activities[i].update( this, time );
			}
			if ( _particles.length > 0 )
			{
				
				// update particle state
				len = _actions.length;
				var action : Action;
				var len2 : int = _particles.length;
				
				for( var j : int = 0; j < len ; ++j )
				{
					action = _actions[j];
					for ( i = 0; i < len2 ; ++i )
					{
						particle = _particles[i];
						action.update( this, particle, time );
					}
				}
				// remove dead particles
				for ( i = len2; i-- ; )
				{
					particle = _particles[i];
					if ( particle.isDead )
					{
						dispatchEvent( new FlintEvent( FlintEvent.PARTICLE_DEAD, particle ) );
						_renderer.removeParticle( particle );
						_particleFactory.disposeParticle( particle );
						_particles.splice( i, 1 );
					}
				}
			}
			else 
			{
				dispatchEvent( new FlintEvent( FlintEvent.EMITTER_EMPTY ) );
			}
			_renderer.renderParticles( _particles );
		}

		/**
		 * Pauses the emitter.
		 */
		public function pause() : void
		{
			_ticker.removeEventListener( Event.ENTER_FRAME, frameLoop );
		}

		/**
		 * Resumes the emitter after a pause.
		 */
		public function resume() : void
		{
			_ticker.removeEventListener( Event.ENTER_FRAME, frameLoop );
			_ticker.addEventListener( Event.ENTER_FRAME, frameLoop );
			_time = getTimer( );
		}

		/**
		 * Cleans up the emitter prior to removal. If you don't call this method,
		 * the garbage collector will clean up all the particles in teh usual way.
		 * If you use this method, the particles will be returned to the particle
		 * factory for reuse.
		 */
		public function dispose() : void
		{
			_ticker.removeEventListener( Event.ENTER_FRAME, frameLoop );
			var len : int = _particles.length;
			for ( var i : int = 0; i < len ; ++i )
			{
				_particleFactory.disposeParticle( _particles[i] );
			}
			_particles.length = 0;
		}

		/**
		 * Makes the emitter skip forwards a period of time with a single update.
		 * Used when you want the emitter to look like it's been running for a while.
		 * 
		 * @param time The time, in seconds, to skip ahead.
		 * @param frameRate The frame rate for calculating the new positions. The
		 * emitter will calculate each frame over the time period to get the new state
		 * for the emitter and its particles. A higher frameRate will be more
		 * accurate but will take longer to calculate.
		 */
		public function runAhead( time : Number, frameRate : Number = 10 ) : void
		{
			pause( );
			var step : Number = 1 / frameRate;
			while ( time > 0 )
			{
				time -= step;
				frameUpdate( step );
			}
			resume( );
		}

		/**
		 * If the emitter's renderer is a display object, this method will
		 * calculate a localToGlobal on the point with respect to the renderer.
		 * The new point is returned. If the renderer is not a display object then
		 * the original point is returned.
		 */
		public function rendererLocalToGlobal( p : Point ) : Point
		{
			var q : Point = p.clone( );
			if( _renderer is DisplayObject )
			{
				q = DisplayObject( _renderer ).localToGlobal( q );
			}
			return q;
		}

		/**
		 * If the emitter's renderer is a display object, this method will
		 * calculate a localToGlobal on the point with respect to the renderer.
		 * The new point is returned. If the renderer is not a display object then
		 * the original point is returned.
		 */
		public function rendererGlobalToLocal( p : Point ) : Point
		{
			var q : Point = p.clone( );
			if( _renderer is DisplayObject )
			{
				q = DisplayObject( _renderer ).globalToLocal( q );
			}
			return q;
		}
	}
}