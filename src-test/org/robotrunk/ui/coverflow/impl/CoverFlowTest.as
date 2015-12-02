package org.robotrunk.ui.coverflow.impl {
	import flash.events.Event;

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.runner.MockolateRule;

	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.instanceOf;
	import org.robotrunk.ui.core.Style;
	import org.robotrunk.ui.coverflow.api.CoverFlowImage;
	import org.robotrunk.ui.coverflow.factory.CoverFlowImageFactory;

	public class CoverFlowTest {
		private var flow:CoverFlowImpl;

		[Rule]
		public var rule:MockolateRule = new MockolateRule();

		[Mock]
		public var factory:CoverFlowImageFactory;

		[Before(async, timeout=5000)]
		public function prepareMockolates():void {

			flow = new CoverFlowImpl();
			Async.proceedOnEvent( this, prepare( CoverFlowImageImpl ), Event.COMPLETE );
		}

		[Test]
		public function createsImagesFromDataProvider():void {
			var provider:Array = ["one", "two", "three"];
			mock( factory ).method( "createFrom" ).args( provider ).returns( [new CoverFlowImageImpl(),
																			  new CoverFlowImageImpl(),
																			  new CoverFlowImageImpl()] );
			flow.factory = factory;
			flow.dataProvider = provider;

			assertNotNull( flow.images );
			var i:int = -1;
			while( ++i<flow.images.length ) {
				assertThat( flow.images[i], instanceOf( CoverFlowImage ) );
			}
		}

		[Test]
		public function doesNotCreateImagesWhenDataProviderIsNull():void {
			mock( factory ).method( "createFrom" ).args( null ).never();
			flow.factory = factory;
			flow.dataProvider = null;
			assertNull( flow.images );
		}

		[Test]
		public function rendersImagesWhenPositionChanges():void {
			flow.images = mockImages();
			flow.style = createDummyStyle();
			flow.viewPosition = 1;
			for each( var img:CoverFlowImageImpl in flow.images ) {
				assertTrue( flow.contains( img ) );
			}
		}

		private function createDummyStyle():Style {
			var style:Style = new Style();
			style.imageWidth = 300;
			style.imageHeight = 300;
			style.width = 700;
			return style;
		}

		[Test]
		public function doesNotRenderImagesWhenPositionSame():void {
			flow.style = createDummyStyle();
			flow.viewPosition = 1;
			flow.images = mockImagesNever();
			flow.viewPosition = 1;
			for each( var img:CoverFlowImageImpl in flow.images ) {
				assertFalse( flow.contains( img ) );
			}
		}

		private function mockImages():Array {
			var images:Array = [];
			for( var i:int = 0; i<3; i++ ) {
				var img:CoverFlowImageImpl = nice( CoverFlowImageImpl );
				mock( img ).method( "render" ).args( 1 );
				images.push( img );
			}
			return images;
		}

		private function mockImagesNever():Array {
			var images:Array = [];
			for( var i:int = 0; i<3; i++ ) {
				var img:CoverFlowImageImpl = nice( CoverFlowImageImpl );
				mock( img ).method( "render" ).args( 1 ).never();
				images.push( img );
			}
			return images;
		}

		[After]
		public function tearDown():void {
			flow = null;
		}
	}
}
