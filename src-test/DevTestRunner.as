package {
	import flash.display.Sprite;

	import org.flexunit.internals.TraceListener;
	import org.flexunit.listeners.CIListener;
	import org.flexunit.runner.FlexUnitCore;
	import org.fluint.uiImpersonation.VisualTestEnvironmentBuilder;

	public class DevTestRunner extends Sprite {
		private var core:FlexUnitCore;

		public function DevTestRunner() {
			core = new FlexUnitCore();

			VisualTestEnvironmentBuilder.getInstance( this );

			core.addListener( new TraceListener() );
			core.addListener( new CIListener() );

			core.run( DevTestSuite );
		}
	}
}
