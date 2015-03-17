/**
* @fileoverview BandTransition is the class that handle the effect of
* transition with tiny horizzontal lines.
* Having an own physicity and containing other movieclips it extends
* CgwsUIComponent.
*
* @author Christian Giordano - http://nuthinking.com
* @version 1.0
*/

import com.nuthinking.CgwsUIComponent;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;

class com.nuthinking.effects.BandTransition extends CgwsUIComponent
{
	private var this_mc:MovieClip;
	
	private var bands_mc_arr:Array;
	private var source_bd:BitmapData;
	
	/**
	* Constructor
	* 
	* @class BandTransition
	* 
	* @param t_parent		the MovieClip where to create our MovieClip
	* @param t_name			name of the MovieClip instance
	* @param t_depth		depth of our new MovieClip
	*/
	
	function BandTransition ( t_parent:MovieClip, t_name:String, t_depth:Number )
	{
		super(t_parent,t_name,t_depth);
	}
	
	// ***************************
	// *****   P U B L I C   *****
	// ***************************
	
	/* create method creates all the lines that will be later animated and copies
	* in them the part of the image needed
	* 
	* @param t_target			the movieclip which the effect will be applied to
	* @param t_rect				the rectangle that defines the size of the movieclip
	* @param t_band_height		the height of the bands used for the effect
	*/
	
	public function create ( t_target:MovieClip, t_rect:Rectangle, t_band_height:Number ) : Void
	{
		source_bd = new BitmapData(t_rect.width, t_rect.height, true, 0x00000000);
		source_bd.draw(t_target);
		bands_mc_arr = [];
		var n_bands = Math.ceil(t_rect.height / t_band_height);
		var yi=0;
		for(var i=0; i<n_bands; i++){
			var band_bd:BitmapData = new BitmapData(source_bd.width, t_band_height, true, 0x00FF0000);
			band_bd.copyPixels(source_bd, new Rectangle(0, yi, source_bd.width, t_band_height), new Point());
			var mc = this_mc.createEmptyMovieClip("band_"+i, i);
			mc.attachBitmap(band_bd,i,"auto",true);
			mc._y = yi;
			mc.band_bd = band_bd;
			bands_mc_arr.push(mc);
			yi += t_band_height;
		}
	}
	
	/* slideTo method makes all the band move to the new position passed.
	* When the animation is completated the event "slided" is dispatched.
	* 
	* @param x					the new x position for the bands
	*/
	
	public function slideTo ( x:Number ) : Void
	{
		var temp_arr = [];
		for(var i=0; i<bands_mc_arr.length; i++) temp_arr.push(bands_mc_arr[i]);
		var me = this;
		var speed = .1;
		var n_bands = 10;
		this_mc.onEnterFrame = function()
		{
			for(var i=0; i<n_bands; i++){
				var el = Math.floor(Math.random()*temp_arr.length);
				var mc = temp_arr[el];
				mc.isFinal = temp_arr.length == 1 ? true : false;
				var xi = mc._x;
				mc.onEnterFrame = function(){
					xi += (x-xi) * speed;
					if(Math.round(xi) == x){
						delete this.onEnterFrame;
						xi = x;
						if(this.isFinal){
							var eventObject:Object = {target:me, type:'slided'};  
							me.dispatchEvent(eventObject);
						}
					}
					this._x = xi;
				}
				temp_arr.splice(el,1);
				if(temp_arr.length == 0){
					delete this.onEnterFrame;
					break;
				}
			}
		}
	}
	
	/* dispose method removes from memory all the BitmapData object created
	* for the effect.
	*/
	
	public function dispose ( Void ) : Void
	{
		for(var i=0; i<bands_mc_arr.length; i++){
			var mc = bands_mc_arr[i];
			mc.band_bd.dispose();
			mc.removeMovieClip();
		}
	}
}