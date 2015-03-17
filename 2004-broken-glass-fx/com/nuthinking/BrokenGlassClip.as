import com.nuthinking.SliceClip;
//
[InspectableList("symbol","range","parts","speed")]
//
class com.nuthinking.BrokenGlassClip extends MovieClip
{
	private var __symbol:String;
	private var __range:Number;
	private var __parts:Number;
	private var __speed:Number;
	private var __factor:Number;
	private var __base_mc:MovieClip;
	//
	function BrokenGlassClip()
	{
		/*trace("here I'm");
		trace("Symbol: "+__symbol);
		trace("Range: "+__range);
		trace("Parts: "+__parts);
		trace("Speed: "+__speed);*/
		init();
	}
	public function init(Void):Void
	{
		__base_mc = this.attachMovie(__symbol,"base_mc",0);
		var obj;
		var d=__range/__parts;
		for(var i=0; i<__parts; i++){
			obj={symbol:__symbol,scale:100+(d*i),factor:__factor};
			this.attachMovie("SliceClip","slice_"+i,__parts-i,obj);
		}
	}
	// P R I V A T E

	//
	//-- Inspectable Properties ------------------------------
	//
	[Inspectable( type="String", defaultValue="exported_instance")]
	public function set symbol (s:String):Void{__symbol = s;}
	public function get symbol ():String{return __symbol;}
	//
	[Inspectable( type="Number", defaultValue=40)]
	public function set range (r:Number):Void{__range = r;}
	public function get range ():Number{return __range;}
	//
	[Inspectable( type="Number", defaultValue=10)]
	public function set parts (p:Number):Void{__parts = p;}
	public function get parts ():Number{return __parts;}
	//
	[Inspectable( type="Number", defaultValue=10)]
	public function set speed (s:Number):Void{
		__speed=s;
		__factor = 200/s;
	}
	public function get speed ():Number{return __speed;}
}