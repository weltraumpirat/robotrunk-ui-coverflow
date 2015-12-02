package org.robotrunk.ui.coverflow.api {
	import org.robotrunk.ui.core.api.UIComponent;

	public interface CoverFlow extends UIComponent {
		function get dataProvider():*;

		function set dataProvider( dataProvider:* ):void;

		function get viewPosition():Number;

		function set viewPosition( position:Number ):void;
	}
}
