package org.robotrunk.ui.coverflow.conf {
	import avmplus.getQualifiedClassName;

	import org.robotrunk.ui.core.conf.UIComponentProvider;
	import org.robotrunk.ui.coverflow.api.CoverFlow;
	import org.robotrunk.ui.coverflow.api.CoverFlowImage;
	import org.robotrunk.ui.coverflow.factory.CoverFlowFactory;
	import org.robotrunk.ui.coverflow.factory.CoverFlowImageFactory;
	import org.robotrunk.ui.coverflow.impl.CoverFlowImageGeometryCalculator;
	import org.robotrunk.ui.coverflow.impl.CoverFlowImageImpl;
	import org.robotrunk.ui.coverflow.impl.CoverFlowImpl;
	import org.robotrunk.ui.coverflow.impl.FramedCoverFlowImage;
	import org.robotrunk.ui.coverflow.impl.ReflectionImage;
	import org.swiftsuspenders.Injector;

	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;

	public class CoverFlowExtension implements IExtension {
		[Inject]
		public var injector:Injector;

		public function extend( context:IContext ):void {
			context.injector.injectInto( this );
			mapElements();
		}

		private function mapElements():void {
			injector.map( CoverFlowImageImpl );
			injector.map( CoverFlowImage ).toType( CoverFlowImageImpl );
			injector.map( CoverFlowImageFactory );
			injector.map( FramedCoverFlowImage );
			injector.map( ReflectionImage );
			injector.map( CoverFlowImageGeometryCalculator );
			var provider:UIComponentProvider = new UIComponentProvider( new CoverFlowFactory() );
			injector.map( UIComponentProvider, getQualifiedClassName( CoverFlowImpl ) ).toValue( provider );
			injector.map( CoverFlow ).toProvider( provider );
		}
	}
}
