package org.robotrunk.ui.coverflow.event {
	import flash.events.Event;

	public class CoverFlowEvent extends Event {
		public static const UPDATE:String = "UPDATE";

		public static const READY:String = "READY";

		public static const SELECT:String = "SELECT";

		public static const VALUE_CHANGE:String = "VALUE_CHANGE";

		public static const SHOW:String = "SHOW";

		public static const HIDE:String = "HIDE";

		public var position:Number;

		public function CoverFlowEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
			super( type, bubbles, cancelable );
		}
	}
}
