package org.lzyy.util{

	import flash.events.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * Take a fileName, byteArray, and parameters object as input and return ByteArray post data suitable for a UrlRequest as output
	 *
	 * @see http://marstonstudio.com/?p=36
	 * @see http://www.w3.org/TR/html4/interact/forms.html
	 * @see http://www.jooce.com/blog/?p=143
	 * @see http://www.jooce.com/blog/wp%2Dcontent/uploads/2007/06/uploadFile.txt
	 * @see http://blog.je2050.de/2006/05/01/save-bytearray-to-file-with-php/
	 *
	 * @author Jonathan Marston
	 * @version 2007.08.19
	 *
	 * This work is licensed under a Creative Commons Attribution NonCommercial ShareAlike 3.0 License.
	 * @see http://creativecommons.org/licenses/by-nc-sa/3.0/
	 *
	 * @usage
	 * 
	 * //assumed variable declarations
	 * //var byteArray:ByteArray = jpg byte array created in step 2
	 * //var fileName:String = "desiredfilename.jpg"
	 * //var uploadPath:String = "http://destination.path.on/server"
	 * //var parameters:Object = optional generic object containing name value pairs to accompany the post
	 * //function onComplete(eventObj:Event):void {  handler for succesful loading of request
	 * //function onError(eventObj:ErrorEvent):void {  handler for faulty loading of request

	 * var urlRequest:URLRequest = new URLRequest();
	 * urlRequest.url = uploadPath;
	 * urlRequest.contentType = 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary();
	 * urlRequest.method = URLRequestMethod.POST;
	 * urlRequest.data = UploadPostHelper.getPostData(file, parameters);
	 * urlRequest.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );

	 * var urlLoader:URLLoader = new URLLoader();
	 * urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
	 * urlLoader.addEventListener(Event.COMPLETE, onComplete);
	 * urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
	 * urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
	 * urlLoader.load(urlRequest);
	 */
	public class UploadPostHelper {

		/**
		 * Boundary used to break up different parts of the http POST body
		 */
		private static var _boundary:String = "";

		/**
		 * Get the boundary for the post.
		 * Must be passed as part of the contentType of the UrlRequest
		 */
		public static function getBoundary():String {

			if(_boundary.length == 0) {
				for (var i:int = 0; i &lt; 0x20; i++ ) {
					_boundary += String.fromCharCode( int( 97 + Math.random() * 25 ) );
				}
			}

			return _boundary;
		}

		/**
		 * Create post data to send in a UrlRequest
		 */
		public static function getPostData(fileName:String, byteArray:ByteArray, parameters:Object = null):ByteArray {

			var i: int;
			var bytes:String;

			var postData:ByteArray = new ByteArray();
			postData.endian = Endian.BIG_ENDIAN;

			//add Filename to parameters
			if(parameters == null) {
				parameters = new Object();
			}
			parameters.Filename = fileName;

			//add parameters to postData
			for(var name:String in parameters) {
				postData = BOUNDARY(postData);
				postData = LINEBREAK(postData);
				bytes = 'Content-Disposition: form-data; name="' + name + '"';
				for ( i = 0; i &lt; bytes.length; i++ ) {
					postData.writeByte( bytes.charCodeAt(i) );
				}
				postData = LINEBREAK(postData);
				postData = LINEBREAK(postData);
				postData.writeUTFBytes(parameters[name]);
				postData = LINEBREAK(postData);
			}

			//add Filedata to postData
			postData = BOUNDARY(postData);
			postData = LINEBREAK(postData);
			bytes = 'Content-Disposition: form-data; name="Filedata"; filename="';
			for ( i = 0; i &lt; bytes.length; i++ ) {
				postData.writeByte( bytes.charCodeAt(i) );
			}
			postData.writeUTFBytes(fileName);
			postData = QUOTATIONMARK(postData);
			postData = LINEBREAK(postData);
			bytes = 'Content-Type: application/octet-stream';
			for ( i = 0; i &lt; bytes.length; i++ ) {
				postData.writeByte( bytes.charCodeAt(i) );
			}
			postData = LINEBREAK(postData);
			postData = LINEBREAK(postData);
			postData.writeBytes(byteArray, 0, byteArray.length);
			postData = LINEBREAK(postData);

			//add upload filed to postData
			postData = LINEBREAK(postData);
			postData = BOUNDARY(postData);
			postData = LINEBREAK(postData);
			bytes = 'Content-Disposition: form-data; name="Upload"';
			for ( i = 0; i &lt; bytes.length; i++ ) {
				postData.writeByte( bytes.charCodeAt(i) );
			}
			postData = LINEBREAK(postData);
			postData = LINEBREAK(postData);
			bytes = 'Submit Query';
			for ( i = 0; i &lt; bytes.length; i++ ) {
				postData.writeByte( bytes.charCodeAt(i) );
			}
			postData = LINEBREAK(postData);

			//closing boundary
			postData = BOUNDARY(postData);
			postData = DOUBLEDASH(postData);

			return postData;
		}

		/**
		 * Add a boundary to the PostData with leading doubledash
		 */
		private static function BOUNDARY(p:ByteArray):ByteArray {
			var l:int = UploadPostHelper.getBoundary().length;

			p = DOUBLEDASH(p);
			for (var i:int = 0; i &lt; l; i++ ) {
				p.writeByte( _boundary.charCodeAt( i ) );
			}
			return p;
		}

		/**
		 * Add one linebreak
		 */
		private static function LINEBREAK(p:ByteArray):ByteArray {
			p.writeShort(0x0d0a);
			return p;
		}

		/**
		 * Add quotation mark
		 */
		private static function QUOTATIONMARK(p:ByteArray):ByteArray {
			p.writeByte(0x22);
			return p;
		}

		/**
		 * Add Double Dash
		 */
		private static function DOUBLEDASH(p:ByteArray):ByteArray {
			p.writeShort(0x2d2d);
			return p;
		}

	}
}