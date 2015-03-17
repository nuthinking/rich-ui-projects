import com.nuthinking.nuCover.transitions.Small2Big;
import com.nuthinking.nuCover.transitions.BandsOne;
import com.nuthinking.nuCover.transitions.FF_Composition;
import com.nuthinking.nuCover.transitions.CT_Composition;
import com.nuthinking.nuCover.transitions.TriBand;
import com.nuthinking.nuCover.transitions.Rainfall;
import com.nuthinking.nuCover.transitions.Waterfall;
import com.nuthinking.nuCover.transitions.Arches;
import com.nuthinking.nuCover.transitions.Lines;
//
class com.nuthinking.nuCover.Cover_mask extends MovieClip
{
	private var finito : Boolean = true;
	var count : Number = 0;
	//
	function Cover_mask(){
	}
	//
	//-- P U B L I C   M E T H O D S --------------------
	//
	public function clear(Void):Void{
		//trace("clear");
		this.onEnterFrame=undefined;
		for(var i in this){
			if(typeof this[i]=="movieclip"){this[i].removeMovieClip();}
		}
	}
	public function makeMask(kind:Number,speed:Number,angle:Number):Void{
		_parent.startMask(this._parent);
		//trace("makeMask: "+kind);
		if(kind<0){
			kind=Math.floor(Math.random()*10);
			angle=Math.random()*90-45;
			if(kind>9) kind=9;
		}
		switch(kind){
			case 0:
				com.nuthinking.nuCover.transitions.Small2Big.makeMask(this,"__cerchio",speed,angle);
				return;
			case 1:
				com.nuthinking.nuCover.transitions.Small2Big.makeMask(this,"__quadrato",speed,angle);
				return;
			case 2:
				com.nuthinking.nuCover.transitions.BandsOne.makeMask(this,speed,angle);
				return;
			case 3:
				com.nuthinking.nuCover.transitions.FF_Composition.makeMask(this,speed,angle);
				return;
			case 4:
				com.nuthinking.nuCover.transitions.CT_Composition.makeMask(this,speed);
				return;
			case 5:
				com.nuthinking.nuCover.transitions.TriBand.makeMask(this,speed);
				return;
			case 6:
				com.nuthinking.nuCover.transitions.Rainfall.makeMask(this,speed);
				return;
			case 7:
				com.nuthinking.nuCover.transitions.Waterfall.makeMask(this,speed);
				return;
			case 8:
				com.nuthinking.nuCover.transitions.Arches.makeMask(this,speed);
				return;
			case 9:
				com.nuthinking.nuCover.transitions.Lines.makeMask(this,speed,angle);
				return;
			default:
				trace("default");
		}
	}
	//
	//-- P R I V A T E   M E T H O D S --------------------
	//

}