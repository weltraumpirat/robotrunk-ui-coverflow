package org.robotrunk.ui.coverflow.impl {
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;

	import org.robotrunk.ui.core.impl.UIComponentImpl;
	import org.robotrunk.ui.coverflow.api.CoverFlow;
	import org.robotrunk.ui.coverflow.api.CoverFlowImage;
	import org.robotrunk.ui.coverflow.event.CoverFlowEvent;
	import org.robotrunk.ui.coverflow.factory.CoverFlowImageFactory;

	public class CoverFlowImpl extends UIComponentImpl implements CoverFlow {
		private var _container:Sprite;

		private var _dataProvider:*;

		private var _mask:Sprite;

		private var _viewPosition:Number;

		private var _images:Array;

		[Inject]
		public var factory:CoverFlowImageFactory;

		public function get dataProvider():* {
			return _dataProvider;
		}

		public function set dataProvider( dataProvider:* ):void {
			_dataProvider = dataProvider;
			if( dataProvider ) {
				images = factory.createFrom( _dataProvider );
			}
		}

		public function get viewPosition():Number {
			return _viewPosition;
		}

		public function set viewPosition( viewPosition:Number ):void {
			if( viewPosition != _viewPosition ) {
				_viewPosition = viewPosition;
				if( style && images ) {
					render();
				}
				dispatchEvent( new CoverFlowEvent( CoverFlowEvent.VALUE_CHANGE ) );
			}
		}

		private function render():void {
			createContainer();
			createMask();
			renderImages();
		}

		private function createContainer():void {
			container ||= new Sprite();
			addChild( container );
		}

		private function createMask():void {
			_mask ||= new Sprite();
			drawMask();
			addMaskBlur();
			applyMask();
		}

		private function drawMask():void {
			var g:Graphics = _mask.graphics;
			g.clear();
			g.beginFill( 0, 1 );
			g.drawRect( -style.width*.5, -2*style.imageWidth, style.width, 4*style.imageWidth );
			g.endFill();
		}

		private function applyMask():void {
			addChild( _mask );
			_mask.mouseEnabled = false;
			_mask.cacheAsBitmap = _container.cacheAsBitmap = true;
			_mask.blendMode = BlendMode.ALPHA;
			_container.mask = _mask;
		}

		private function addMaskBlur():Sprite {
			var blur:BlurFilter = new BlurFilter();
			blur.blurX = 160;
			_mask.filters = [blur];
			return _mask;
		}

		private function renderImages():void {
			visible = false;
			var i:int = images.length;
			while( --i>=0 ) {
				var img:CoverFlowImage = images[i];
				var disp:DisplayObject = img as DisplayObject;
				_container.addChild( disp );
				img.render( viewPosition );
			}
			visible = true;
		}

		public function get images():Array {
			return _images;
		}

		public function set images( images:Array ):void {
			_images = images;
		}

		public function get container():Sprite {
			return _container;
		}

		public function set container( container:Sprite ):void {
			_container = container;
		}

		override public function destroy():void {
			destroyFactory();
			destroyImages();
			destroyMask();
			destroyContainer();
			_dataProvider = null;
			super.destroy();
		}

		private function destroyImages():void {
			for each( var img:CoverFlowImage in images ) {
				img.destroy();
			}
			_images = null;
		}

		private function destroyFactory():void {
			factory.destroy();
			factory = null;
		}

		private function destroyMask():void {
			if( _mask && contains( _mask ) ) {
				removeChild( _mask );
			}
			_mask = null;
		}

		private function destroyContainer():void {
			if( _container && contains( _container ) ) {
				removeChild( _container );
			}
			_container = null;
		}
	}
}
