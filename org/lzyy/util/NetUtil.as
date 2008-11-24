package org.lzyy.util
{
    import flash.events.*;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.net.URLVariables;
    
    /**
    * author lzyy
    * Email:healdream@gmail.com
    * Blog:http://www.lzyy.name/blog
    * 
    * version 1.0
    * lastUpdate 2008/08/19
    * 
    * usage
    * NetUtil.post("http://www.example.com/data.php",{user:"lzyy",email:"test@test.com"},yourFunction);
    * NetUtil.get("http://www.example.com/data.php",{user:"lzyy",email:"test@test.com"},yourFunction);
    */
    public class NetUtil extends EventDispatcher
    {
        //public static const SEC_ERROR:String = 'sec_error';
        private static var func:Function;
        private static var loader:URLLoader = new URLLoader();
        private static var variable:URLVariables = new URLVariables();
        private static var request:URLRequest = new URLRequest();
        
        public function NetUtil()
        {
            trace("have a nice day! I'm a static class, you can call my method directly");
        }
        
        public static function post( ... args )
        {
            if (args.length != 3)
            {
                throw new Error("the number of paramters should be 3");
            }
            getOrPost(args[0],args[1],args[2],'post');
        }
        
        public static function get( ... args )
        {
            if (args.length != 3)
            {
                throw new Error("the number of paramters should be 3");
            }
            getOrPost(args[0],args[1],args[2],'get');
        }
        
        private static function getOrPost( ... args )
        {
            //设置request的一些变量
            
            if (args[3] == 'get')
            {
                request.method = 'GET';
            }
            else
            {
                //var arr = new Array(new URLRequestHeader('Accept', 'application/json'));
                //request.contentType = "application/x-www-form-urlencoded";
                //request.requestHeaders = arr; 
                request.method = 'POST';
            }
            request.url = args[0];
            //设置variable的一些变量
            var parms:Object = args[1];
            for (var i in parms)
            {
                variable[i] = parms[i];
            }
            request.data = variable;
            //设置func
            func = args[2];
            //action
            loader.addEventListener(Event.COMPLETE, onDataLoaded);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);
            loader.load(request);
        }
        
        private static function onDataLoaded(evt:Event)
        {
            func(loader.data);
        }
        
        private static function _onSecurityError(evt:SecurityErrorEvent)
        {
            throw new Error('security error!');
        }
    }
    
}