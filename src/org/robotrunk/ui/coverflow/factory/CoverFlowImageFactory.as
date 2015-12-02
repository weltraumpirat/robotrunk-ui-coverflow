package org.robotrunk.ui.coverflow.factory {
	import avmplus.getQualifiedClassName;

	import flash.display.Bitmap;

	import org.flashsandy.display.DistortImage;
	import org.robotools.data.comparison.isArrayType;
	import org.robotrunk.common.error.InvalidParameterException;
	import org.robotrunk.common.error.MissingValueException;
	import org.robotrunk.ui.core.Style;
	import org.robotrunk.ui.core.api.SerialItemFactory;
	import org.robotrunk.ui.coverflow.api.CoverFlowImage;
	import org.swiftsuspenders.Injector;

	public class CoverFlowImageFactory implements SerialItemFactory {
		[Inject]
		public var injector:Injector;

		private var _dataProvider:*;

		private var _style:Style;

		public function destroy():void {
			_dataProvider = null;
			injector = null;
			_style = null;
		}

		public function create():* {
			return injector.getInstance( CoverFlowImage );
		}

		public function createFrom( dataProvider:* ):Array {
			_dataProvider = dataProvider;
			return isValid() ? createImageArrayFromProvider() : [];
		}

		private function createImageArrayFromProvider():Array {
			var result:Array = createImagesFromProvider();
			cleanUp();
			return result;
		}

		private function createImagesFromProvider():Array {
			var result:Array = [];
			var i:int = -1;
			while( ++i<_dataProvider.length ) {
				var img:CoverFlowImage = create();
				img.style = style;
				img.id = i;
				img.name = _dataProvider[i];
				img.image = injector.getInstance( Bitmap, img.name );
				img.distortion = new DistortImage( style.imageWidth, style.imageHeight, 3, 3 );
				img.reflectionDistortion = new DistortImage( style.imageWidth, style.imageHeight, 1, 1 );
				result[i] = img;
			}
			return result;
		}

		private function cleanUp():void {
			_dataProvider = null;
		}

		private function isValid():Boolean {
			if( _dataProvider == null ) {
				throw new MissingValueException( "You must specify a dataProvider collection." );
				cleanUp();
				return false;
			}
			if( !isArrayType( getQualifiedClassName( _dataProvider ) ) ) {
				throw new InvalidParameterException( "dataProvider must be either an Array or a Vector." );
				cleanUp();
				return false;
			}
			return true;
		}

		public function get style():Style {
			return _style;
		}

		public function set style( style:Style ):void {
			_style = style;
		}
	}
}
