/**
* @fileoverview FlickrDownloadBar shows the progress of the original image
* downloading. To be ensure visibility with all kind of pictures it uses
* a glow effect.
* Having an own physicity and containing other movieclips it extends
* CgwsUIComponent.
*
* @author Christian Giordano - http://nuthinking.com
* @version 1.0
*/

import com.nuthinking.CgwsUIComponent;
import flash.filters.GlowFilter;

class com.nuthinking.control.flickrTickr.FlickrDownloadBar extends CgwsUIComponent
{
	private var this_mc:MovieClip;
	private var bar_mc:MovieClip;
	private var BG_COLOR:Number					= 0xFFFFFF;
	private var BAR_COLOR:Number				= 0xFD0095;
	
	private var width:Number					= null;
	private var height:Number					= null;
	
	/**
	* Constructor
	* 
	* @class FlickrDownloadBar
	* 
	* @param t_parent		the MovieClip where to create our MovieClip
	* @param t_name			name of the MovieClip instance
	* @param t_depth		depth of our new MovieClip
	* @param t_w			the maximum width of the bar
	* @param t_h			the height of the bar
	*/
	
	function FlickrDownloadBar(t_parent:MovieClip, t_name:String, t_depth:Number, t_w:Number, t_h:Number)
	{
		super(t_parent,t_name,t_depth);
		width = t_w;
		height = t_h;
		
		createChildren();
		
		this_mc._alpha = 0;
		var glow:GlowFilter = new GlowFilter(0x000000, .5, 3, 3, 2, 3);
		this_mc.filters = [glow];
		show();
	}
	
	/**
	* show method fades in the bar
	*/
	
	public function show ( Void ) : Void
	{
		var af = 100;
		var a = this_mc._alpha;
		var speed = .3;
		this_mc.onEnterFrame = function(){
			a += (af-a)*speed;
			if(Math.round(a) == af){
				delete this.onEnterFrame;
				a = af;
			}
			this._alpha = a;
		}
	}
	
	/**
	* show method fades out the bar
	*/
	
	public function hide ( Void ) : Void
	{
		var af = 0;
		var a = this_mc._alpha;
		var speed = .3;
		this_mc.onEnterFrame = function(){
			a += (af-a)*speed;
			if(Math.round(a) == af){
				this.removeMovieClip();
			}
			this._alpha = a;
		}
	}
	
	/**
	* setPerc method modify the width scale of the colored part
	* compare to the maximum width
	* 
	* @param perc		the scale in percentage (0 to 1) of the colored part
	*/
	
	public function setPerc ( perc:Number ) : Void
	{
		bar_mc._xscale = perc*100;
	}
	
	/**
	* createChildren method creates all the movieclip needed inside the class
	*/
	
	private function createChildren( Void ) : Void
	{
		bar_mc = this_mc.createEmptyMovieClip("bar_mc",0);
		bar_mc._xscale = 0;
		draw();
	}
	
	/**
	* draw method draws the graphic elements
	*/
	
	private function draw ( Void ) : Void
	{
		this_mc.clear();
		drawRectMc(this_mc, 0,0,width,height,BG_COLOR);
		bar_mc.clear();
		drawRectMc(bar_mc, 0,0,width,height,BAR_COLOR);
	}
}