class com.nuthinking.nuCover.transitions.Chess
{
	static function makeMask (mc:MovieClip, speed:Number):Void
	{
		//trace ("fn makeChess");
		//
		var pHeight = mc._parent._parent._parent.height;
		var pWidth = mc._parent._parent._parent.width;
		//
		var h = Math.ceil(pHeight/10);
		if(h<30)h=30;
		var scalaF=h*10;
		var nBands = Math.ceil(pHeight/h);
		var nCol = Math.ceil(pWidth/(h*2))+1;
		//
		var laX=0;
		var laY=0;
		var count=0;
		var countF=0;
		var senso=0;
		//
		for(var i=0; i<nCol; i++){
			for(var j=0; j<nBands; j++){
				var c=mc.attachMovie("__rect","banda"+count,count++);
				c._width=0;
				c._height=h;
				c._x=c.xi=laX;
				c._y=laY;
				//
				c.onEnterFrame=function(){
					this._width+=1+(speed/2);
					if(this._width>h) this._x=this.xi-(this._width-h);
					if(this._width>=h*2){
						delete this.onEnterFrame;
						countF++;
						if(countF>=count){
							this._parent._parent._parent._parent.swapImage(this._parent._parent);
							mc._parent.finito=true;
						}
					}
				}
				//
				laX+=h*2;
				if(laX>=pWidth+h){
					if(senso==0){
						laX=-h;
						senso=1;
					}else{
						laX=0;
						senso=0;
					}
					laY+=h;
					if(laY>=pHeight) break;
				}
			}
		}
	}
}
