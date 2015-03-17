class Chart extends MovieClip
{
	private var chart_arr:Array;
	private var chartmc_arr:Array;
	
	private var availableWidth:Number;
	public var scaleFactor:Number;
	private var pos_arr:Array;
	private var currentOrder:String = "90";
	private var charIndex:Number;
	private var removed_arr:Array;
	private var removed_txt:TextField;
	private var next_pos:Number;
	
	function Chart(){
		// Calculate the factor which the bars will scale based on
		var maxSize = 0;
		for(var i=0; i<chart_arr.length; i++){
			if(chart_arr[i].data>maxSize) maxSize = chart_arr[i].data;
		}
		availableWidth = 420 - 133 - 5;
		scaleFactor = availableWidth / maxSize;
		
		// Instantiate the ChartItems and I instert them in an array for an easier managing
		chartmc_arr = [];
		pos_arr = [];
		var currentY = 0;
		var item,mc;
		for(var i=0; i<chart_arr.length; i++){
			item = {label:chart_arr[i].label, data:chart_arr[i].data, orderIndex:i};
			mc = this.attachMovie("chartitem_mc","item_"+i,i,item);
			mc._y = pos_arr[i] = currentY;
			currentY += mc._height-1;
			chartmc_arr.push(mc);
		}
		
		// Start the composition
		charIndex = 0;
		var delay = 5;
		var count = delay;
		this.onEnterFrame = function(){
			if(count>=delay){
				count = 0;
				componeItem(charIndex);
				charIndex++;
				if(charIndex>=chart_arr.length) delete this.onEnterFrame;
			}
			count++;
		}
		removed_arr = [];
	}
	private function componeItem (index:Number) : Void
	{
		chartmc_arr[index].compone();
	}
	public function changeOrder(newOrder:String):Void
	{
		// Function to modify the order, the options are: "90", "09", "az" and "za"
		delete this.onEnterFrame;
		switch(newOrder){
			case "90":
				/* Since the starting order is already based by the value for the following two options 
				* I simply refer to the initlial array order.
				* If we wouldn't know the starting order, the process would become similar
				* to the one used by the alphabeting sorting.
				*/
				var index = 0;
				var mc;
				for(var i=0; i<chartmc_arr.length; i++){
					mc = chartmc_arr[i];
					if(mc.enabled){
						mc.orderIndex = index;
						mc.changePos(pos_arr[index]);
						index++;
					}
				}
				next_pos = pos_arr[index];
				break;
			case "09":
				var index = 0;
				var mc;
				var len = chartmc_arr.length;
				for(var i=0; i<len; i++){
					mc = chartmc_arr[len-i-1];
					if(mc.enabled){
						mc.orderIndex = index;
						mc.changePos(pos_arr[index]);
						index++;
					}
				}
				next_pos = pos_arr[index];
				break;
			default:
				/* In this case, in fact, I found easier to create a simple array containing
				* only the values necessary to re-order the chart
				*/
				var len = chartmc_arr.length;
				var temp_arr = [];
				for(var i=0; i<len; i++){
					mc = chartmc_arr[i];
					if(mc.enabled){
						temp_arr.push(mc.label);
					}
				}
				
				// Then I re-order the temporary array
				newOrder=="az" ? temp_arr.sort() : temp_arr.sort(Array.DESCENDING);	
				
				// And I assign the new order to the list
				for(var i=0; i<len; i++){
					var mc = chartmc_arr[i];
					for(var j=0; j<temp_arr.length; j++){
						if(mc.label == temp_arr[j]){
							mc.orderIndex = j;
							mc.changePos(pos_arr[mc.orderIndex]);
						}
					}
				}
		}
		currentOrder = newOrder;
	}
	private function updateBars()
	{
		// Function called to resize the width of the bars
		var maxSize = 0;
		var mc;
		for(var i=0; i<chartmc_arr.length; i++){
			mc = chartmc_arr[i];
			if(mc.enabled){
				if(mc.data>maxSize) maxSize = mc.data;
			}
		}
		scaleFactor = availableWidth / maxSize;
		var w;
		for(var i=0; i<chartmc_arr.length; i++){
			mc = chartmc_arr[i];
			mc.barWidth = Math.floor(mc.data * scaleFactor);
			mc.scaleBar(mc.barWidth);
		}
	}
	public function removedItem(mc:MovieClip)
	{
		/* When I remove a ChartItem from the list, I've to modify the array
		* named "removed_arr" that I use to compone everytime the menu that 
		* permits to re-activate an item.
		*/
		removed_arr.push(mc.label);
		updateRemoved();
		// Then I update the list order and the size of the bars
		changeOrder(currentOrder);
		updateBars();
	}
	private function updateRemoved(){
		// I update the bottom menu
		var r_txt ="";
		for(var i=0; i<removed_arr.length; i++){
			r_txt+= '<a href="asfunction:showItem,'+removed_arr[i]+'"><i>'+removed_arr[i]+'</i></a>';
			if(i<removed_arr.length-1){
				r_txt+=", ";
			}
		}
		removed_txt.htmlText = r_txt;
	}
	private function showItem(label:String):Void
	{
		// This function removes the item from the menu and puts it in bar mode
		trace("showItem: "+label);
		for(var i=0; i<removed_arr.length; i++){
			if(removed_arr[i]==label){
				removed_arr.splice(i,1);
				break;
			}
		}
		updateRemoved();
		var mc;
		for(var i=0; i<chartmc_arr.length; i++){
			mc = chartmc_arr[i];
			if(mc.label == label){
				mc._y=next_pos;
				mc.enabled=true;
				mc._alpha=100;
				changeOrder(currentOrder);
				updateBars();
				return;
			}
		}
		
	}
}