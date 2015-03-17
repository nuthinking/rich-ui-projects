class ChartItem extends MovieClip
{
	public var label:String;
	public var data:Number;
	
	private var label_txt:TextField;
	private var data_w_txt:TextField;
	private var data_b_txt:TextField;
	private var mask_mc:MovieClip;
	private var bar_mc:MovieClip;
	private var data_masked_mc:MovieClip;
	private var bg_mc:MovieClip;
	
	private var barWidth:Number;
	public var orderIndex:Number;
	private var inited:Boolean = false;
	private var bgColor:Color;
	
	function ChartItem(){
		label_txt.htmlText = label;
		data_w_txt = data_masked_mc.data_w_txt;
		data_w_txt.text = data_b_txt.text = data.toString();
		barWidth = Math.floor(data * _parent.scaleFactor);
		bar_mc._width = mask_mc._width = 0;
		data_masked_mc.setMask(mask_mc);
		_alpha = 0;
		_x = 200;
		bgColor = new Color(bg_mc);
		
	}
	function compone(Void):Void
	{
		scaleBar(barWidth);
		var a = _alpha;
		this.onEnterFrame = function(){
			a+=(100-a)*.3;
			_x+=(0-_x)*.2;
			if(Math.round(a)==100 && Math.round(_x)==0){
				delete this.onEnterFrame;
				init();
			}
			_alpha = a;
		}
	}
	function init(Void):Void
	{
		_alpha=100;
		_x = 0;
		this.onRollOver = function(){
			rolla();
		}
		this.onRollOut = this.onReleaseOutside = function(){
			srolla();
		}
		this.onRelease = function(){
			clicca();
		}
		inited = true;
	}
	function rolla(Void):Void
	{
		bgColor.setRGB(0xE5E5E5);
	}
	function srolla(Void):Void
	{
		bgColor.setRGB(0xFFFFFF);
	}
	function clicca(Void):Void
	{
		this.enabled = false;
		srolla();
		hideMe();
	}
	function scaleBar(w:Number):Void
	{
		var speed = .2;
		bar_mc.onEnterFrame = function(){
			this._width += (w-this._width)*speed;
			if(Math.round(this._width) == w){
				this._width = w;
				delete this.onEnterFrame;
			}
			this._parent.mask_mc._width = this._width;
		}
	}
	function changePos(y:Number):Void
	{
		if(!inited){
			scaleBar(barWidth);
			init();
		}
		this.onEnterFrame = function(){
			_y += (y-_y)*.3;
			if(Math.round(_y) == y){
				delete this.onEnterFrame;
				_y = y;
			}
		}
	}
	function hideMe(Void){
		var a = this._alpha;
		this.onEnterFrame = function(){
			a+=(0-a)*.5;
			if(Math.round(a)==0){
				delete this.onEnterFrame;
				a = 0;
				hided();
			}
			_alpha = a;
		}
	}
	function hided(Void):Void
	{
		/* When the item has disappeard, I update the menu to re-activate it and I move
		* it to avoid conflicts. I could have disable it easilty but this appeard to me
		* as the simplest way considering that the position where they will appear will
		* be defined later.
		*/
		_y = -2000;
		_parent.removedItem(this);
	}
}