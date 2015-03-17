import com.nuthinking.CgwsUIComponent;
import flash.geom.Rectangle;
import flash.geom.Matrix;
import flash.display.*;

/**
* @fileoverview SlidingTexturedRect class, permits to have a rectangle with a sliding texture coming from a bitmap.
* There is no need to use maskes or movieclips but unfortunately seems create some issues when used intensively.
* 
* This class extends CgwsUIComponent class that wraps the standard properties and method of movieclips to the class itself
*
* @author Christian Giordano - http://nuthinking.com
* @version 1.0
*/

/**
* usage:

import com.nuthinking.effects.SlidingTexturedRect;
import flash.display.*;
import flash.geom.Rectangle;

var library_bmpd:BitmapData = BitmapData.loadBitmap("diag_texture_alphed");
var my_strect = new SlidingTexturedRect(this, "rect_mc", 0, new Rectangle(1,1, 300, 200), library_bmpd);
my_strect.move(50,50);

*/

class com.nuthinking.effects.SlidingTexturedRect extends CgwsUIComponent
{
	private var this_mc:MovieClip					= null;
	
	private var __xspeed:Number						= - 1;
	private var __yspeed:Number						= 0;
	private var __texture:BitmapData				= null;
	private var __rectangle:Rectangle				= null;
	
	private var __currentXoffset:Number				= 0;
	private var __currentYoffset:Number				= 0;
	
	private var __isplaying:Boolean					= false;
	
	/**
	* This is the constructor
	*
	* @param t_parent					the timeline (movieclip) where the scrollbar will be created
	* @param t_name						the name of the movieclip that will be created and will contain the graphics
	* @param t_depth					the depth of the movieclip in the timeline
	* @param t_rectangle				the rectangle position and size
	* @param t_texture					the bitmapdata that will be used as texture
	* @param t_xspeed (optional)		the speed in the x axis, default value is -1.
	* @param t_yspeed (optional)		the speed in the y axis, default value is 0.
	*/
	
	function SlidingTexturedRect(t_parent:MovieClip, t_name:String, t_depth:Number, t_rectangle:Rectangle, t_texture:BitmapData, t_xspeed:Number, t_yspeed:Number){
		super(t_parent,t_name,t_depth);
		
		__rectangle = t_rectangle;
		__texture = t_texture;
		if(t_xspeed != null) __xspeed = t_xspeed;
		if(t_yspeed != null) __yspeed = t_yspeed;
		
		draw();
	}
	
	// ***************************
	// *****   P U B L I C   *****
	// ***************************
	
	/**
	* startAnimation method makes the texture start sliding
	*
	* @param t_xoffset (optional)		the speed in the x axis, default value is the last value set.
	* @param t_yoffset (optional)		the speed in the y axis, default value is the last value set.
	*/
	
	public function startAnimation ( t_xoffset:Number, t_yoffset:Number ) : Void
	{
		if ( t_xoffset != null ) __currentXoffset = t_xoffset;
		if ( t_yoffset != null ) __currentYoffset = t_yoffset;
		
		var me = this;
		this_mc.onEnterFrame = function ()
		{
			me.__onEnterFrame();
		}
		
		__isplaying = true;
	}
	
	/**
	* startAnimation method puts in pause the animation
	*/
	
	public function stopAnimation ( Void ) : Void
	{
		delete this_mc.onEnterFrame;
		__isplaying = false;
	}
	
	/**
	* setSize method changes the size of the rectangle
	*
	* @param w (optional)				the new width of the rectangle, if null the widht won't change.
	* @param h (optional)				the new height of the rectangle, if null the height won't change.
	*/
	
	public function setSize ( w:Number, h:Number ) : Void
	{
		if ( w != null ) __rectangle.width = w;
		if ( h != null ) __rectangle.height = h;
		
		if( !__isplaying) draw();
	}
	
	/**
	* clear methods is meant to remove the rectangle liberating more resources as possible
	*/
	
	public function remove ( Void ) : Void
	{
		this_mc.removeMovieClip();
		// maybe also: __texture.dispose();
	}
	
	// ***************************
	// *****   E V E N T S   *****
	// ***************************
	
	/**
	* the __onEnterFrame method generates the animation
	*/
	
	private function __onEnterFrame ( Void ) : Void
	{
		__currentXoffset += __xspeed;
		__currentYoffset += __yspeed;
		
		__currentXoffset = __currentXoffset % __texture.width;
		__currentYoffset = __currentYoffset % __texture.height;
		
		draw();
	}
	
	// *****************************
	// *****   P R I V A T E   *****
	// *****************************
	
	/**
	* the draw method draws the texture as fill gradient into the rectangle shape
	*/
	
	private function draw ( Void ) : Void
	{
		//return; // TODO REMOVE !
		var r = __rectangle;
		this_mc.clear();
		var t_matrix = new Matrix();
		t_matrix.translate(__currentXoffset, __currentYoffset);
		var repeat = true;
		this_mc.beginBitmapFill(__texture, t_matrix, repeat);
		this_mc.moveTo(r.x, r.y);
		this_mc.lineTo(r.x, r.y + r.height);
		this_mc.lineTo(r.x + r.width, r.y + r.height);
		this_mc.lineTo(r.x + r.width, r.y);
		this_mc.lineTo(r.x, r.y);
		this_mc.endFill();
	}
	
	
}