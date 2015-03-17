/**
* @fileoverview FlickrMenu is the menu which permits to change panel.
* Having an own physicity and containing other movieclips it extends
* CgwsUIComponent.
*
* @author Christian Giordano - http://nuthinking.com
* @version 1.0
*/

import com.nuthinking.CgwsUIComponent;
import com.nuthinking.control.flickrTickr.*;
import mx.events.EventDispatcher;
import mx.utils.Delegate;

class com.nuthinking.control.flickrTickr.FlickrMenu extends CgwsUIComponent
{
	private var this_mc:MovieClip							= null;
	private var slider_mc:MovieClip							= null;
	
	private var buttons_class_arr:Array						= null;
	private var BUTTON_MARING_W:Number						= 1;
	private var selectedButton:FlickrMenuButton				= null;
	
	/**
	* Constructor
	* 
	* @class FlickrMenu
	* 
	* @param t_parent		the MovieClip where to create our MovieClip
	* @param t_name			name of the MovieClip instance
	* @param t_depth		depth of our new MovieClip
	*/
	
	function FlickrMenu(t_parent:MovieClip, t_name:String, t_depth:Number)
	{
		super(t_parent,t_name,t_depth);
		
		buttons_class_arr = [];
		
		createChildren();
	}
	
	// ***************************
	// *****   P U B L I C   *****
	// ***************************
	
	/**
	* addButton method adds a button to the menu
	*/
	
	public function addButton ( Void ) : Void
	{
		var newButton:FlickrMenuButton = new FlickrMenuButton (this_mc,"button_"+buttons_class_arr.length, buttons_class_arr.length+1);
		newButton.addEventListener("click", Delegate.create(this, onButtonClick));
		var xpos = (newButton.width + BUTTON_MARING_W) * buttons_class_arr.length;
		newButton.move(xpos,2);
		
		if(buttons_class_arr.length == 0){
			selectedButton = newButton;
			selectedButton.enabled = false;
		}
		
		buttons_class_arr.push(newButton);
	}
	
	/**
	* selectButton method selects the button with a certain id
	* 
	* @param id				the id of the button to select
	*/
	
	public function selectButton( id:Number ) : Void
	{
		if( buttons_class_arr[id] == selectedButton) return;
		if(selectedButton != null) selectedButton.enabled = true;
		selectedButton = buttons_class_arr[id];
		selectedButton.enabled = false;
		//slider_mc._x = event_obj.target._x;
		moveMcTo(slider_mc, selectedButton._x + 1, null);
	}
	
	// ***************************
	// *****   E V E N T S   *****
	// ***************************
	
	/**
	* onButtonClick dispatches the release event on the buttons
	* 
	* @param eventObject		the event object
	*/
	
	private function onButtonClick ( event_obj:Object ) : Void
	{
		for(var i=0; i<buttons_class_arr.length; i++){
			if(buttons_class_arr[i] == event_obj.target){
				break;
			}
		}
		//trace("id: "+i);
		if(selectedButton != null) selectedButton.enabled = true;
		selectedButton = event_obj.target;
		selectedButton.enabled = false;
		//slider_mc._x = event_obj.target._x;
		moveMcTo(slider_mc, selectedButton._x + 1, null);
		var eventObject:Object = {target:this, type:'change', id:i};  
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
		slider_mc = this_mc.createEmptyMovieClip("slider_mc", 0);
		slider_mc._alpha = 70;
		drawRectMc(slider_mc, 0, 0, 10, 1, 0xFFFFFF);
		slider_mc._y = 11;
		slider_mc._x = 1;
	}
	
	/**
	* moveMcTo method moves a certain mc to a new x and y gradually
	* 
	* @param mc			the movieclip that has to be moved
	* @param x			the new x position for the movieclip
	* @param y			the new y position for the movieclip
	*/
	
	private function moveMcTo(mc:MovieClip, x:Number, y:Number) : Void
	{
		var speed = .3;
		var xi = mc._x;
		var yi = mc._y;
		var xf = x != null ? x : xi;
		var yf = y != null ? y : yi;
		mc.onEnterFrame = function()
		{
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
}