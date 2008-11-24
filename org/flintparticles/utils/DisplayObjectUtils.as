package org.flintparticles.utils 
{
	import flash.display.DisplayObject;	
	
	public class DisplayObjectUtils 
	{
		public static function localToGlobalRotation( obj:DisplayObject, rotation:Number ):Number
		{
			var rot:Number = rotation + obj.rotation;
			for( var current:DisplayObject = obj.parent; current && current != obj.stage; current = current.parent )
			{
				rot += current.rotation;
			}
			return rot;
		}

		public static function globalToLocalRotation( obj:DisplayObject, rotation:Number ):Number
		{
			var rot:Number = rotation - obj.rotation;
			for( var current:DisplayObject = obj.parent; current && current != obj.stage; current = current.parent )
			{
				rot -= current.rotation;
			}
			return rot;
		}
	}
}
