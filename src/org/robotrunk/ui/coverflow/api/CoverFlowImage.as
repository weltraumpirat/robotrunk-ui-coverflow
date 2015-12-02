package org.robotrunk.ui.coverflow.api {
	import flash.display.Bitmap;

	import org.flashsandy.display.DistortImage;
	import org.robotrunk.ui.core.api.UIComponent;

	public interface CoverFlowImage extends UIComponent {
		function get id():int;

		function set id( id:int ):void;

		function get name():String;

		function set name( name:String ):void;

		function get image():Bitmap;

		function set image( image:Bitmap ):void;

		function get distortion():DistortImage;

		function set distortion( distortion:DistortImage ):void;

		function get reflectionDistortion():DistortImage;

		function set reflectionDistortion( distortion:DistortImage ):void;

		function render( coverFlowPosition:Number ):void;
	}
}
