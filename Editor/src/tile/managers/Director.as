package tile.managers
{
	import tile.render.RootScene;
	import tile.render.Scene;

	public final class Director
	{
		private var root:RootScene;
		
		public var runningScene:Scene;
		
		public var screenWidth:int;
		public var screenHeight:int;
		
		private static var _instance:Director;
		public function Director()
		{
		}
		
		public static function getInstance():Director
		{
			if(!_instance)_instance = new Director();
			return _instance;
		}
		
		public function replaceScene(scene:Scene):void
		{
			if(runningScene)
			{
				runningScene.onExit();
				runningScene.parent.removeChild(runningScene, true);
			}
			
			this.runningScene = scene;
			
			if(runningScene)
			{
				this.root.addChild(runningScene);
				runningScene.onEnter();
			}
		}
		
		public function startup(root:RootScene, game:Scene):void
		{
			this.root = root;
			this.replaceScene(game);
		}
	}
}