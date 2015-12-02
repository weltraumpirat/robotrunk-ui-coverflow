package org.robotrunk.ui.coverflow.impl {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.robotools.graphics.drawing.Gradient;
	import org.robotools.graphics.drawing.GraphRectangle;
	import org.robotrunk.ui.core.Style;

	public class ReflectionImage {
		private var _style:Style;

		private var _bitmapData:BitmapData;

		public function destroy():void {
			_bitmapData.dispose();
			_bitmapData = null;
			_style = null;
		}

		public function get bitmapData():BitmapData {
			return _bitmapData;
		}

		public function set bitmapData( bitmapData:BitmapData ):void {
			_bitmapData = bitmapData;
			drawReflection( gradientBitmapData );
		}

		private function get gradientBitmapData():BitmapData {
			var alphaGradientBitmapData:BitmapData = new BitmapData( style.imageHeight, style.imageHeight, true, 0 );
			alphaGradientBitmapData.draw( createGradientBox(), new Matrix() );
			return alphaGradientBitmapData;
		}

		private function createGradientBox():Sprite {
			var box:Sprite = new Sprite();
			new GraphRectangle( box ).createRectangle( imageBounds ).fill( 0, 1, createGradient() ).draw();
			return box;
		}

		private function createGradient():Gradient {
			var gradient:Gradient = new Gradient( imageBounds,
												  [0,
												   style.gradientAlpha],
												  [gradientRatio,
												   255],
												  new Matrix(),
												  gradientRotation );
			gradient.colors = [0xFFFFFF, 0xFFFFFF];
			return gradient;
		}

		private function get gradientRotation():Number {
			return Math.PI*.5;
		}

		private function drawReflection( alphaGradientBitmapData:BitmapData ):void {
			var reflectionData:BitmapData = new BitmapData( style.imageHeight, style.imageHeight, true, 0x00000000 );
			reflectionData.copyPixels( bitmapData,
									   imageBounds,
									   new Point(),
									   alphaGradientBitmapData,
									   new Point(),
									   true );
			_bitmapData = reflectionData;
		}

		private function get gradientRatio():Number {
			return 255-Math.floor( (style.gradientHeight*.01)*255 );
		}

		private function get imageBounds():Rectangle {
			return new Rectangle( 0, 0, style.imageHeight, style.imageHeight );
		}

		public function get style():Style {
			return _style;
		}

		public function set style( style:Style ):void {
			_style = style;
		}
	}
}
