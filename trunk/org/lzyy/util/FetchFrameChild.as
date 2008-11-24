package org.lzyy.util
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * Author lzyy
	 * Email healdream@gmail.com
	 * Blog http://www.lzyy.name/
	 *
	 * Useage:
	 * var obj:Object 	= new Object();
	 * obj.parentMc 	= yourParentMc;
	 * obj.subMc 		= 目标MC
	 * obj.frame 		= 目标MC在父MC的帧
	 * obj.func			= yourFunction;//获取到目标MC后要执行的函数，返回目标MC，和参数(如果之前传参数过来的话)
	 * obj.arg			= 参数(Object，可选)
	 * FetchFrameChild.gotoAndRun(obj);
	 * yourFunction(mc:MovieClip,params:Object = null)
	 * {
	 * 		//do what you want with mc
	 * }
	 */

	public class FetchFrameChild
	{
		private static var _timer:Timer;
		private static var _subMc:String; //目标Mc
		private static var _args:Object;//函数的参数
		private static var _func:Function;//要执行的函数
		private static var _parentMc:MovieClip;//父MC

		public static function gotoAndRun(obj:Object)
		{
			//-------------------赋值
			_parentMc = obj.parentMc;//父Mc
			_subMc = obj.subMc;//子Mc,也就是我们要获取的目标Mc
			var frame:int = obj.frame;//要跳到的帧
			_func = obj.func;//获取子Mc后要执行的函数
			_args = obj.arg;//参数(可选)
			//-------------------End

			_parentMc.gotoAndStop(frame);//先跳到指定帧

			//-------------------使用Timer类来确定该Mc是否为null
			_timer = new Timer(10);
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			_timer.start();
			//-------------------End

		}

		private static function _onTimer(evt:TimerEvent)
		{
			if(_parentMc[_subMc]!=null)
			{
				var destMc = _parentMc[_subMc]; //目标MC
				if(_args!=null) _func(destMc,_args);
				else _func(destMc);

				//-------------------清理Timer
				_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
				_timer.stop();
				_timer = null;
				//-------------------End

			}
		}
	}

}

