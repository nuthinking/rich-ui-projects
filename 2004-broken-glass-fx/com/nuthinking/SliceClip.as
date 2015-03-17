class com.nuthinking.SliceClip extends MovieClip
{
	var symbol:String;
	var scale:Number;
	private var img:MovieClip;
	private var mask:MovieClip;
	private var corners_array:Array;
	private var slice_array:Array;
	private var factor:Number;
	private var automatic:Boolean=true;
	private var time:Number;
	//
	private var __symbol:String;
	private var __scale:Number;
	private var __factor:Number;
	//
	function SliceClip()
	{
		__symbol=this.symbol;
		__scale=this.scale;
		__factor=this.factor;
		this.img=this.createEmptyMovieClip("img_mc",0);
		this.mask=this.createEmptyMovieClip("mask_mc",1);
		this.img.attachMovie(this.symbol,"symbol_mc",0);
		this._xscale=this._yscale=this.scale;
		var offsetX=(this._width-this.img._width)/2;
		var offsetY=(this._height-this.img._height)/2;
		this._x-=offsetX;
		this._y-=offsetY;
		//trace(offsetX+" : "+offsetY);
		this.img.setMask(this.mask);
		this.corners_array=[[0,0],[0,0],[0,0],[0,0]];
		this.slice_array=[[0,0],[0,0],[0,0],[0,0]];
		this.init();
		//setSlice([[0,0],[100,0],[100,100],[0,100]],5);
		this.randomMask();
	}
	public function setSlice(s_array:Array,fact:Number)
	{
		//trace("setSlice: "+s_array[0][0]+" , "+s_array[0][1]);
		for(var i=0; i<4; i++){
			this.slice_array[i][0]=s_array[i][0];
			this.slice_array[i][1]=s_array[i][1];
		}
		this.factor=fact;
		this.onEnterFrame=function(){
			this.calculateMask();
			this.drawMask();
		}
	}
	private function init(Void):Void{

	}
	private function randomMask(Void):Void
	{
		var t_array:Array=new Array([0,0],[0,0],[0,0],[0,0]);
		for(var i=0; i<4; i++){
			t_array[i][0]=Math.random()*this.img._width;
			t_array[i][1]=Math.random()*this.img._height;
		}
		this.setSlice(t_array,(Math.random()*__factor/2)+(__factor/2));
	}
	private function calculateMask(Void):Void
	{
		var arrived:Boolean=true;
		var dx,dy;
		for(var i=0; i<4; i++){
			dx=Math.abs(this.slice_array[i][0]-this.corners_array[i][0]);
			dy=Math.abs(this.slice_array[i][1]-this.corners_array[i][1]);
			//trace(dx+" : "+dy);
			if(dx>0.1 && dy>0.1) arrived=false;
			this.corners_array[i][0]+=(this.slice_array[i][0]-this.corners_array[i][0])/this.factor;
			this.corners_array[i][1]+=(this.slice_array[i][1]-this.corners_array[i][1])/this.factor;
		}
		if(arrived){
			//delete this.onEnterFrame;
			this.automatic ? this.randomMask() : delete this.onEnterFrame;
		}
	}
	private function drawMask(Void):Void
	{
		this.mask.clear();
		this.mask.beginFill(0x000000)
		this.mask.moveTo(this.corners_array[0][0],this.corners_array[0][1]);
		for(var i=0; i<4; i++){
			this.mask.lineTo(this.corners_array[i][0],this.corners_array[i][1]);
		}
		this.mask.endFill();
	}
}