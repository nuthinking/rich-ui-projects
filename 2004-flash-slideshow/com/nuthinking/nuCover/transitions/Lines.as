class com.nuthinking.nuCover.transitions.Lines
{
	static function makeMask (mc:MovieClip, speed:Number, angle:Number):Void
	{
		//trace ("fn makeBands");
		//
		var pHeight = mc._parent._parent._parent.height;
		var pWidth = mc._parent._parent._parent.width;
		var yi = pHeight/2;
		var xi = pWidth/2;
		//
		var count=0;
		var distanzaX = 0;
		var distanzaY = 0;
		//
		var b=mc.attachMovie ("__quadrato", "banda" + count, count++);
		b._x=xi;
		b._y=yi;
		b._width = pWidth;
		b._height = 0;
		//b._rotation = angle;
		b.onEnterFrame=function(){
			this._yscale+=(52-this._yscale)/(vel*2);
			if(this._yscale>=51)delete this.onEnterFrame;
		}
		var vel=3-(speed/5);
		var counter=0;
		//
		mc.onEnterFrame=function(){
			counter++;
			if(counter>=vel){
				counter=0;
				distanzaY += 10;
				//distanzaX += dx;
				//
				var b=mc.attachMovie ("__quadrato", "banda" + count, count++);
				b._x=xi;
				b._y=yi+distanzaY;
				b._width = pWidth;
				b._height = 0;
				//b._rotation = angle;
				//
				b.onEnterFrame=function(){
					this._yscale+=(52-this._yscale)/(vel*2);
					if(this._yscale>=51)delete this.onEnterFrame;
				}
				//
				var b=mc.attachMovie ("__quadrato", "banda" + count, count++);
				b._x=xi;
				b._y=yi-distanzaY;
				b._width = pWidth;
				b._height = 0;
				//b._rotation = angle;
				//
				b.onEnterFrame=function(){
					this._yscale+=(52-this._yscale)/(vel*2);
					if(this._yscale>=51){
						if(this.last)mc._parent._parent._parent.swapImage(mc._parent);
						delete this.onEnterFrame;
					}
				}
				if(distanzaY>pHeight/2){
					b.last=true;
					delete this.onEnterFrame;
				}
			}
		}
	}
}
