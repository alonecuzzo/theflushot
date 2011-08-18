package
{
	import flashx.textLayout.elements.OverflowPolicy;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	public class Bacterium extends Entity
	{
		[Embed(source = 'assets/bacterium.png')]
		private const BACT : Class;
		
		public function Bacterium()
		{
			graphic = new Image( BACT );
			x = FP.screen.width + 5;
			y = FP.random * FP.screen.height;
		}
		
		
		override public function update() :void
		{
			x -= .4;
			
			super.update();
		}
	}
}