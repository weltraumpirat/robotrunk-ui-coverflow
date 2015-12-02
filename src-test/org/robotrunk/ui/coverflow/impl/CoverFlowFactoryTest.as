package org.robotrunk.ui.coverflow.impl {
	import flash.utils.Dictionary;

	import mockolate.mock;
	import mockolate.runner.MockolateRule;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.instanceOf;
	import org.robotrunk.ui.core.Style;
	import org.robotrunk.ui.core.StyleMap;
	import org.robotrunk.ui.coverflow.api.CoverFlow;
	import org.robotrunk.ui.coverflow.factory.CoverFlowFactory;
	import org.robotrunk.ui.coverflow.factory.CoverFlowImageFactory;
	import org.swiftsuspenders.Injector;

	public class CoverFlowFactoryTest {
		private var factory:CoverFlowFactory;

		[Rule]
		public var rule:MockolateRule = new MockolateRule();

		[Mock]
		public var injector:Injector;

		[Mock]
		public var styleMap:StyleMap;

		[Before]
		public function setUp():void {
			factory = new CoverFlowFactory();
		}

		[Test]
		public function createsCoverFlow():void {
			var params:Dictionary = prepareParameters();
			mockStyleMap();
			mockDependencies();
			assertThat( factory.create( injector, params ), instanceOf( CoverFlow ) );
		}

		private function mockDependencies():void {
			mock( injector ).method( "getInstance" ).args( StyleMap, "testMap" ).returns( styleMap );
			mock( injector ).method( "getInstance" ).args( CoverFlowImpl ).returns( new CoverFlowImpl() );
			mock( injector ).method( "getInstance" ).args( CoverFlowImageFactory ).returns( new CoverFlowImageFactory() );
		}

		private function mockStyleMap():void {
			var style:Style = new Style();
			style.icon = "something";
			mock( styleMap ).method( "getComponentStyleCascaded" ).args( "testType",
																		 "testClazz",
																		 "testID" ).returns( style );
		}

		private function prepareParameters():Dictionary {
			var params:Dictionary = new Dictionary();
			params.name = "testID";
			params.style = "testClazz";
			params.kind = "testType";
			params.map = "testMap";
			params.optional = false;

			return params;
		}

		[After]
		public function tearDown():void {
			factory = null;
		}
	}
}
