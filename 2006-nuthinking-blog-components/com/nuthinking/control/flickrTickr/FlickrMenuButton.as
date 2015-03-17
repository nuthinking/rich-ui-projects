/**
* @fileoverview FlickrMenuButton is the class that represent the buttons
* of the menu that permit to change panel.
* Having an own physicity and containing other movieclips it extends
* CgwsUIComponent.
*
* @author Christian Giordano - http://nuthinking.com
* @version 1.0
*/

import com.nuthinking.CgwsUIComponent;
import mx.events.EventDispatcher;
import mx.utils.Delegate;

class com.nuthinking.control.flickrTickr.FlickrMenuButton extends CgwsUIComponent
{
	private var this_mc:MovieClip						= null;
	
	private var bg_mc:MovieClip							= null;
	private var icon_mc:MovieClip						= null;
	
	public var width:Number								= 12;
	public var height:Number							= 10;
	
	/**
	* Constructor
	* 
	* @class FlickrMenuButton
	* 
	* @param t_parent		the MovieClip where to create our MovieClip
	* @param t_name			name of the MovieClip instance
	* @param t_depth		depth of our new MovieClip
	*/
	
	function FlickrMenuButton(t_parent:MovieClip, t_name:String, t_depth:Number)
	{
		super(t_parent,t_name,t_depth);
		this_mc._alpha = 70;
		
		createChildren();
	}
	
	// ***************************
	// *****   P U B L I C   *****
	// ***************************
	
	/**
	* the following methods will wrap the standard methods of the movieclip class
	*/
	
	function get enabled ():Boolean {
		return bg_mc.enabled;
	}
	function set enabled (v):Void {
		moveTo(null, (v ? 2 : 0));
		bg_mc.enabled = v;
	}
	
	/**
	* moveTo changes gradually the position of the object
	* 
	* @param x			the new x position of our panel
	* @param y			the new y position of our panel
	*/
	
	public function moveTo ( x:Number, y:Number ) : Void
	{
		var speed = .3;
		var xi = this_mc._x;
		var yi = this_mc._y;
		var xf = x != null ? x : xi;
		var yf = y != null ? y : yi;
		this_mc.onEnterFrame = function(){
			xi += (xf-xi)*speed;
			yi += (yf-yi)*speed;
			if(Math.round(xi)==xf && Math.round(yi)==yf){
				delete this.onEnterFrame;
				xi = xf;
				yi = yf;
			}
			this._x = xi;
			this._y = yi;
		}
	}
	
	// ***************************
	// *****   E V E N T S   *****
	// ***************************
	
	/**
	* __onRollOver dispatches the rollover event over the button to the listeners
	*/
	
	private function __onRollOver ( Void ) : Void
	{
		this_mc._alpha = 100;
		var eventObject:Object = {target:this, type:'rollOver'};  
		dispatchEvent(eventObject);
	}
	
	/**
	* __onRollOver dispatches the rollout event over the button to the listeners
	*/
	
	private function __onRollOut ( Void ) : Void
	{
		this_mc._alpha = 70;
		var eventObject:Object = {target:this, type:'rollOut'};  
		dispatchEvent(eventObject);
	}
	
	/**
	* __onRollOver dispatches the release event over the button to the listeners
	*/
	
	private function __onClick ( Void ) : Void
	{
		this_mc._alpha = 70;
		var eventObject:Object = {target:this, type:'click'};  
		dispatchEvent(eventObject);
	}
	
	// *****************************
	// *****   P R I V A T E   *****
	// *****************************
	
	/**
	* createChildren method creates all the movieclip needed inside the class
	*/
	
	private function createChildren( Void ) : Void
	{
		bg_mc = this_mc.createEmptyMovieClip("bg_mc",0);
		drawRectMc(bg_mc,0,0,width,height,0x00FF00);
		bg_mc._alpha = 0;
		bg_mc.onRollOver 							= Delegate.create(this, __onRollOver);
		bg_mc.onRollOut = bg_mc.onReleaseOutside 	= Delegate.create(this, __onRollOut);
		bg_mc.onRelease 							= Delegate.create(this, __onClick);
		
		icon_mc = this_mc.attachMovie("flickr_page_ico","icon_mc",1);
		icon_mc._x = icon_mc._y = 1;
	}
}