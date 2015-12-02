package org.robotrunk.ui.coverflow.impl {
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;

	import flash.display.Bitmap;
	import flash.display.Sprite;

	import org.flashsandy.display.DistortImage;
	import org.robotrunk.common.logging.impl.TraceLoggerImpl;
	import org.robotrunk.ui.core.Style;

	public class LiveImageTest extends Sprite {
		[Embed(source="episode001.jpg", mimeType="image/jpeg")]
		private var TestImage:Class;

		private var image:Bitmap;

		private var cfImage:CoverFlowImageImpl;

		private var style:Style;

		private var _position:Number;

		public function LiveImageTest() {
			image = new TestImage();
			// addChild( image );

			cfImage = new CoverFlowImageImpl();
			style = createStyle();
			cfImage.style = style;
			cfImage.id = 0;
			cfImage.geometryCalculator = new CoverFlowImageGeometryCalculator();
			cfImage.geometryCalculator.style = style;
			cfImage.distortion = new DistortImage( style.imageWidth, style.imageHeight, 3, 3 );
			cfImage.reflectionDistortion = new DistortImage( style.imageWidth, style.imageHeight, 1, 1 );
			cfImage.frame = new FramedCoverFlowImage();
			cfImage.reflection = new ReflectionImage();
			cfImage.log = new TraceLoggerImpl();
			cfImage.image = image;
			addChild( cfImage );
			cfImage.x = stage.stageWidth*.5-style.imageWidth*.5;
			position = 3;
			TweenMax.to( this, 10, {position: 0, ease: Sine.easeOut} );
			TweenMax.to( this, 10, {position: -3, delay: 10, ease: Sine.easeIn} );
		}

		public function set position( n:Number ):void {
			_position = n;
			cfImage.render( n );
		}

		public function get position():Number {
			return _position;
		}

		private function createStyle():Style {
			var style:Style = new Style();
			style.width = 700;
			style.imageWidth = 300;
			style.imageHeight = 300;
			style.fadeSpan = 100;
			style.fadeDistance = 180;
			style.offset = 40;
			style.minHeight = 180;
			style.minWidth = 40;
			style.minAngle = 40;
			style.gradientAlpha = .5;
			style.gradientHeight = 100;
			style.frameColor = 0;
			style.frameAlpha = .5;
			style.frameThickness = 2;
			style.roundCorners = 25;
			return style;
		}
	}
}
