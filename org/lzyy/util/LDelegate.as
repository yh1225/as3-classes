package org.lzyy.util{
       public class LDelegate {
              public static  function create(f:Function,...arg):Function {
                     var _arg:Array=arg
                     var _f:Function=function () {
                     f.apply(null, _arg);
                     };
                     return _f;
              }
       }
}