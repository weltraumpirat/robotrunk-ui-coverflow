package org.robotrunk.ui.coverflow.impl {
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.robotrunk.ui.core.Style;

	public class CoverFlowImageGeometryCalculator {
		private static const RADIAN:Number = Math.PI/180;

		private var _imageBounds:Rectangle;

		private var _itemPosition:Number;

		private var _cache:GeometryCache;

		private var _style:Style;

		public function destroy():void {
			_cache.destroy();
			_cache = null;
			_imageBounds = null;
			_style = null;
		}

		public function get style():Style {
			return _style;
		}

		public function set style( style:Style ):void {
			_style = style;
		}

		public function calculate( itemPosition:Number, bitmapBounds:Rectangle ):CoverFlowImageGeometry {
			_itemPosition = itemPosition;
			_imageBounds = bitmapBounds;
			_cache ||= new GeometryCache( style );
			return calculatedOrCachedValue( itemPosition, bitmapBounds );
		}

		private function calculatedOrCachedValue( itemPosition:Number, bitmapBounds:Rectangle ):CoverFlowImageGeometry {
			var cached:Boolean = _cache.hasCachedValue( itemPosition, bitmapBounds );
			var data:CoverFlowImageGeometry = cached
					? _cache.getCachedValue( itemPosition, bitmapBounds )
					: calculateValue();
			if( !cached ) {
				_cache.cacheValue( data, itemPosition, bitmapBounds );
			}
			return data;
		}

		private function calculateValue():CoverFlowImageGeometry {
			var value:CoverFlowImageGeometry = new CoverFlowImageGeometry();
			value.topLeft = topLeft;
			value.topRight = topRight;
			value.topLeftRear = topLeftRear;
			value.topRightRear = topRightRear;
			value.bottomLeft = bottomLeft;
			value.bottomRight = bottomRight;
			value.bottomLeftRear = bottomLeftRear;
			value.bottomRightRear = bottomRightRear;
			value.currentX = currentX;
			value.distanceFromCenter = distanceFromCenter;
			value.currentAlpha = currentAlpha;
			value.isOutOfView = isOutOfView;
			value.isOnTop = isOnTop;
			value.isRightOfCenter = isRightOfCenter;
			value.isLeftOfCenter = isLeftOfCenter;
			value.stepsToCenter = stepsToCenter;
			return value;
		}

		private function get topLeft():Point {
			return new Point( topLeftXOffset, topLeftYOffset );
		}

		private function get topLeftRear():Point {
			return new Point( topLeftXOffset, bottomLeft.y+currentHeightRear );
		}

		private function get topLeftXOffset():Number {
			return isLeftOfCenter ? 0 : currentWidthDifference;
		}

		private function get topLeftYOffset():Number {
			return isLeftOfCenter ? currentHeightDifference : rearHeight;
		}

		private function get topRight():Point {
			return new Point( style.imageWidth+topRightXOffset, topRightYOffset );
		}

		private function get topRightRear():Point {
			return new Point( style.imageWidth+topRightXOffset, bottomRight.y+currentHeightRear );
		}

		private function get topRightXOffset():int {
			return isLeftOfCenter ? -currentWidthDifference : 0;
		}

		private function get topRightYOffset():Number {
			return isLeftOfCenter ? rearHeight : currentHeightDifference;
		}

		private function get bottomLeft():Point {
			return new Point( bottomLeftXOffset, style.imageHeight+bottomLeftYOffset );
		}

		private function get bottomLeftRear():Point {
			return bottomLeft;
		}

		private function get bottomLeftXOffset():Number {
			return isLeftOfCenter ? 0 : currentWidthDifference;
		}

		private function get bottomLeftYOffset():Number {
			return isLeftOfCenter ? -currentHeightDifference : -rearHeight;
		}

		private function get bottomRight():Point {
			return new Point( style.imageWidth+bottomRightXOffset, style.imageHeight+bottomRightYOffset );
		}

		private function get bottomRightRear():Point {
			return bottomRight;
		}

		private function get bottomRightXOffset():int {
			return isLeftOfCenter ? -currentWidthDifference : 0;
		}

		private function get bottomRightYOffset():Number {
			return isLeftOfCenter ? -rearHeight : -currentHeightDifference;
		}

		private function get currentX():Number {
			return isInCenterArea ? centerAreaX : isRightOfCenter ? rightOfCenterX : leftOfCenterX;
		}

		private function get centerAreaX():Number {
			return _itemPosition*distanceFromCenter;
		}

		private function get rightOfCenterX():Number {
			return distanceFromCenter+(_itemPosition-1 )*style.offset;
		}

		private function get leftOfCenterX():Number {
			return -distanceFromCenter+(_itemPosition+1 )*style.offset;
		}

		private function get distanceFromCenter():Number {
			return style.imageWidth*.5;
		}

		private function get currentAlpha():Number {
			return distanceFromCenter>style.fadeDistance
					? Math.min( 1,
								style.fadeSpan/(distanceFromCenter-style.fadeDistance) )
					: 1;
		}

		private function get isOutOfView():Boolean {
			return Math.abs( currentX )>style.width*.5;
		}

		private function get isOnTop():Boolean {
			return isRightOfCenter || isCenterImage;
		}

		private function get isCenterImage():Boolean {
			return (Math.abs( currentX )<=distanceFromCenter && _itemPosition == 0);
		}

		private function get isInCenterArea():Boolean {
			return stepsToCenter<=1;
		}

		private function get isLeftOfCenter():Boolean {
			return _itemPosition<=0;
		}

		private function get isRightOfCenter():Boolean {
			return _itemPosition>0;
		}

		private function get currentWidth():Number {
			return isInCenterArea ? style.minWidth+widthDelta : style.minWidth;
		}

		private function get widthDelta():Number {
			return (1-stepsToCenter)*widthVariance;
		}

		private function get widthVariance():Number {
			return style.imageWidth-style.minWidth;
		}

		private function get currentWidthDifference():Number {
			return style.imageWidth-currentWidth;
		}

		private function get currentHeight():Number {
			return isInCenterArea ? style.minHeight+heightDelta : style.minHeight;
		}

		private function get rearHeight():Number {
			return currentHeightDifference+heightDifferenceRear;
		}

		private function get heightDelta():Number {
			return (1-stepsToCenter)*heightVariance;
		}

		private function get heightVariance():Number {
			return style.imageHeight-style.minHeight;
		}

		private function get currentHeightRear():Number {
			return currentHeight-2*(heightDifferenceRear);
		}

		private function get currentHeightDifference():Number {
			return (style.imageHeight-currentHeight)*.5;
		}

		private function get heightDifferenceRear():Number {
			return style.minWidth*sineOfSkewAngle;
		}

		private function get sineOfSkewAngle():Number {
			return Math.sin( currentAngle*RADIAN );
		}

		private function get currentAngle():Number {
			return isInCenterArea ? stepsToCenter*style.minAngle : style.minAngle;
		}

		private function get stepsToCenter():Number {
			return Math.abs( _itemPosition );
		}
	}
}

import flash.geom.Rectangle;

import org.robotrunk.ui.core.Style;
import org.robotrunk.ui.coverflow.impl.CoverFlowImageGeometry;

internal class GeometryCache {
	private static var _cache:Object;

	private var _style:Style;

	private function composeKey( itemPosition:Number, bitmapBounds:Rectangle ):String {
		return _style.type+"|"+_style.clazz+"|"+_style.id+"|"+itemPosition+"|"+bitmapBounds.width+"x"+bitmapBounds.height;
	}

	public function hasCachedValue( itemPosition:Number, bitmapBounds:Rectangle ):Boolean {
		var key:String = composeKey( itemPosition, bitmapBounds );
		return _cache.hasOwnProperty( key );
	}

	public function getCachedValue( itemPosition:Number, bitmapBounds:Rectangle ):CoverFlowImageGeometry {
		return _cache[composeKey( itemPosition, bitmapBounds )];
	}

	public function cacheValue( value:CoverFlowImageGeometry, itemPosition:Number, bitmapBounds:Rectangle ):void {
		_cache[composeKey( itemPosition, bitmapBounds )] = value;
	}

	public function GeometryCache( style:Style ) {
		_cache ||= new Object();
		_style = style;
	}

	public function destroy():void {
		_cache = null;
		_style = null;
	}
}
