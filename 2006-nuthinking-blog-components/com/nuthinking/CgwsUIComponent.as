/**
* @fileoverview CgwsUIComponent class is a sort of MovieClip wrapper
* that speeds up the instantiation of your class giving all the methods
* available instantly after you instantiate the object.
* It contains almost all MovieClip methods/attributes and for some aspects
* can be considered as a lighter version of (formerly) Macromedia UIComponent.
*
* @author Christian Giordano - http://nuthinking.com
* @version 1.0
*/

/**
* Construction a new CgwsUIComponent class
* 
* @class CgwsUIComponent
* 
* @param t_parent		the MovieClip where to create our MovieClip
* @param t_name			name of the MovieClip instance
* @param t_depth		depth of our new MovieClip
*/

import mx.events.EventDispatcher;

class com.nuthinking.CgwsUIComponent
{
	private var this_mc:MovieClip;
	
	function dispatchEvent() {};
 	function addEventListener() {};
 	function removeEventListener() {};	
	
	function CgwsUIComponent ( t_parent:MovieClip, t_name:String, t_depth:Number )
	{
		this_mc = t_parent.createEmptyMovieClip(t_name,t_depth);
		
		EventDispatcher.initialize(this);
	}
	
	// *******************************************
	// *****   C U S T O M   M E T H O D S   *****
	// *******************************************
	
	/**
	* method that draw a rectangle shape inside a MovieClip
	* 
	* @param mc			the MovieClip where to draw the shape
	* @param x			the x position of the rectangle inside the MovieClip
	* @param y			the y position of the rectangle inside the MovieClip
	* @param w			the width of the rectangle
	* @param h			the height of the rectangle
	* @param col		the color of the rectangle
	*/
	private function drawRectMc(mc:MovieClip,x:Number,y:Number,w:Number,h:Number,col:Number):Void
	{
		mc.beginFill(col);
		mc.moveTo(x,y);
		mc.lineTo(x+w,y);
		mc.lineTo(x+w,y+h);
		mc.lineTo(x,y+h);
		mc.lineTo(x,y);
		mc.endFill();
	}
	
	/**
	* method to shortcut the positioning code
	* 
	* @param x			the new x position of our MovieClip
	* @param y			the new y position of our MovieClip
	*/
	public function move(x:Number,y:Number):Void
	{
		if(x != null) this_mc._x = x;
		if(y != null) this_mc._y = y; 
	}
	
	/**
	* method to shortcut the scaling code
	* 
	* @param w			the new width of our MovieClip
	* @param h			the new height of our MovieClip
	*/
	public function setSize ( w:Number, h:Number ) : Void
	{
		if(w != null) this_mc._width = w;
		if(h != null) this_mc._height = h;
	}
	
	/**
	* getMc returns the physical movieclip and it is useful, for instance, for bitmap effects
	* 
	* @return the main movieclip instance
	*/
	
	public function getMc ( Void ) : MovieClip
	{
		return this_mc;
	}
	
	// *******************************************
	// *****   F R O M   M O V I E C L I P   *****
	// *******************************************
	
	function swapDepths ( v:Number ) : Void { this_mc.swapDepths(v); }	
	function setMask ( mc:MovieClip ) : Void { this_mc.setMask ( mc ); }	
	
	function set onEnterFrame ( f ) : Void { this_mc.onEnterFrame = f; }
	function get onEnterFrame () : Function { return this_mc.onEnterFrame; }
	
	function get _visible ():Boolean { return this_mc._visible; }
	function set _visible (v):Void { this_mc._visible = v; }
	
	function set enabled (v):Void { this_mc.enabled = v;}
	function get enabled ():Boolean { return this_mc.enabled; }
	
	function get _y ():Number { return this_mc._y; }
	function set _y (v):Void { this_mc._y = v; }
	
	function get _x ():Number { return this_mc._x; }
	function set _x (v):Void { this_mc._x = v; }
	
	function get _xscale ():Number { return this_mc._xscale; }
	function set _xscale (v):Void { this_mc._xscale = v; }
	
	function get _yscale ():Number { return this_mc._yscale; }
	function set _yscale (v):Void { this_mc._yscale = v; }
	
	function get _width ():Number { return this_mc._width; }
	function set _width (v):Void { this_mc._width = v; }
	
	function get _height ():Number { return this_mc._height; }
	function set _height (v):Void { this_mc._height = v; }
	
	function get _rotation ():Number { return this_mc._rotation; }
	function set _rotation (v):Void { this_mc._rotation = v; }
	
	function get cacheAsBitmap ():Boolean { return this_mc.cacheAsBitmap; }
	function set cacheAsBitmap (v):Boolean { this_mc.cacheAsBitmap = v; }
	
}