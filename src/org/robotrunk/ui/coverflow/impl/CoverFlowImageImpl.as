package org.robotrunk.ui.coverflow.impl {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.flashsandy.display.DistortImage;
	import org.robotools.graphics.drawing.GraphRectangle;
	import org.robotrunk.ui.core.impl.UIComponentImpl;
	import org.robotrunk.ui.coverflow.api.CoverFlowImage;
	import org.robotrunk.ui.coverflow.event.CoverFlowEvent;

	public class CoverFlowImageImpl extends UIComponentImpl implements CoverFlowImage {
		[Inject]
		public var geometryCalculator:CoverFlowImageGeometryCalculator;

		private var _geometry:CoverFlowImageGeometry;

		private var _distortion:DistortImage;

		private var _reflectionDistortion:DistortImage;

		[Inject]
		public var frame:FramedCoverFlowImage;

		[Inject]
		public var reflection:ReflectionImage;

		private var _coverFlowPosition:Number;

		private var _id:int;

		private var _imageContainer:Sprite;

		private var _image:Bitmap;

		private var _reflectionContainer:Sprite;

		private var _reflectionBitmap:Bitmap;

		override public function destroy():void {
			geometryCalculator.destroy();
			_geometry = null;
			destroyReflection();
			destroyImage();
			super.destroy();
		}

		private function destroyReflection():void {
			if( _reflectionContainer && contains( _reflectionContainer ) ) {
				removeChild( _reflectionContainer );
			}
			reflection.destroy();
			_reflectionDistortion = null;
			_reflectionBitmap = null;
		}

		private function destroyImage():void {
			if( _imageContainer && contains( _imageContainer ) ) {
				removeChild( _imageContainer );
			}
			frame.destroy();
			_distortion = null;
			_image = null;
		}

		private function onClick( ev:MouseEvent ):void {
			ev.stopPropagation();
			var event:CoverFlowEvent = new CoverFlowEvent( CoverFlowEvent.SELECT, true );
			event.position = id;
			dispatchEvent( event );
		}

		public function get image():Bitmap {
			return _image;
		}

		public function set image( bmp:Bitmap ):void {
			_image = bmp;
			create();
		}

		private function create():void {
			visible = false;
			adjustImageSize();
			geometryCalculator.style = style;
			x = -style.imageWidth*.5;
			y = -style.imageHeight*.5;
		}

		private function adjustImageSize():void {
			if( imageNeedsResizing ) {
				resizeImageBitmap();
			}
		}

		private function resizeImageBitmap():void {
			var resizeMatrix:Matrix = createResizeMatrix();
			var newBitmapData:BitmapData = new BitmapData( style.imageWidth, style.imageHeight, true, 0 );
			newBitmapData.draw( _image.bitmapData, resizeMatrix, null, null, null, true );
			_image.bitmapData = newBitmapData;
		}

		private function createResizeMatrix():Matrix {
			var matrix:Matrix = new Matrix();
			var sizeMultiplierX:Number = style.imageWidth/bitmapWidth;
			var sizeMultiplierY:Number = style.imageHeight/bitmapHeight;
			matrix.scale( sizeMultiplierX, sizeMultiplierY );
			return matrix;
		}

		public function render( coverFlowPosition:Number ):void {
			_coverFlowPosition = coverFlowPosition;
			_geometry = geometryCalculator.calculate( itemPosition, imageBounds );
			createSource();
			draw();
			visible = true;
		}

		private function createSource():void {
			if( !_imageContainer ) {
				createImage();
				createFrame();
				createReflection();
			}
		}

		private function createImage():void {
			_imageContainer = new Sprite();
			with( _imageContainer ) {
				mouseChildren = false;
				buttonMode = true;
				useHandCursor = true;
				addEventListener( MouseEvent.CLICK, onClick );
			}
			addChild( _imageContainer );
		}

		private function createFrame():void {
			frame.style = style;
			frame.bitmapData = _image.bitmapData;
			_image = new Bitmap( frame.bitmapData );
		}

		private function createReflection():void {
			if( _reflectionContainer && contains( _reflectionContainer ) ) {
				removeChild( _reflectionContainer );
			}
			_reflectionContainer = new Sprite();
			addChild( _reflectionContainer );
			reflection.style = style;
			reflection.bitmapData = _image.bitmapData.clone();
			_reflectionBitmap = new Bitmap( reflection.bitmapData );
		}

		private function draw():void {
			if( _geometry.isOutOfView ) {
				makeInvisible();
			} else {
				makeVisible();
				drawImage();
			}
		}

		private function makeVisible():void {
			_imageContainer.visible = _reflectionContainer.visible = true;
		}

		private function makeInvisible():void {
			_imageContainer.visible = _reflectionContainer.visible = false;
			_imageContainer.graphics.clear();
			_reflectionContainer.graphics.clear();
		}

		private function drawImage():void {
			var alphaBitmapData:BitmapData = createAlphaBitmap();
			renderImage( alphaBitmapData );
			renderReflection( alphaBitmapData );
			parent.setChildIndex( this, _geometry.isOnTop ? parent.numChildren-1 : 0 );
		}

		private function renderImage( alphaBitmapData:BitmapData ):void {
			var alphaImageBitmapData:BitmapData = alphaImage( alphaBitmapData );
			_imageContainer.graphics.clear();
			distortion.setTransform( _imageContainer.graphics,
									 alphaImageBitmapData,
									 _geometry.topLeft,
									 _geometry.topRight,
									 _geometry.bottomRight,
									 _geometry.bottomLeft );
			_imageContainer.x = _geometry.currentX;
		}

		private function renderReflection( alphaBitmapData:BitmapData ):void {
			var alphaReflectionBitmapData:BitmapData = reflectionAlphaImage( alphaBitmapData );
			_reflectionContainer.graphics.clear();
			reflectionDistortion.setTransform( _reflectionContainer.graphics,
											   alphaReflectionBitmapData,
											   _geometry.topLeftRear,
											   _geometry.topRightRear,
											   _geometry.bottomRightRear,
											   _geometry.bottomLeftRear );
			_reflectionContainer.x = _geometry.currentX;
		}

		private function alphaImage( alphaBitmapData:BitmapData ):BitmapData {
			return _geometry.currentAlpha == 1 ? _image.bitmapData : createImageBitmap( alphaBitmapData );
		}

		private function reflectionAlphaImage( alphaBitmapData:BitmapData ):BitmapData {
			return _geometry.currentAlpha == 1
					? _reflectionBitmap.bitmapData
					: createReflectionImageBitmap( alphaBitmapData );
		}

		private function createAlphaBitmap():BitmapData {
			var canvas:Sprite = new Sprite();
			new GraphRectangle( canvas ).createRectangle( imageBounds ).fill( 0, _geometry.currentAlpha ).draw();
			var alphaBitmapData:BitmapData = new BitmapData( style.imageWidth, style.imageHeight, true, 0x000000FF );
			alphaBitmapData.draw( canvas, new Matrix() );
			return alphaBitmapData;
		}

		private function createImageBitmap( alphaBitmapData:BitmapData ):BitmapData {
			var data:BitmapData = new BitmapData( style.imageWidth, style.imageHeight, false );
			data.copyPixels( _image.bitmapData, imageBounds, new Point(), alphaBitmapData, new Point(), true );
			return data;
		}

		private function createReflectionImageBitmap( alphaBitmapData:BitmapData ):BitmapData {
			var data:BitmapData = new BitmapData( style.imageWidth, style.imageHeight, false );
			data.copyPixels( _reflectionBitmap.bitmapData,
							 imageBounds,
							 new Point(),
							 alphaBitmapData,
							 new Point(),
							 true );
			return data;
		}

		private function get itemPosition():Number {
			return id-_coverFlowPosition;
		}

		private function get imageNeedsResizing():Boolean {
			return bitmapWidth != style.imageWidth || bitmapHeight != style.imageHeight;
		}

		private function get imageBounds():Rectangle {
			return new Rectangle( 0, 0, style.imageWidth, style.imageHeight );
		}

		private function get bitmapHeight():int {
			return _image.bitmapData.height;
		}

		private function get bitmapWidth():int {
			return _image.bitmapData.width;
		}

		public function get id():int {
			return _id;
		}

		public function set id( num:int ):void {
			_id = num;
		}

		public function get distortion():DistortImage {
			return _distortion;
		}

		public function set distortion( distortion:DistortImage ):void {
			_distortion = distortion;
		}

		public function get reflectionDistortion():DistortImage {
			return _reflectionDistortion;
		}

		public function set reflectionDistortion( reflectionDistortion:DistortImage ):void {
			_reflectionDistortion = reflectionDistortion;
		}
	}
}
