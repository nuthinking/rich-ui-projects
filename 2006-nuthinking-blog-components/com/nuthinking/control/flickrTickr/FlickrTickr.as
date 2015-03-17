/**
* @fileoverview FlickrTickr is a class that shows thumbnails. It is born
* to adapt to show my last Flickr images on my blog, so it is particular
* designed for Flickr and handles the data essential data coming from
* Flickr API. Unfortunately is at the moment not possible to get the
* number of visits so one data can't be filled from Flickr.
* By the way this could be probably quite easily adapted to other purposes.
* Having an own physicity and containing other movieclips it extends
* CgwsUIComponent.
* 
* NOTE: to save more size as possible from the server connection there is
* one trick you should consider when linking images in different format
* than Jpeg. Considering that all the thumbnails in flickr are as Jpeg,
* also if your original is a Png, and since the url of the original is
* provided manipulating the url of the thumbnail, the way to communicate the
* format of the original is giving the original extenzion to the thumbnail.
* Internally the tickr will store the original extension and will use always
* .jpg for the thumbnails. I know it is a dodgy choice but since performance
* always matters and my blog really need it I had to choose compromises.
*
* @author Christian Giordano - http://nuthinking.com
* @version 1.0
*/

/**
* usage:

import mx.utils.Delegate;
import com.nuthinking.control.flickrTickr.FlickrTickr;

var images_arr:Array = [
	{
		id_int: 0, id_original: 0,
		title_str: "noiseline 02",description_str: "Overlay of screenshots from one of my sketches.",
		permalink_str: "http://www.flickr.com/photos/nuthinking/165223590/",
		type_str: "flickr",
		postingDate_obj: 1150067576,
		viewFactor_float: .3, viewCount_int: 10, commentFactor_float: .2, commentCount_int: 2,
		thumb_url_str: "http://static.flickr.com/70/165223590_064b2384a2_s.jpg"
	},
	{
		id_int: 1, id_original: 1,
		title_str: "noiseline 01",description_str: "Overlay of screenshots from one of my sketches.",
		permalink_str: "http://www.flickr.com/photos/nuthinking/165223364/",
		type_str: "flickr",
		postingDate_obj: 1150067553,
		viewFactor_float: .4, viewCount_int: 10, commentFactor_float: .5, commentCount_int: 2,
		thumb_url_str: "http://static.flickr.com/46/165223364_c82fbc1412_s.jpg"
	},
	{
		id_int: 2, id_original: 2,
		title_str: "Datamatics by Ryoji Ikeda @ ULTRA",
		permalink_str: "http://www.flickr.com/photos/nuthinking/156283626/",
		type_str: "flickr",
		postingDate_obj: 1148978460,
		viewFactor_float: .7, viewCount_int: 10, commentFactor_float: .6, commentCount_int: 2,
		thumb_url_str: "http://static.flickr.com/66/156283626_22a4350aa3_s.jpg"
	}
];

var flickrTickr_ft:FlickrTickr = new FlickrTickr(this, "flickTickr_mc",0,"nuthinking");
flickrTickr_ft.addEventListener("thumbRollOver", Delegate.create(this, onFlickrThumbRollOver));
				
flickrTickr_ft.addItems(images_arr);

function onFlickrThumbRollOver(event_obj:Object){
	trace("rolled on: " + event_obj.obj.title_str);
}

// watch the .fla file for a more complex version
*/

import com.nuthinking.CgwsUIComponent;
import com.nuthinking.control.flickrTickr.*;
import com.nuthinking.effects.BandTransition;
import flash.geom.Rectangle;
import mx.events.EventDispatcher;
import mx.utils.Delegate;

class com.nuthinking.control.flickrTickr.FlickrTickr extends CgwsUIComponent
{
	private var accountID:String						= null;
	private var this_mc:MovieClip						= null;
	private var target_mc:MovieClip						= null;
	private var bg_mc:MovieClip							= null;
	
	private var images_obj_arr:Array					= null;
	private var panels_class_arr:Array					= null;
	private var next_arrow_mc:MovieClip					= null;
	private var prev_arrow_mc:MovieClip					= null;
	
	private var menu_fm:FlickrMenu						= null;
	private var currentPanel:FlickrPanel				= null;
	private var lastPanel:FlickrPanel					= null;
	private var panelWidth:Number						= 227;
	private var width:Number							= 244;
	private var height:Number							= 177;
	private var BG_COLOR:Number							= 0x181818;
	private var SCROLL_MARGIN_W:Number					= 15;
	private var MARGIN_LEFT:Number						= 1;
	private var BORDER_W:Number							= 3;
	private var PANEL_Y:Number							= 13;
	private var SENSIBLE_MARGIN_W:Number				= 50;
	private var currentPanel_id:Number;
	private var status:String							= "still"; // scrolling
	private var transition_out_bt:BandTransition		= null;
	private var transition_in_bt:BandTransition			= null;
	private var my_cm:ContextMenu;
	
	private var mouseListener:Object;
	private var panelPosition_str:String				= "center"; // left, center, right
	
	/**
	* Constructor
	* 
	* @class FlickrTickr
	* 
	* @param t_parent		the MovieClip where to create our MovieClip
	* @param t_name			name of the MovieClip instance
	* @param t_depth		depth of our new MovieClip
	* @param t_accountID	the id of the account on Flickr, used to handle the link to the user page
	*/
	
	function FlickrTickr(t_parent:MovieClip, t_name:String, t_depth:Number, t_accountID:String)
	{
		super(t_parent,t_name,t_depth);
		if(t_accountID != null) accountID = t_accountID;
		
		images_obj_arr = [];
		panels_class_arr = [];
		currentPanel_id = 0;
		
		if(_global.flickrCreditsMenuItems_arr == null) _global.flickrCreditsMenuItems_arr = [];
		var isPresent = false;
		for(var i=0; i<_global.flickrCreditsMenuItems_arr.length; i++){
			if(_global.flickrCreditsMenuItems_arr[i].caption == "FlickrTickr by Christian Giordano"){
				isPresent = true;
				break;
			}
		}
		if(!isPresent) _global.flickrCreditsMenuItems_arr.push(new ContextMenuItem("FlickrTickr by Christian Giordano", showFlickrCredits, true));
		
		my_cm = new ContextMenu();
		my_cm.hideBuiltInItems();
		if(t_accountID != null){
			accountID = t_accountID;
			my_cm.customItems.push(new ContextMenuItem("Go to Flickr Account", Delegate.create(this, goToFlickrAccount), false));
		}
		if(_global.contextMenuItems_arr != null){
			for(var i=0; i<_global.contextMenuItems_arr.length; i++){
				my_cm.customItems.push(_global.contextMenuItems_arr[i]);
			}
		}
		if(_global.flickrCreditsMenuItems_arr != null){
			for(var i=0; i<_global.flickrCreditsMenuItems_arr.length; i++){
				my_cm.customItems.push(_global.flickrCreditsMenuItems_arr[i]);
			}
		}
		this_mc.menu = my_cm;
		
		createChildren();
		
		var me = this;
		mouseListener = {};
		mouseListener.onMouseMove = function(){
			me.checkMousePos();
		}
	}
	
	// ***************************
	// *****   P U B L I C   *****
	// ***************************
	
	/**
	* addItems method is the one used to add pictures to the component
	* 
	* @param t_items_arr	the array of objects containing the data of the images
	*/
	
	public function addItems ( t_items_arr:Array ) : Void
	{
		if( t_items_arr.length == 0)
		{
			onError("The array added is empty!");
			return;
		}
		for(var i=0; i<t_items_arr.length; i++)
		{
			var item = t_items_arr[i];
			if( panels_class_arr.length == 0
				|| (lastPanel != null && lastPanel.isFull()) )
			{
				var t_id = panels_class_arr.length;
				var x = Math.round(MARGIN_LEFT + SCROLL_MARGIN_W*.5);

				lastPanel = new FlickrPanel(this_mc, "panel_"+panels_class_arr.length, 10 + panels_class_arr.length, accountID);
				lastPanel.addEventListener("rollOver", Delegate.create(this, onThumbRollOver));
				lastPanel.addEventListener("rollOut", Delegate.create(this, onThumbRollOut));
				lastPanel.addEventListener("click", Delegate.create(this, onThumbClick));
				lastPanel.addEventListener("error", Delegate.create(this, onPanelError));
				lastPanel.addEventListener("load", Delegate.create(this, onPanelLoad));
				lastPanel.addEventListener("arrived", Delegate.create(this, onPanelArrived));
				lastPanel.move(x,PANEL_Y);
				panels_class_arr.push(lastPanel);
				if(t_id == currentPanel_id){
					currentPanel = lastPanel;
					//lastPanel.move(Math.round(MARGIN_LEFT + SCROLL_MARGIN_W*.5),null);
				}else{
					lastPanel._visible = false;
				}
				menu_fm.addButton();
			}
			lastPanel.addItem(item);
			if(i==0) lastPanel.startLoading();
		}

	}
	
	/**
	* the following methods will wrap the standard methods of the movieclip class
	* paying attention to the right parameter to consider
	*/
	
	function get _width ():Number {
		return bg_mc._width;
	}
	function set _width (v):Void {
		bg_mc._width = v;
	}
	function get _height ():Number {
		return bg_mc._height;
	}
	function set _height (v):Void {
		bg_mc._height = v;
	}
	
	// ***************************************
	// *****   M E N U   O P T I O N S   *****
	// ***************************************
	
	/**
	* the following methods will be called by the contextual menu
	* 
	* @param obj				the event object
	* @param item				the menu item selected
	*/
	
	private function goToFlickrAccount ( obj:Object, item:ContextMenuItem ) : Void
	{
		getURL("http://www.flickr.com/photos/"+accountID+"/","_blank");
	}
	
	private function showFlickrCredits ( obj:Object, item:ContextMenuItem ) : Void
	{
		getURL("http://nuthinking.com/","_blank");
	}
	
	// ***************************
	// *****   E V E N T S   *****
	// ***************************
	
	/**
	* onError event dispatches eventual errors to listeners
	* 
	* @param err_str			the content of the error to dispatch
	*/
	
	private function onError ( err_str:String ) : Void
	{
		var eventObject:Object = {target:this, type:'error', content:err_str};  
		dispatchEvent(eventObject);
	}
	
	/**
	* onPanelError event wraps panel errors to the ticker
	* 
	* @param eventObject		the event object
	*/
	
	private function onPanelError ( eventObject:Object ) : Void
	{
		onError(eventObject.content);
	}
	
	/**
	* onThumbRollOver dispatches the rollover event on the thumbnails
	* 
	* @param eventObject		the event object
	*/
	
	private function onThumbRollOver ( eventObject:Object ) : Void
	{
		var eventObject:Object = {target:this, type:'thumbRollOver', obj:eventObject.obj};  
		dispatchEvent(eventObject);
	}
	
	/**
	* onThumbRollOver dispatches the rollout event on the thumbnails
	* 
	* @param eventObject		the event object
	*/
	
	private function onThumbRollOut ( eventObject:Object ) : Void
	{
		var eventObject:Object = {target:this, type:'thumbRollOut', obj:eventObject.obj};  
		dispatchEvent(eventObject);
	}
	
	/**
	* onThumbRollOver dispatches the release event on the thumbnails
	* 
	* @param eventObject		the event object
	*/
	
	private function onThumbClick ( eventObject:Object ) : Void
	{
		var eventObject:Object = {target:this, type:'thumbClick', obj:eventObject.obj};  
		dispatchEvent(eventObject);
	}
	
	/**
	* onPanelLoad is used to handle the cascade loading of thumbnails
	* 
	* @param eventObject		the event object
	*/
	
	private function onPanelLoad ( eventObject:Object ) : Void
	{
		var next_id = 0;
		for(var i=0; i<panels_class_arr.length; i++){
			if(panels_class_arr[i] == eventObject.target){
				next_id = i+1;
				break;
			}
		}
		if(next_id < panels_class_arr.length){
			panels_class_arr[next_id].startLoading();
		}else{
			var eventObject:Object = {target:this, type:'load'};  
			dispatchEvent(eventObject);
		}
	}
	
	/**
	* onPanelArrived event is called after the sliding transition
	* 
	* @param eventObject		the event object
	*/
	
	private function onPanelArrived ( eventObject:Object ) : Void
	{
		if(eventObject.target == currentPanel){
			status = "still";
		}
	}
	
	/**
	* onChangePanel event is called when one of the lateral arrow is pressed
	* and make the panels change
	* 
	* @param eventObject		the event object
	*/
	
	private function onChangePanel (eventObject:Object ) : Void
	{
		gotoPanel(eventObject.id);
	}
	
	/**
	* onSlided event is called after the bands transition
	* 
	* @param eventObject		the event object
	*/
	
	private function onSlided (eventObject:Object ) : Void
	{
		currentPanel.move(Math.round(MARGIN_LEFT + SCROLL_MARGIN_W*.5),null);
		currentPanel._visible = true;
		transition_out_bt.dispose();
		transition_in_bt.dispose();
		status = "still";
	}
	// *****************************
	// *****   P R I V A T E   *****
	// *****************************
	
	/**
	* createChildren method creates all the movieclip needed inside the class
	*/
	
	private function createChildren ( Void ) : Void
	{
		bg_mc = this_mc.createEmptyMovieClip("bg_mc",0);
		drawRectMc(bg_mc,0,0,width,height,BG_COLOR);
		
		menu_fm = new FlickrMenu (this_mc, "menu_mc", 1);
		menu_fm.addEventListener("change", Delegate.create(this, onChangePanel));
		menu_fm.move(47, null);
		
		var label_mc = this_mc.attachMovie("flickr_label_mc", "flickr_label_mc", 1000);
		label_mc._x = -1;
		
		var me = this;
		
		prev_arrow_mc = this_mc.attachMovie("arrow_scroll_mc","prev_arrow_mc",1001);
		prev_arrow_mc._xscale = -100;
		prev_arrow_mc._x = 10;
		prev_arrow_mc._y = 76;
		prev_arrow_mc._alpha = 30;
		prev_arrow_mc.onRollOver = function(){
			this._alpha = 100;
			this.gotoAndStop(2);
		}
		prev_arrow_mc.onRollOut = function(){
			this._alpha = 70;
			this.gotoAndStop(1);
		}
		prev_arrow_mc.onRelease = function(){
			//trace("prev");
			me.scrollPanels(-1);
		}
		
		next_arrow_mc = this_mc.attachMovie("arrow_scroll_mc","next_arrow_mc",1002);
		next_arrow_mc._x = width - 10;
		next_arrow_mc._y = 76;
		next_arrow_mc._alpha = 30;
		next_arrow_mc.onRollOver = function(){
			this._alpha = 100;
			this.gotoAndStop(2);
		}
		next_arrow_mc.onRollOut = function(){
			this._alpha = 70;
			this.gotoAndStop(1);
		}
		next_arrow_mc.onRelease = function(){
			me.scrollPanels(1);
		}
		
		target_mc = this_mc.createEmptyMovieClip("target_mc",1010);
		drawRectMc(target_mc,0,0,width,height,0x00FF00);
		target_mc.useHandCursor = false;
		target_mc._alpha = 0;
		target_mc.onRollOver = function(){
			Mouse.addListener(me.mouseListener);
			this._visible = false;
		}
	}
	
	/**
	* gotoPanel method make the panels change, is called both from the arrows
	* but also from the top panel icons
	* 
	* @param id				the id of the panel that will have to be shown
	*/
	
	private function gotoPanel( id:Number ) : Void
	{
		transition_out_bt.dispose();
		transition_in_bt.dispose();
		var band_height:Number = 2;
		transition_out_bt = new BandTransition(this_mc, "transition_mc", 900);
		transition_out_bt.create(currentPanel.getMc(), new Rectangle(0,0,currentPanel.width,currentPanel.height), band_height);
		transition_out_bt.move(currentPanel._x, currentPanel._y);
		currentPanel._visible = false;
		
		transition_in_bt = new BandTransition(this_mc, "transition_2_mc", 901);
		transition_in_bt.addEventListener("slided", Delegate.create(this, onSlided));
		transition_in_bt.create(panels_class_arr[id].getMc(), new Rectangle(0,0,currentPanel.width,currentPanel.height), band_height);
		
		if(id > currentPanel_id){
			// panels versous left
			transition_out_bt.slideTo(- width - BORDER_W, null);
			transition_in_bt.move(width + BORDER_W, currentPanel._y);
			transition_in_bt.slideTo(- panelWidth - Math.round(BORDER_W + SCROLL_MARGIN_W*.5), null);
		}else{
			// panels versous right
			transition_out_bt.slideTo(width + BORDER_W, null);
			transition_in_bt.move(- panelWidth - BORDER_W, currentPanel._y);
			transition_in_bt.slideTo(panelWidth + Math.round(MARGIN_LEFT + BORDER_W + SCROLL_MARGIN_W*.5), null);
		}
		status = "scrolling";
		panelPosition_str = "center";
		currentPanel = panels_class_arr[id];
		currentPanel_id = id;
		if(id==0) {prev_arrow_mc.onRollOut(); prev_arrow_mc.enabled = false;}
		if(id==panels_class_arr.length - 1) {next_arrow_mc.onRollOut(); next_arrow_mc.enabled = false;}
	}
	
	/**
	* scrollPanels method call the change of the panels based on the direction
	* 
	* @param dir			direction of the scrolling:
	* 						<0 means from right to left
	* 						>0 means from left to right
	*/
	
	private function scrollPanels( dir:Number ) : Void
	{
		if(dir < 0){
			if(currentPanel_id == 0) return;
		}else{
			if(currentPanel_id == panels_class_arr.length - 1) return;
		}
		menu_fm.selectButton(currentPanel_id + dir);
		gotoPanel(currentPanel_id + dir);
	}
	
	/**
	* checkMousePos method checks if and where to make a slightly scroll to
	* indicate the eventual scrolling if pressed the arrow
	*/
	
	private function checkMousePos ( Void ) : Void
	{
		if(status != "still") return;
		var newPos:String = "center";
		if(mouseIn()){
			if(this_mc._xmouse<SENSIBLE_MARGIN_W){
				newPos = "left";
			}else if(this_mc._xmouse > width - SENSIBLE_MARGIN_W){
				newPos = "right";
			}
		}else{
			Mouse.removeListener(mouseListener);
			target_mc._visible = true;
		}
		if((newPos == "left" && currentPanel_id == 0) || (newPos == "right" && currentPanel_id == panels_class_arr.length - 1)) newPos = "center";
		if( newPos == panelPosition_str) return;
		panelPosition_str = newPos;
		next_arrow_mc.enabled = false;
		prev_arrow_mc.enabled = false;
		switch(panelPosition_str)
		{
			case "left":
				currentPanel.moveTo(MARGIN_LEFT + SCROLL_MARGIN_W, null);
				setAlphaTo(prev_arrow_mc, 100);
				setAlphaTo(next_arrow_mc, 0);
				prev_arrow_mc.enabled = true;
				break;
			case "center":
				currentPanel.moveTo(Math.round(MARGIN_LEFT + SCROLL_MARGIN_W*.5),null);
				setAlphaTo(prev_arrow_mc, 50);
				setAlphaTo(next_arrow_mc, 50);
				
				break;
			case "right":
				currentPanel.moveTo(MARGIN_LEFT, null);
				setAlphaTo(prev_arrow_mc, 0);
				setAlphaTo(next_arrow_mc, 100);
				next_arrow_mc.enabled = true;
				break;
		}
	}
	
	/**
	* The mouseIn method checks the rollover without using the movieclip method,
	* probably there could be issues if the _x and _y of the _root are not equal to 0.
	* 
	* return a boolean value indicating if the mouse is over
	*/
	
	private function mouseIn(Void):Boolean
	{
		return target_mc.hitTest(_root._xmouse, _root._ymouse, false);
	}
	
	/**
	* setAlphaTo method make movieclips change alpha with a transition
	* 
	* @param mc				movieclip to apply the change of alpha
	* @param af				the final alpha value of the movieclip
	*/
	
	private function setAlphaTo(mc:MovieClip,af:Number) : Void
	{
		var ai = mc._alpha;
		var speed = .3;
		mc.onEnterFrame = function(){
			ai += (af-ai)*speed;
			if(Math.round(ai)==af){
				delete this.onEnterFrame;
				ai = af;
			}
			this._alpha = ai;
		}
	}
}