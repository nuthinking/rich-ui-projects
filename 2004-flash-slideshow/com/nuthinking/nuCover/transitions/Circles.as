class com.nuthinking.nuCover.transitions.Circles
{
	static function makeMask(mc:MovieClip):Void
	{
		trace("fn makeCircles");
		mc.count = 0;
		mc.finito = false;
		mc.onEnterFrame = function()
		{
			var c=this.attachMovie("cerchio","cerchio"+this.count,this.count++);
			c._width=c._height=5;
			c._x=Math.random()*this._parent._parent.width;
			c._y=Math.random()*this._parent._parent.height;
			c.onEnterFrame=function()
			{
				this._xscale*=1.2;
				this._yscale=this._xscale;
				if(this._parent.finito) delete this.onEnterFrame;
			}
			if(this.count>=30)
			{
				trace("fx finito");
				this.finito=true;
				this._parent._parent.swapImage();
				delete this.onEnterFrame;
			}
		}
	}
}