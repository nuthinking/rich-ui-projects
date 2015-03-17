class com.nuthinking.nuCover.transitions.Rainfall
{
	static function makeMask (mc:MovieClip, speed:Number, angle:Number):Void
	{
		//trace ("fn makeBands");
		//var nBands = Math.ceil (speed / 2);
		//
		if(angle<-45) angle=-(angle%45);
		if(angle>45) angle=angle%45;
		//
		var pHeight = mc._parent._parent._parent.height;
		var pWidth = mc._parent._parent._parent.width;
		var portion = Math.max(20,pWidth/20);
		//
		var laX=0;
		var count=0;
		var strisce=[];
		while(laX<pWidth){
			var b=mc.attachMovie ("__rect", "banda" + count, count++);
			strisce.push(b);
			b._x=laX;
			b._width=portion;
			b._height=pHeight;
			b._y=-b._height;
			laX+=portion;
		}
		var countF=0;
		var motion=function(){
			this._y+=(0-this._y)/10;
			if(this._y>-0.1){
				//trace("arrivato");
				this._y=0;
				countF++;
				delete this.onEnterFrame;
				if(countF>=count){
					mc._parent._parent._parent.swapImage(mc._parent);
				}
			}
		}
		var distance=0;
		var startLine=Math.floor(Math.random()*strisce.length);
		strisce[startLine].onEnterFrame=motion;
		strisce.splice(startLine,1);
		mc.onEnterFrame=function(){
			if(strisce.length>0){
				startLine=Math.floor(Math.random()*strisce.length);
				strisce[startLine].onEnterFrame=motion;
				strisce.splice(startLine,1);
			}else{
				delete this.onEnterFrame;
			}
		}
	}
}
