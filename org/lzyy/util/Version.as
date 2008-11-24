package org.lzyy.util
{
	import flash.external.ExternalInterface;
	/**
	 * Author	lzyy
	 * Email	healdream@gmail.com
	 * Blog		http://www.lzyy.name/blog
	 */
	public class Version 
	{
		
		public function Version()
		{
		
		}
		
		public static function setVersion(val:String)
		{
			try
			{
				var browsertype:String = ExternalInterface.call("eval", "navigator.userAgent");
				if(browsertype && browsertype.indexOf('Gecko')!=-1)
				ExternalInterface.call('console.info','current version : '+val);
			}
			catch (e:Error)
			{
				
			}
		}
	}
}
