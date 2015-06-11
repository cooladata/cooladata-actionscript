package
{
	import flash.display.Sprite;
	
	import starling.core.Starling;
	
	[SWF (height="800", width="1024")] 
	public class CooladataTest extends Sprite
	{
		private var _starling:Starling;
		
		public function CooladataTest()
		{
			_starling = new Starling(CooladataTesterGUI, stage);
			_starling.start();

		}
	}
}