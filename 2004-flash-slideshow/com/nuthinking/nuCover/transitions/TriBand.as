class com.nuthinking.nuCover.transitions.TriBand
{
	static function makeMask (mc:MovieClip, speed:Number):Void
	{
		//trace ("fn makeTriBand");
		//
		var pHeight = mc._parent._parent._parent.height;
		var pWidth = mc._parent._parent._parent.width;
		//
		var countF=0;
		var h=Math.ceil(pHeight/3);
		var senso=0;
		var b=mc.attachMovie ("__rect", "banda1", 1);
		b._height=h;
		b._width=0;
		b.onEnterFrame=function(){
			this._xscale+=50+speed*20;
			if(this._width>=pWidth){
				delete this.onEnterFrame;
				b=mc.attachMovie ("__rect", "banda2", 2);
				b._height=h;
				b._width=0;
				b._x=pWidth;
				b._y=h;
				b.onEnterFrame=function(){
					b._xscale-=50+speed*20;
					if(this._width>=pWidth){
						delete this.onEnterFrame;
						b=mc.attachMovie ("__rect", "banda3", 3);
						b._height=h;
						b._width=0;
						b._y=2*h;
						b.onEnterFrame=function(){
							this._xscale+=50+speed*20;
							if(this._width>=pWidth){
								delete this.onEnterFrame;
								this._parent._parent._parent._parent.swapImage(this._parent._parent);
								mc._parent.finito=true;
							}
						}
					}
				}
			}
		}
	}
}
