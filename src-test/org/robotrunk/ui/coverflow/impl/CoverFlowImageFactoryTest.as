package org.robotrunk.ui.coverflow.impl {
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import mockolate.mock;
	import mockolate.runner.MockolateRule;

	import org.flashsandy.display.DistortImage;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.instanceOf;
	import org.robotrunk.ui.core.Style;
	import org.robotrunk.ui.coverflow.api.CoverFlowImage;
	import org.robotrunk.ui.coverflow.factory.CoverFlowImageFactory;
	import org.swiftsuspenders.Injector;

	public class CoverFlowImageFactoryTest {
		private var factory:CoverFlowImageFactory;

		[Rule]
		public var rule:MockolateRule = new MockolateRule();

		[Mock]
		public var injector:Injector;

		[Mock]
		public var geometry:CoverFlowImageGeometryCalculator;

		private var style:Style;

		[Before]
		public function setUp():void {
		}

		[Test]
		public function createsSingleCoverFlowImage():void {
			mockForOneImage();
			assertThat( factory.create(), instanceOf( CoverFlowImage ) );
		}

		[Test]
		public function createsManyCoverFlowImagesFromArray():void {
			mockForThreeImages();
			var input:Array = ["one", "two", "three"];
			var result:Array = factory.createFrom( input );
			assertEquals( 3, result.length );
			assertTrue( areAllCoverFlowImages( result ) );
		}

		[Test]
		public function createsManyCoverFlowImagesFromVector():void {
			mockForThreeImages();
			var input:Vector.<String> = new <String>["one", "two", "three"];
			var result:Array = factory.createFrom( input );
			assertEquals( 3, result.length );
			assertTrue( areAllCoverFlowImages( result ) );
		}

		[Test(expects="org.robotrunk.common.error.InvalidParameterException")]
		public function throwsExceptionWhenDataProviderIsNotAnArray():void {
			mockForFailure();
			factory.createFrom( {} );
		}

		[Test(expects="org.robotrunk.common.error.MissingValueException")]
		public function throwsExceptionWhenDataProviderIsNull():void {
			mockForFailure();
			factory.createFrom( null );
		}

		private function mockForOneImage():void {
			mock( injector ).method( "getInstance" ).args( CoverFlowImage ).returns( new CoverFlowImageImpl() ).once();
			factory = new CoverFlowImageFactory();
			factory.injector = injector;
		}

		private function mockForThreeImages():void {
			createDummyStyle();
			mockGeometry();
			mockFrame();
			mockReflection();
			mock( injector ).method( "getInstance" ).args( CoverFlowImage ).returns( createImage() ).once();
			mock( injector ).method( "getInstance" ).args( Bitmap, "one" ).returns( createDummyBitmap() ).once();
			mock( injector ).method( "getInstance" ).args( CoverFlowImage ).returns( createImage() ).once();
			mock( injector ).method( "getInstance" ).args( Bitmap, "two" ).returns( createDummyBitmap() ).once();
			mock( injector ).method( "getInstance" ).args( CoverFlowImage ).returns( createImage() ).once();
			mock( injector ).method( "getInstance" ).args( Bitmap, "three" ).returns( createDummyBitmap() ).once();
			factory = new CoverFlowImageFactory();
			factory.style = style;
			factory.injector = injector;
		}

		private function createImage():CoverFlowImageImpl {
			var img:CoverFlowImageImpl = new CoverFlowImageImpl();
			img.geometryCalculator = geometry;
			img.distortion = new DistortImage( 200, 200, 3, 3 );
			img.reflectionDistortion = new DistortImage( 200, 200, 1, 1 );
			img.frame = mockFrame();
			img.reflection = mockReflection();
			return img;
		}

		private function createDummyStyle():void {
			style = new Style();
			style.width = 500;
			style.imageWidth = 200;
			style.imageHeight = 200;
			style.gradientHeight = 50;
			style.gradientAlpha = .5;
		}

		private function mockReflection():ReflectionImage {
			var reflection:ReflectionImage = new ReflectionImage();
			reflection.style = style;
			return reflection;
		}

		private function mockFrame():FramedCoverFlowImage {
			return new FramedCoverFlowImage();
		}

		private function mockGeometry():void {
			mock( geometry );
		}

		private function createDummyBitmap():Bitmap {
			return new Bitmap( new BitmapData( 150, 150, false, 0 ) );
		}

		private function mockForFailure():void {
			mock( injector ).method( "getInstance" ).never();
			factory = new CoverFlowImageFactory();
			factory.injector = injector;
		}

		private function areAllCoverFlowImages( result:Array ):Boolean {
			var correct:Boolean = true;
			var i:int = -1;
			while( ++i<result.length ) {
				correct = result[i] is CoverFlowImage ? correct : false;
			}
			return correct;
		}

		public function bitmapArgs():Array {
			var args:Array = [null, "auto", true];
			return args;
		}

		[After]
		public function tearDown():void {
			factory = null;
		}
	}
}
