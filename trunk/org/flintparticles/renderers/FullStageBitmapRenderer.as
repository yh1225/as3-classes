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
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;	

	/**
	 * The FullStageBitmapRenderer is a custom BitmapRenderer whose canvas exactly covers
	 * the stage. This canvas sizing is only reliable when the display region for the swf 
	 * is exactly the same size as the swf itself, so that no scaling occurs.
	 * 
	 * <p>It is more efficient to use a BitmapRenderer with an appropriately defined canvas.
	 * This class exists to allow the continued use of functionality that existed in the
	 * BitmapRenderer in early versions of Flint.</p>
	 * 
	 * <p>This renderer uses properties of the stage object. It throws an exception if it is
	 * not in the same security sandbox as the Stage owner (the main SWF file). To avoid 
	 * this, the Stage owner can grant permission to the domain containing this renderer
	 * by calling the Security.allowDomain() method or the Security.allowInsecureDomain()
	 * method.</p>
	 */
	public class FullStageBitmapRenderer extends BitmapRenderer
	{
		/**
		 * The constructor creates a FullStageBitmapRenderer. After creation it should be
		 * added to the display list of a DisplayObjectContainer to place it on 
		 * the stage and should be applied to an Emitter using the Emitter's
		 * renderer property.
		 */
		public function FullStageBitmapRenderer( smoothing:Boolean = false )
		{
			super( null, smoothing );
			addEventListener( Event.ADDED_TO_STAGE, addedToStage, false, 0, true );
			addEventListener( Event.REMOVED_FROM_STAGE, removedFromStage, false, 0, true );
		}
		
		/**
		 * Throws an error. You cannot set the canvas of a FullStageBitmapRenderer.
		 */
		override public function set canvas( value:Rectangle ):void
		{
			throw( new Error( "You may not set the canvas of a FullStageBitmapRenderer." ) );
		}
		
		private function createCanvas():void
		{
			if( !stage || stage.stageWidth == 0 )
			{
				return;
			}
			super.canvas = getNewCanvasRect();
		}
		
		private function updateCanvas():void
		{
			if( !stage || stage.stageWidth == 0 )
			{
				return;
			}
			if( !_bitmap || !_bitmap.bitmapData )
			{
				createCanvas();
				return;
			}
			var newCanvas:Rectangle = getNewCanvasRect();
			if( newCanvas.equals( _canvas ) )
			{
				return;
			}
			var newBitmapData:BitmapData = new BitmapData( newCanvas.width, newCanvas.height, true, 0 );
			var offset:Point = new Point( _canvas.x - newCanvas.x, canvas.y - newCanvas.y );
			newBitmapData.copyPixels( _bitmap.bitmapData, _bitmap.bitmapData.rect, offset, null, null, true );
			_bitmap.bitmapData.dispose();
			_bitmap.bitmapData = newBitmapData;
			_canvas = newCanvas;
			_bitmap.x = _canvas.x;
			_bitmap.y = _canvas.y;
		}
		
		private function getNewCanvasRect():Rectangle
		{
			var tl:Point = globalToLocal( BitmapRenderer.ZERO_POINT );
			var br:Point = globalToLocal( new Point( stage.stageWidth, stage.stageHeight ) );
			return new Rectangle( tl.x, tl.y, br.x - tl.x, br.y - tl.y );
		}
		
		private function addedToStage( ev:Event ):void
		{
			createCanvas();
		}
		
		private function removedFromStage( ev:Event ):void
		{
			dispose();
		}
		
		/**
		 * Override's the default x property of the display object to add additional functionality
		 * for managing the bitmap display.
		 */
		override public function set x( value:Number ):void
		{
			super.x = value;
			updateCanvas();
		}
		
		/**
		 * Override's the default y property of the display object to add additional functionality
		 * for managing the bitmap display.
		 */
		override public function set y( value:Number ):void
		{
			super.y = value;
			updateCanvas();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function renderParticles( particles:Array ):void
		{
			updateCanvas();
			super.renderParticles( particles );
		}
	}
}