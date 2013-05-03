package utils  {
	import flash.net.URLRequest;
	import flash.display.*;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.geom.Matrix;
	import com.caurina.transitions.*;
	import utils.ContentTextField;
	
	public class ContentLoader extends MovieClip{
		private var container:Sprite;
		private var imageLoader:Loader;
		//position we want our images loaded to//
		public static var stageY:Number = 125;
		//area of right margin of loaded area//
		public static var stageBR:Number = 30; //begin loaded area//
		public static var stageXR:Number = 990;//end loaded area//
		public static var maxHeight:Number = 560;
		public static var stageXPadding:Number = 7;
		private var loadedContentWidth:Number;
		private var loadedContentHeight:Number;
		private var imagePositioning:String; 
		public var contentText:String;
		private var txtField:ContentTextField = new ContentTextField();
		
		public function ContentLoader() {
			// constructor code
		}
		public function loadImage(url:String, pos:String):void {
			if(imageLoader != null){
				//here the the Loader object already exists, 
				//we remove the container which loaded it
				//memory optimization purposes//
			  	removeChild(container);
				removeChild(txtField);
			}
			imagePositioning = pos;
			container = new Sprite();
			container.name = "container";
			imageLoader = new Loader();
			//if image tag is blank just load the text, if has an images skip down to else//
			if(url == ""){
				//addChild(txtField);
				//txtField.setAttributes((stageXR - container.width) - (stageBR + stageXPadding),container.height,stageBR+stageXPadding,stageY+stageXPadding);
				//txtField.loadText(contentText);
				
			}
			else{
				imageLoader.load(new URLRequest(url));
				imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, imageLoading);
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			}
		}
		private function imageLoaded(evt:Event):void {
			addChild(container);
			//below was for images//
			loadedContentHeight = LoaderInfo(evt.target).content.height;
			loadedContentWidth = LoaderInfo(evt.target).content.width;
			var temp:BitmapData = new BitmapData(loadedContentWidth, loadedContentHeight);
            temp.draw(LoaderInfo(evt.target).content);
			//this gives us a decimial to work with for scaling, takes the greater measurement that is out of bounds//
			var tempMeasure:Number = maxHeight / loadedContentHeight;
            var output:BitmapData = new BitmapData( loadedContentWidth * tempMeasure, loadedContentHeight * tempMeasure);
            var matrix:Matrix = new Matrix();
            if(imageLoader.contentLoaderInfo.height > maxHeight){
				//if the loaded content height exceeds 560, scale it down, else don't scale//
				matrix.scale(tempMeasure, tempMeasure);
				output.draw( temp, matrix, null, null, null, true );
				temp.dispose();
				var bmp:Bitmap = new Bitmap(output);
				container.addChild(bmp);
			}
			else{
				//for images and scaling down//
				container.addChild(evt.target.content);
			}
			container.alpha = 0;
			Tweener.addTween(container, {alpha:1, time:.7, delay:.2, transition:"easeOutCubic", onComplete:maskerade});
			function maskerade(){
				//YOUR_LOADED_SWF_NAME_HERE.mask = rectangle;
				evt.target.content.mask = MovieClip(root).masker;
			}
			//positions the image//
			var poserArray:Array = positionImage(imagePositioning);
			//image had been loaded Load Image//
			container.x = poserArray[0].xPos;
			container.y = poserArray[0].yPos;
			//now that's positioned get container width and then added the text field
			addChild(txtField);
			txtField.setAttributes((stageXR - container.width) - (stageBR + stageXPadding),container.height,stageBR+stageXPadding,stageY+stageXPadding);
			txtField.loadText(contentText);
			trace("number of children in the container in containLoader.as class [ "+this.numChildren+" ]");
			trace("loaded image position on stage X:"+poserArray[0].xPos +", Y:"+poserArray[0].yPos);
			trace("container sizes width:"+container.width +", High:"+container.height);
		}
		private function imageLoading(evt:ProgressEvent):void {
		// Use it to get current download progress
		// Hint: You could tie the values to a preloader :)
		}
		private function positionImage(pos:String):Array{
			var positionArray:Array = new Array();
			switch(pos){
				case "right":
				//aligns image to right side of screen, text flows to left//
				positionArray.push({xPos:stageXR - container.width, yPos:stageY});
				break;
				case "left":
				//aligns image to left side of screen, text flows to right//
				break;
				case "top":
				//aligns image to top of screen, text flows bottom//
				break;
				case "bottom":
				//aligns image to bottom of screen, text flows top//
				break;
			}
			return positionArray;
		}

	}
	
}
