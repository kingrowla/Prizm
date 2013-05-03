/******************************************************
DoorCounter.as 
@author Joseph Terrell
@version n/a
@Date 01-09-13
NOTES: hits.fla in document class
DESC: Finds all doors on stage with instances of the
name "door" grabs their positions then builds an xml
file by clicking a button. We can also grab all doors
that do not have instance name by using their lib linkage
******************************************************/
package game.scenes.counter.mainStreet{
	import flash.display.*;
	import flash.utils.ByteArray;
    import flash.net.FileReference;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class DoorCounter extends MovieClip{	
		public var doorXML:XML;
		private var _doorXML:XML
		public function DoorCounter(){
			/*DoorCounter is imported into the hits.fla document class to dynamically
			count doors and their positions. The results are then ouput to the output window as xml to copy
			or you can click the generate XML button to build a quick xml of all the doors on the stage*/
			doorXML = doorParameters();
			trace("----------------------------------------XML--------------------------------------------");
			trace(doorXML);
			xmlBuildBtn.addEventListener(MouseEvent.CLICK, mClick);
		}
		private function doorParameters():XML{
			var doorParams:Array = [];
			for(var i:int = 0;i<this.numChildren;i++){
				if(getChildAt(i).name.substr(0,4) == "door"){
					var door:Object = getChildAt(i);
					doorParams.push({type:door, name:door.name, id:Number(door.name.substr(4,3)), xPos:door.x, yPos:door.y});
				}
				/*if(getChildAt(i) is ExitClick){
					//we can use this if instance names were not named and had library linkage of ExitClick//
				}*/
			}
			//end for//
			//build xml file root node//
			_doorXML = <doors></doors>;
			//will sort in order as long as long as it doesn't go past "door999"//
			doorParams.sortOn("id", Array.NUMERIC);
			for each(var d:Object in doorParams){
				if(d.type.scaleX > 1){
					trace(d.name+ " is scaled above 100%. It's Scale is "+Math.round(d.type.scaleX *100)+"%");
				}
				//build XML file below//
				_doorXML.appendChild(<door>
									<id>{d.name}</id>
									<scene>main street</scene>
									<x>{d.xPos}</x>
									<y>{d.yPos}</y>
									<direction></direction>
									<label>
										<text>Exit</text>
										<asset>exitPointer3D.swf</asset>
										<offset>
										<x>0</x>
										<y>0</y>
										</offset>
									</label>
								</door>);
           
			}
			return _doorXML;
		}
		//write xml//
		private function mClick(evt:MouseEvent):void{
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(_doorXML);
			var fr:FileReference = new FileReference();
			fr.addEventListener(Event.SELECT, _onRefSelect);
			fr.addEventListener(Event.CANCEL, _onRefCancel);
			fr.save(ba, "doors.xml");
		}
		private function _onRefSelect(evt:Event):void{
			trace('button selected');
		}
		private function _onRefCancel(evt:Event):void{
			trace('cancel');
		}
	}
}