package org.robotrunk.ui.coverflow.factory {
	import org.robotrunk.ui.core.api.UIComponent;
	import org.robotrunk.ui.core.factory.AbstractComponentFactory;
	import org.robotrunk.ui.coverflow.impl.CoverFlowImpl;

	public class CoverFlowFactory extends AbstractComponentFactory {
		override protected function createComponent():UIComponent {
			var component:UIComponent;
			component = getCoverFlowInstance();
			component.style = getComponentStyle();
			return component;
		}

		private function getCoverFlowInstance():CoverFlowImpl {
			var flow:CoverFlowImpl = parameters.injector.getInstance( CoverFlowImpl );
			flow.factory = parameters.injector.getInstance( CoverFlowImageFactory );
			flow.factory.style = getComponentStyle();
			return flow;
		}
	}
}
