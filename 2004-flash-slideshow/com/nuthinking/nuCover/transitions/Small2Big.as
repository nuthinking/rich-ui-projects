class com.nuthinking.nuCover.transitions.Small2Big
{
	static function makeMask(mc:MovieClip,shape:String,speed:Number,angle:Number):Void
	{
		//trace("fn makeSmall2Big");
		mc.count = 0;
		mc.finito = false;
		mc.fact=1+(speed/40);
		mc.onEnterFrame = function()
		{
			var c=this.attachMovie(shape,"shape"+this.count,this.count++);
			c._width=c._height=2;
			c._rotation=angle;
			c._x=Math.random()*this._parent._parent._parent.width;
			c._y=Math.random()*this._parent._parent._parent.height;
			c.onEnterFrame=function()
			{
				this._xscale*=this._parent.fact;
				this._yscale=this._xscale;
				if(this._parent.finito) delete this.onEnterFrame;
			}
			if(this.count>=300/speed)
			{
				//trace("fx finito");
				this.finito=true;
				this._parent._parent._parent.swapImage(this._parent);
				mc._parent.finito=true;
				delete this.onEnterFrame;
			}
		}
	}
}