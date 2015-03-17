class com.nuthinking.nuCover.transitions.FF_Composition
{
	static function makeMask (mc:MovieClip, speed:Number, angle:Number):Void
	{
		//trace ("fn makeFF");
		//
		var pHeight = mc._parent._parent._parent.height;
		var pWidth = mc._parent._parent._parent.width;
		//
		var lato=Math.max(pHeight/(20-speed),pWidth/(20-speed));
		var fScale=((lato/20)*100)+10;
		var xi=pWidth/2;
		var yi=pHeight/2;
		var count=0;
		var cFinal=0;
		var laX=lato/2;
		var laY=laX;
		mc.onEnterFrame=function(){
			var q=this.attachMovie("__quadrato","quad"+count, count++);
			q._width=q._height=2;
			q._rotation=angle;
			q._x=xi;
			q._y=yi;
			q.xf=laX;
			q.yf=laY;
			q.onEnterFrame=function(){
				this._x+=(this.xf-this._x)/(20-speed);
				this._y+=(this.yf-this._y)/(20-speed);
				this._rotation+=(0-this._rotation)/(20-speed);
				this._xscale+=((fScale-this._xscale)/(20-speed))/1.3;
				this._yscale=this._xscale;
				//
				if(Math.round(this._xscale/3)==Math.round(fScale/3)){
					delete this.onEnterFrame;
					cFinal++;
					if(count==cFinal){
						this._parent._parent._parent._parent.swapImage(this._parent._parent);
						mc._parent.finito=true;
					}
				}
			}
			//
			laX+=lato;
			if(laX>=pWidth+lato){
				laY+=lato;
				laX=lato/2;
				if(laY>=pHeight+lato){
					//trace("fine lancio");
					delete this.onEnterFrame;
				}
			}
		}
		//
	}
}
