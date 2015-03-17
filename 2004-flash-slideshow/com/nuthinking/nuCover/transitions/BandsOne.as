class com.nuthinking.nuCover.transitions.BandsOne
{
	static function makeMask (mc:MovieClip, speed:Number, angle:Number):Void
	{
		//trace ("fn makeBands");
		var nBands = Math.ceil (speed / 2);
		//
		if(angle<-45) angle=-(angle%45);
		if(angle>45) angle=angle%45;
		//
		var pHeight = mc._parent._parent._parent.height;
		var pWidth = mc._parent._parent._parent.width;
		var portion = pWidth/nBands;
		//
		var senso:Number;
		//
		var countF=0;
		for (var i = 0; i < nBands; i++) {
			var b=mc.attachMovie ("__rect", "banda" + i, i)
			var fact=100/20;
			var segno=angle/Math.abs(angle);
			var rad=angle*Math.PI/180*segno;
			var cosa=Math.cos(rad);
			var sina=Math.sin(rad);
			//
			b._width=1;
			b._rotation=angle;
			var l=b._xscale/fact;
			var h = sina*l;
			if(angle>0)b._y=-h;
			var cat=(-b._y+pHeight)/cosa;
			angle!=0 ? b._yscale=Math.sqrt((cat*cat)+(h*h))*fact : b._height=pHeight;
			b.xf=(portion*i)+Math.random()*portion;
			//
			senso = Math.random()*1>0.5 ? 1 : -1;
			senso==1 ? b._x=pWidth+50 : b._x=-50;
			//
			b.onEnterFrame=function(){
				var w=this._width;
				this._xscale+=this._xscale*speed/50;
				this._x+=(this.xf-this._x)/15;
				this._x -= (this._width-w)/2;
				//
				var l=this._xscale/fact;
				var h=sina*l;
				if(angle>0)this._y=-h;
				var cat=(h+pHeight)/ cosa;
				this._yscale=Math.sqrt((cat*cat)+(h*h))*fact;
				if(l>=pWidth*3){
					countF++;
					if(countF>=nBands){
						mc._parent._parent._parent.swapImage(mc._parent);
						mc._parent.finito=true;
					}
					delete this.onEnterFrame;
				}
			}
		}
	}
}
