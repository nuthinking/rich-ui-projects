class com.nuthinking.nuCover.transitions.Arches
{
	static function makeMask (mc:MovieClip, speed:Number, angle:Number):Void
	{
		//
		var pHeight = mc._parent._parent._parent.height;
		var pWidth = mc._parent._parent._parent.width;
		//
		var t_scale=Math.max(pHeight,pWidth)*15;
		var count=0;
		mc.onEnterFrame=function(){
			var b=mc.attachMovie ("__arch", "banda" + count, count++);
			b._xscale=b._yscale=0;
			b.sf=t_scale;
			t_scale=t_scale/1.3;
			b.onEnterFrame=function(){
				var d=(this.sf-this._xscale)/20;
				this._yscale=this._xscale+=d;
				//this._yscale;
				if(Math.round(this._xscale)==Math.round(this.sf)){
					this._yscale=this._yscale=this.sf;
					//trace("arrivato");
					delete this.onEnterFrame;
				}
			}
			if(t_scale<0.01){
				trace("fine");
				mc._parent._parent._parent.swapImage(mc._parent);
				delete this.onEnterFrame;
			}
		}
	}
}
