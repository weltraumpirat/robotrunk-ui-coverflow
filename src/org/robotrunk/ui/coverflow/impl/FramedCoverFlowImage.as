package org.robotrunk.ui.coverflow.impl {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	import org.robotools.graphics.copyAsBitmap;
	import org.robotools.graphics.drawing.GraphRectangle;
	import org.robotrunk.ui.core.Style;

	public class FramedCoverFlowImage {
		private var _bitmapData:BitmapData;

		private var _source:Bitmap;

		private var _container:Sprite;

		private var _mask:Sprite;

		private var _frame:Sprite;

		private var _style:Style;

		public function destroy():void {
			clearRawData();
			_style = null;
			_bitmapData.dispose();
			_bitmapData = null;
		}

		public function get bitmapData():BitmapData {
			return _bitmapData;
		}

		public function set bitmapData( bitmapData:BitmapData ):void {
			_bitmapData = bitmapData;
			create();
			copyImageToBitmap();
			clearRawData();
		}

		private function create():void {
			createContainer();
			createSourceBitmap();
			createMask();
			createFrame();
			composeImage();
		}

		private function createContainer():void {
			_container = new Sprite();
		}

		private function createSourceBitmap():void {
			_source = new Bitmap( bitmapData );
		}

		protected function createMask():void {
			_mask = new Sprite();
			var rect:GraphRectangle = new GraphRectangle( _mask );
			rect.createRectangle( new Rectangle( 0, 0, _source.width, _source.height ) );
			rect.fill( 0, 1 );
			if( style.roundCorners ) {
				rect.withRoundCorners( style.roundCorners );
			}
			rect.draw();
		}

		protected function createFrame():Sprite {
			_frame = new Sprite();
			var rect:GraphRectangle = new GraphRectangle( _frame );
			rect.createRectangle( new Rectangle( style.frameThickness*.5,
												 style.frameThickness*.5,
												 _source.width-style.frameThickness,
												 _source.height-style.frameThickness ) );
			if( style.roundCorners ) {
				rect.withRoundCorners( style.roundCorners );
			}
			rect.line( style.frameThickness,
					   style.frameColor
							   ? style.frameColor
							   : 0,
					   style.frameAlpha
							   ? style.frameAlpha
							   : .5 );
			rect.draw();
			return _frame;
		}

		private function composeImage():void {
			_container.addChild( _source );
			_container.addChild( _mask );
			_source.mask = _mask;
			_container.addChild( _frame );
		}

		private function copyImageToBitmap():void {
			_bitmapData = copyAsBitmap( _container ).bitmapData;
		}

		private function clearRawData():void {
			_container = null;
			_source = null;
			_mask = null;
			_frame = null;
		}

		public function get style():Style {
			return _style;
		}

		public function set style( style:Style ):void {
			_style = style;
		}
	}
}
