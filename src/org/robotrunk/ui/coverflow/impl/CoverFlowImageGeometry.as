package org.robotrunk.ui.coverflow.impl {
	import flash.geom.Point;

	public class CoverFlowImageGeometry {
		public var stepsToCenter:Number;

		public var isLeftOfCenter:Boolean;

		public var isRightOfCenter:Boolean;

		public var topLeft:Point;

		public var topRight:Point;

		public var topLeftRear:Point;

		public var topRightRear:Point;

		public var bottomLeft:Point;

		public var bottomRight:Point;

		public var bottomLeftRear:Point;

		public var bottomRightRear:Point;

		public var currentX:Number;

		public var distanceFromCenter:Number;

		public var currentAlpha:Number;

		public var isOutOfView:Boolean;

		public var isOnTop:Boolean;

	}
}
