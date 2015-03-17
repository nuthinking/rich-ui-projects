/**
* @fileoverview FlickrLed is the bar underneath the thumbnail that is
* used to show further information. The colored part is horizontally centered.
* Having an own physicity and containing other movieclips it extends
* CgwsUIComponent.
*
* @author Christian Giordano - http://nuthinking.com
* @version 1.0
*/

import com.nuthinking.CgwsUIComponent;

class com.nuthinking.control.flickrTickr.FlickrLed extends CgwsUIComponent
{
	private var this_mc:MovieClip;
	private var bg_mc:MovieClip;
	private var led_mc:MovieClip;
	
	private var width:Number				= 75;
	private var height:Number				= 2;
	
	private var color:Number;
	private var perc:Number					= 0;
	
	/**
	* Constructor
	* 
	* @class FlickrLed
	* 
	* @param t_parent		the MovieClip where to create our MovieClip
	* @param t_name			name of the MovieClip instance
	* @param t_depth		depth of our new MovieClip
	* @param t_color		the color of the bar
	*/
	
	function FlickrLed (t_parent:MovieClip, t_name:String, t_depth:Number, t_color:Number)
	{
		super(t_parent,t_name,t_depth);
		color = t_color;
		createChildren();
	}
	
	/**
	* setValue method modify the width scale of the colored part
	* compare to the maximum width
	* 
	* @param t_perc			the scale in percentage (0 to 1) of the colored part
	*/
	
	public function setValue ( t_perc:Number ) : Void
	{
		perc = t_perc;
		draw();
	}
	
	/**
	* draw method draws the graphic elements
	*/
	
	private function draw ( Void ) : Void
	{
		bg_mc.clear();
		drawRectMc(bg_mc, 0, 0, width, height, color);
		
		led_mc.clear();
		drawRectMc(led_mc, - width*.5, 0, width, height, color);
		led_mc._x =  width*.5;
		led_mc._xscale = perc*100;		
	}
	
	/**
	* createChildren method creates all the movieclip needed inside the class
	*/
	
	private function createChildren ( Void ) : Void
	{
		bg_mc = this_mc.createEmptyMovieClip("bg_mc", 0);
		bg_mc._alpha = 30;
		
		led_mc = this_mc.createEmptyMovieClip("led_mc", 1);
		
		draw();
	}
}