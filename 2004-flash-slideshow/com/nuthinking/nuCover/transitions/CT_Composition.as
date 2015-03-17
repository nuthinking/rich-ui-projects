class com.nuthinking.nuCover.transitions.CT_Composition
{
	static function makeMask (mc:MovieClip, speed:Number):Void
	{
		//trace ("fn makeCT");
		//
		var pHeight = mc._parent._parent._parent.height;
		var pWidth = mc._parent._parent._parent.width;
		//
		var xi=pWidth/2;
		var yi=pHeight/2;
		var g = 1 / 1.418033989;
		var ga = 360 - 360 * g;
		var rgrowth = 1.02;
		var rad = 5;
		var rot = 0;
		var count = 0;
		var scale = 50;
		var c=mc.attachMovie("__quadrato","quad"+count, count++);
		c._x=xi;
		c._y=yi;
		var nCad=Math.round(speed/2)+5;
		//var laX=lato/2;
		//var laY=laX;
		mc.onEnterFrame=function(){
			for(var i=0; i<nCad; i++){
				rot += ga;
				rot -= int (rot / 360) * 360;
				//
				rad *= rgrowth;
				scale = 100 + (rad - 5) * 1.8;
				var x = xi+Math.cos (rot * Math.PI / 180) * rad;
				var y = yi+Math.sin (rot * Math.PI / 180) * rad;
				var ing = scale*0.15;
				if (y > - ing && y < pHeight + ing) {
					c = this.attachMovie ("__quadrato", "quad" + count, count++);
					c._x = x;
					c._y = y;
					c._rotation = rot;
					c._xscale = c._yscale = scale;
					if(c._x==0 && c._y==0){
						//trace(rot+" : "+rad+" : "+x+" : "+y);
					}
				}
				if (rad > 350) {
					delete this.onEnterFrame;
					//trace("fine effetto");
					this._parent._parent._parent.swapImage(this._parent);
					mc._parent.finito=true;
					i=nCad;
				}
			}
		}
		//
	}
}
