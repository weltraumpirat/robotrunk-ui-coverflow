package org.robotrunk.ui.coverflow.impl {
	import mockolate.runner.MockolateRule;

	import org.flexunit.asserts.assertNotNull;
	import org.robotrunk.ui.coverflow.api.CoverFlowImage;
	import org.swiftsuspenders.Injector;

	public class CoverFlowImageTest {
		private var image:CoverFlowImage;

		[Rule]
		public var rule:MockolateRule = new MockolateRule();

		[Mock]
		public var injector:Injector;

		[Before]
		public function setUp():void {
			image = new CoverFlowImageImpl();
		}

		[Test]
		public function resizesLargeImages():void {
			assertNotNull( image );
		}

		[After]
		public function tearDown():void {
			image = null;
		}
	}
}
