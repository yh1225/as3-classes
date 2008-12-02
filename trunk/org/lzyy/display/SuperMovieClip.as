/*
Copyright (C) 2006 Big Spaceship, LLC

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.

*/
package org.lzyy.display
{
	import flash.display.MovieClip;
	import flash.display.FrameLabel;
	
	import org.lzyy.events.FrameEvent;
	
	public class SuperMovieClip extends MovieClip
	{
		private var _labelRef					:Object;
		private var _labelMethods				:Object;
		
		public function SuperMovieClip()
		{
			_labelRef = {};
			_labelMethods = {};
			// jk: populate label ref with all the labels so we can refer to them by object
			var labels:Array = this.currentLabels;
			for(var i:Number=0;i<labels.length;i++)
			{
				var frameLabel:FrameLabel = labels[i];
				_labelRef[frameLabel.name] = frameLabel.frame-1;
				addFrameScript(frameLabel.frame-1,_onFrameLabel);
			};
		};		
		
		// utility
		public function addMethodToLabel($label:String,$func:Function):void
		{
			removMethodFromLabel($label);
			_labelMethods[$label] = $func;
		};		
		
		public function removMethodFromLabel($label:String):void { _labelMethods[$label] = null; };

		private function _onFrameLabel():void
		{
			if(_labelMethods[currentLabel] != null) _labelMethods[currentLabel]();
			var f:FrameLabel = new FrameLabel(currentLabel,currentFrame);
			dispatchEvent(new FrameEvent(FrameEvent.LABEL,new FrameLabel(currentLabel,currentFrame)));
		};				
	};
};