/*
Class Cover_cgws

Interface Paramethers:
	- images (Array of Images);
	- effect (Kind of effect);
	- speed (speed of the effect);
	- angle (angle of the objects in the effect);
	- slideshow(Boolean)
	- pause (Number)
	- fx (Number)
	- loading

*/

import com.nuthinking.nuCover.Cover_img;
[InspectableList("images","effect","speed","angle","slideshow","pause","fx","loading")]

class com.nuthinking.nuCover.Cover_cgws extends MovieClip
{
	var mask1_mc:MovieClip;
	var mask2_mc:MovieClip;
	var immagini_mc:Cover_img;
	var sfondo_mc:MovieClip;
	var box_mc:MovieClip;
	//--	Private Attributes
	private var __width:Number;
	private var __height:Number;
	private var __images:Array;
	private var __effect:Number;
	private var __speed:Number;
	private var __angle:Number;
	private var __index:Number = 0;
	private var __slideshow : Boolean;
	private var __pause : Number;
	private var __fx : Number;
	private var __loading : String;
	//
	private var __nextLevel : Number = 0;
	//private var __levels : Array = [];
	//private var __2remove : MovieClip;
	private var __wait : Boolean = false;
	private var __livelloTemp : Number;
	//
	public var ready : Boolean = true;
	//
	function Cover_cgws ()
	{
		__width = this._xscale * 5;
		__height = this._yscale * 2;
		//
		mask1_mc._width = __width;
		mask2_mc._width = __width;
		mask1_mc._height = __height;
		mask2_mc._height = __height;
		_xscale = _yscale = 100;
		box_mc._visible = false;
		stop ();
		if(__images[0]!=undefined) loadIndex(0);
	}
	//-- P U B L I C   M E T H O D S ----------------------------
	public function loadIndex(i:Number):Void
	{
		trace("loadIndex: "+__images[i]);
		if(i<__images.length){
			var obj={image:__images[i],effect:effect,speed:speed,angle:angle,livello:__nextLevel}
			var mc=immagini_mc.attachMovie("Cover_img","Cover_"+__nextLevel,__nextLevel,obj);
			//
			//__levels.push({movie:mc,image:__images[i],level:__nextLevel});
			__nextLevel++;
			ready = true;
		}
	}
	public function loadImage (img:String):Void
	{
		trace("loadImage: "+img);
		__wait=true;
		var obj={image:img,effect:effect,speed:speed,angle:angle,livello:__nextLevel}
		var mc=immagini_mc.attachMovie("Cover_img","Cover_"+__nextLevel,__nextLevel,obj);
		//
		//__levels.push({movie:mc,image:img,level:__nextLevel});
		__nextLevel++;
		ready = true;
	}
	public function swapImage (mc:MovieClip):Void
	{
		trace("fn swapImage");
		sfondo_mc.loadMovie (mc.image);
		__livelloTemp=mc.livello;
		//__2remove=mc;
	}
	public function startMask(mc:MovieClip):Void
	{
		//mc==this.img1_mc ? __mask1IsComposing = true : __mask2IsComposing = true;
	}
	private function swapped (Void):Void
	{
		trace ("fn swapped");
		clearLevels(__livelloTemp);
		if(__livelloTemp==__nextLevel-1) clearMovies();
		if(slideshow && !__wait){
			loadNext();
			startCount();
		}
	}
	//-- P R I V A T E   M E T H O D S --------------------------
	private function clearMovies(Void):Void
	{
		trace("*** Clear Movies ***");
		for (var i in immagini_mc){
			if(typeof immagini_mc[i]=="movieclip") immagini_mc[i].removeMovieClip();
		}
		__nextLevel=0;
	}
	private function clearLevels(liv:Number):Void
	{
		trace("clearLevels");
		for (var i in immagini_mc){
			if(typeof immagini_mc[i]=="movieclip"){
				if(immagini_mc[i].livello<liv) immagini_mc[i].removeMovieClip();
			}
		}
	}
	private function startCount(Void):Void
	{
		trace("startCount");
		ready = false;
		var t = getTimer();
		this.onEnterFrame=function(){
			if(getTimer()>=t+__pause){
				delete this.onEnterFrame;
				ready = true;
			}
		}
	}
	private function loadNext(Void):Void
	{
		index++;
		loadIndex(index);
	}
	private function makeFX(Void):Void
	{
		trace("makeFX");
	}
	//-- Inspectable Properties ------------------------------
	//   I M A G E S
	[Inspectable( type="Array", defaultValue="img_0.jpg,img_1.jpg,img_2.jpg,img_3.jpg,img_4.jpg")]
	public function set images (i:Array):Void
	{
		__images = i;
		if(__images[0]!=undefined) loadIndex(0);
	}
	public function get images ():Array{return __images;}
	//   E F F E C T S (1 to ?)
	[Inspectable( type="Number", defaultValue=0)]
	public function set effect (e:Number):Void{__effect = e;}
	public function get effect ():Number{return __effect;}
	//	S P E E D   (1 to 10)
	[Inspectable( type="Number", defaultValue=5)]
	public function set speed (s:Number):Void{
		if(s<1) s=1;
		if(s>10) s=10;
		__speed = s;
	}
	public function get speed ():Number{return __speed;}
	//	A N G L E
	[Inspectable( type="Number", defaultValue=0)]
	public function set angle (a:Number):Void{__angle = a;}
	public function get angle ():Number{return __angle;}
	//	S L I D E S H O W
	[Inspectable( type="Boolean", defaultValue=true)]
	public function set slideshow (s:Boolean):Void{__slideshow = s;}
	public function get slideshow ():Boolean{return __slideshow;}
	//	P A U S E
	[Inspectable( type="Number", defaultValue=2000)]
	public function set pause (p:Number):Void{__pause = p;}
	public function get pause ():Number{return __pause;}
	//	F X
	[Inspectable( type="Number", defaultValue=0)]
	public function set fx (f:Number):Void{__fx = f;}
	public function get fx ():Number{return __fx;}
	//  L O A D I N G
	[Inspectable( type="String", defaultValue="no")]
	public function set loading (s:String):Void{__loading = s;}
	public function get loading ():String{return __loading;}
	//--------------------------------------------------------------
	//   W I D T H
	public function set width (w:Number):Void
	{
		__width = w;
		mask1_mc._width = w;
		mask2_mc._width = w;
	}
	public function get width ():Number{return __width;}
	//  H E I G H T
	public function set height (h:Number):Void
	{
		__height = h;
		mask1_mc._height = h;
		mask2_mc._height = h;
	}
	public function get height ():Number{return __height;}
	public function set index(i:Number):Void
	{
		if(i>=__images.length){
			trace("loop");
			__index=0;
		}else{
			__index=i;
		}
	}
	public function get index():Number{return __index;}
}
