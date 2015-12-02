package {
	import org.robotrunk.ui.coverflow.impl.CoverFlowFactoryTest;
	import org.robotrunk.ui.coverflow.impl.CoverFlowImageFactoryTest;
	import org.robotrunk.ui.coverflow.impl.CoverFlowImageTest;
	import org.robotrunk.ui.coverflow.impl.CoverFlowTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class DevTestSuite {
		public var coverFlowImageTest:CoverFlowImageTest;
		public var coverFlowImageFactoryTest:CoverFlowImageFactoryTest;
		public var coverFlowFactoryTest:CoverFlowFactoryTest;
		public var coverFlowTest:CoverFlowTest;

	}
}
