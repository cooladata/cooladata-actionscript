package
{
	import flash.text.TextFormat;
	
	import feathers.controls.Label;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.themes.MetalWorksDesktopTheme;
	
	public class CustomMetalWorksTheme extends MetalWorksDesktopTheme
	{
		public function CustomMetalWorksTheme(scaleToDPI:Boolean=true)
		{
			super();
		}
		
		override protected function initializeStyleProviders():void
		{
			super.initializeStyleProviders(); // don't forget this!
			
			getStyleProviderForClass( Label )
			.setFunctionForStyleName( "header-label", setHeaderLabelStyles );
		}
		
		private function setHeaderLabelStyles( label:Label ):void
		{
			label.textRendererFactory = function():ITextRenderer
			{
				var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
				textRenderer.textFormat = new TextFormat( "Arial", 34, 0xffffff );
				return textRenderer;
			}
		}
	}
}