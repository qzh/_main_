package tile.render
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import spark.components.supportClasses.GroupBase;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	import tile.managers.Director;
	
	public final class StarlingRoot extends GroupBase
	{
		private var mStarling:Starling;
		private var viewport:Rectangle;
		
		public function StarlingRoot(viewport:Rectangle)
		{
			this.viewport = viewport; 
			
			if (stage) start();
			else addEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:flash.events.Event):void
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
			start();
		}
		
		private function start():void
		{
			Starling.multitouchEnabled = true; // for Multitouch Scene
			Starling.handleLostContext = true; // required on Windows, needs more memory
			
			Director.getInstance().screenWidth = viewport.width;
			Director.getInstance().screenHeight = viewport.height;
			
			mStarling = new Starling(RootScene, stage, viewport);
			mStarling.simulateMultitouch = true;
			mStarling.enableErrorChecking = true;
			mStarling.start();
			
			// this event is dispatched when stage3D is set up
			mStarling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
		}
		
		private function onRootCreated(event:starling.events.Event, game:RootScene):void
		{
			var s:MapScene = new MapScene();
			Director.getInstance().startup(game, s);
		}
	}
}