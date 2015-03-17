/**
* @fileoverview FlickrPanel class is a scrolling panel that contains
* the images thumbnails (as default with a 3 by 2 grid).
* It handles also the consequential loading of the thumbnails and the
* contextual menu.
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

class com.nuthinking.control.flickrTickr.FlickrPanel extends CgwsUIComponent
{
	private var this_mc:MovieClip						= null;
	private var accountID:String						= null;
	private var thumbs_class_arr:Array					= null;
	
	private var MAX_THUMB_NUM:Number					= 6;
	private var N_COLUMNS:Number						= 3;
	private var THUMB_WIDTH:Number						= 75;
	private var THUMB_HEIGHT:Number						= 75;
	private var MARGIN_W:Number							= 1;
	private var MARGIN_H:Number							= 7;
	private var OUT_LUM:Number							= -150;
	
	public var width:Number								= 227;
	public var height:Number							= 163;
	
	public var loadStatus:String						= "loaded"; // standy, loading, loaded
	
	/**
	* Constructor
	* 
	* @class FlickrPanel
	* 
	* @param t_parent		the MovieClip where to create our MovieClip
	* @param t_name			name of the MovieClip instance
	* @param t_depth		depth of our new MovieClip
	* @param t_accountID	the id of the account on Flickr, used to handle the link to the user page
	*/
	
	function FlickrPanel(t_parent:MovieClip, t_name:String, t_depth:Number, t_accountID:String)
	{
		super(t_parent,t_name,t_depth);
		if(t_accountID != null) accountID = t_accountID;
		this_mc.cacheAsBitmap = true;
		thumbs_class_arr = [];
	}
	
	// ***************************
	// *****   P U B L I C   *****
	// ***************************	
	
	/**
	* addItem method permits to add an image to the panel, the object attributes
	* can be:
	* 
		id_int: Number,
		id_original: Number,
		title_str: String,
		permalink_str: String,
		type_str: String ("flickr"),
		postingDate_obj: Number (1150067576),
		viewFactor_float: Number,
		viewCount_int: Number,
		commentFactor_float: Number,
		commentCount_int: Number,
		thumb_url_str: String
	* 
	* @param t_item_obj				Object containing all the data related the image
	* 								as attributes
	*/
	
	public function addItem ( t_item_obj:Object ) : Void
	{
		if(t_item_obj == null)
		{
			onError("The object added is empty!");
			return;
		}
		if(loadStatus == "loaded") loadStatus = "standby";
		var newThumb:FlickrThumb = new FlickrThumb(this_mc, "thumb_"+thumbs_class_arr.length, thumbs_class_arr.length, t_item_obj, accountID);
		newThumb.addEventListener("rollOver", Delegate.create(this, onThumbRollOver));
		newThumb.addEventListener("rollOut", Delegate.create(this, onThumbRollOut));
		newThumb.addEventListener("click", Delegate.create(this, onThumbClick));
		newThumb.addEventListener("error", Delegate.create(this, onThumbError));
		newThumb.addEventListener("load", Delegate.create(this, onThumbLoad));
		
		var pos = thumbs_class_arr.length;
		thumbs_class_arr.push(newThumb);
		var y = Math.floor(pos/N_COLUMNS) * (THUMB_HEIGHT + MARGIN_H);
		var x = (pos%N_COLUMNS) * (THUMB_WIDTH + MARGIN_W);
		newThumb.move(x, y);
	}
	
	/**
	* isFull method returns if the panel has reach the maximum number of images
	* 
	* @return a boolean value that tells if the panel has reach the maximum number of images
	*/
	
	public function isFull ( Void ) : Boolean
	{
		return thumbs_class_arr.length >= MAX_THUMB_NUM ? true : false;
	}
	
	/**
	* moveTo changes gradually the position of the object
	* 
	* @param x			the new x position of our panel
	* @param y			the new y position of our panel
	*/
	
	public function moveTo ( x:Number, y:Number ) : Void
	{
		var me = this;
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
				var eventObject:Object = {target:me, type:'arrived'};  
				me.dispatchEvent(eventObject);
			}
			this._x = xi;
			this._y = yi;
		}
	}
	
	/**
	* startLoading method starts the loading of the thumbnails of the panel
	*/
	
	public function startLoading ( Void ) : Void
	{
		for(var i=0; i<thumbs_class_arr.length; i++){
			if(thumbs_class_arr[i].loadStatus == "standby"){
				thumbs_class_arr[i].startLoading();
				loadStatus = "loading";
				return;
			}
		}
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
	* onThumbError event wraps thumbnails errors to the ticker
	* 
	* @param eventObject		the event object
	*/
	
	private function onThumbError ( eventObject:Object ) : Void
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
		for(var i=0; i<thumbs_class_arr.length; i++){
			thumbs_class_arr[i] == eventObject.target ? thumbs_class_arr[i].setLum(0,.5) : thumbs_class_arr[i].setLum(OUT_LUM, .5);
		}
		var eventObject:Object = {target:this, type:'rollOver', obj:eventObject.obj};  
		dispatchEvent(eventObject);
	}
	
	/**
	* onThumbRollOver dispatches the rollout event on the thumbnails
	* 
	* @param eventObject		the event object
	*/
	
	private function onThumbRollOut ( eventObject:Object ) : Void
	{
		for(var i=0; i<thumbs_class_arr.length; i++){
			thumbs_class_arr[i].setLum(0, .1);
		}
		var eventObject:Object = {target:this, type:'rollOut', obj:eventObject.obj};  
		dispatchEvent(eventObject);
	}
	
	/**
	* onThumbRollOver dispatches the release event on the thumbnails
	* 
	* @param eventObject		the event object
	*/
	
	private function onThumbClick ( eventObject:Object ) : Void
	{
		var eventObject:Object = {target:this, type:'click', obj:eventObject.obj};  
		dispatchEvent(eventObject);
	}
	
	/**
	* onThumbLoad is used to handle the cascade loading of thumbnails
	* 
	* @param eventObject		the event object
	*/
	
	private function onThumbLoad ( eventObject:Object ) : Void
	{
		var next_id = 0;
		for(var i=0; i<thumbs_class_arr.length; i++){
			if(thumbs_class_arr[i] == eventObject.target){
				next_id = i+1;
				break;
			}
		}
		if(next_id<thumbs_class_arr.length){
			thumbs_class_arr[next_id].startLoading();
		}else{
			loadStatus = "loaded";
			var eventObject:Object = {target:this, type:'load'};  
			dispatchEvent(eventObject);
		}
	}
}