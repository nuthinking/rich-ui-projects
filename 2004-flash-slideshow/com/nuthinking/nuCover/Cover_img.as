import com.nuthinking.nuCover.Cover_mask;

class com.nuthinking.nuCover.Cover_img extends MovieClip
{
	private var mask_mc : Cover_mask;
	private var img_mc : MovieClip;
	//
	private var image : String;
	private var effect : Number;
	private var speed : Number;
	private var angle : Number;
	//
	public var finito : Boolean = false;
	//
	function Cover_img(){
		loadImage();
		trace("Creato: "+this);
	}
	//
	private function loadImage():Void{
		var mc=img_mc;
		var mask=mask_mc
		var loaded=false;
		mc.loadMovie(this.image);
		if(this._parent.loading!="no"){
			this.attachMovie("loading_mc","loading_mc",1);
		}
		var l=this.createEmptyMovieClip("loader_mc",100);
		l.onEnterFrame=function(){
			if(this._parent._parent.loading!="no"){
				var perc=(mc.getBytesLoaded()/mc.getBytesTotal())*100;
				this._parent.loading_mc.setStatus(perc);
			}
			if(mc.getBytesTotal()>10 && mc.getBytesLoaded()>=mc.getBytesTotal()){
				if (loaded==false){
					//trace("caricato");
					this._parent.loading_mc.onLoad();
					loaded=true;
				}
				if(this._parent._parent._parent.ready){
					this._parent.clearMask();
					mask.makeMask(this._parent.effect,this._parent.speed,this._parent.angle);
					this.removeMovieClip();
				}
			}
		}
	}
	public function clearMask(Void):Void{
		mask_mc.clear();
	}
}