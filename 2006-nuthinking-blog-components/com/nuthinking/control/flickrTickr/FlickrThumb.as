/**
* @fileoverview FlickrThumb is the class that host the thumbnail of the
* pictures. It has a rollover based on luminosity and keep handling the
* contextual menu.
* Having an own physicity and containing other movieclips it extends
* CgwsUIComponent.
*
* @author Christian Giordano - http://nuthinking.com
* @version 1.0
*/

import com.nuthinking.CgwsUIComponent;
import com.nuthinking.control.flickrTickr.FlickrLed;
import com.nuthinking.control.flickrTickr.FlickrDownloadBar;
import com.nuthinking.image.BrushThumb
import mx.events.EventDispatcher;
import mx.utils.Delegate;
import flash.geom.*;
import flash.net.FileReference;

class com.nuthinking.control.flickrTickr.FlickrThumb extends CgwsUIComponent
{
	private var this_mc:MovieClip;
	private var accountID:String					= null;
	private var blue_fl:FlickrLed					= null;
	private var pink_fl:FlickrLed					= null;
	private var thumb_bt:BrushThumb;
	
	private var data_obj:Object;
	private var image_url:String;
	private var domain_str:String;
	
	public var loadStatus:String					= "standby"; // loading, loaded
	private var my_cm:ContextMenu;
	private var downloadFile:FileReference			= null;
	private var downloadListener:Object				= null;
	private var downloadBar_fdb:FlickrDownloadBar	= null;
	private var thumbColor:Color					= null;
	private var thumbLum:Number						= 0;
	private var file_ext:String						= null; // .jpg, .png
	
	/**
	* Constructor
	* 
	* @class FlickrDownloadBar
	* 
	* @param t_parent		the MovieClip where to create our MovieClip
	* @param t_name			name of the MovieClip instance
	* @param t_depth		depth of our new MovieClip
	* @param t_data_obj		the object containing as attributes all the data regarding the picture
	* @param t_accountID	the id of the account on Flickr, used to handle the link to the user page
	*/
	
	function FlickrThumb(t_parent:MovieClip, t_name:String, t_depth:Number, t_data_obj:Object, t_accountID:String)
	{
		super(t_parent,t_name,t_depth);
		data_obj = t_data_obj;
		
		my_cm = new ContextMenu();
		my_cm.hideBuiltInItems();
		my_cm.customItems.push(new ContextMenuItem("Go to Flickr Page", Delegate.create(this, goToFlickrPage),false));
		if(t_accountID != null){
			accountID = t_accountID;
			my_cm.customItems.push(new ContextMenuItem("Go to Flickr Account", Delegate.create(this, goToFlickrAccount), false));
		}
		my_cm.customItems.push(new ContextMenuItem("Download original Image", Delegate.create(this, downloadOriginal), false));
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
		
		image_url = data_obj.thumb_url_str;
		file_ext = image_url.substring(image_url.lastIndexOf("."));
		
		// change final extension of the thumbnail to .jpg
		image_url = image_url.substr(0,image_url.lastIndexOf("_"))+"_s.jpg";
		if(_root._url.substr(0, 8) != 'file:///'){
			var tURL = _root._url.substring(7, _root._url.length);
			image_url = 'http://' + tURL.substring(0, tURL.indexOf('/')) + "/blog/phplib/loadRemoteImage.php?url=" + image_url;
		}
		createChildren();
		
		var me = this;
		downloadListener = new Object();
		downloadListener.onOpen = function(file:FileReference):Void {
			me.downloadBar_fdb = new FlickrDownloadBar(me.this_mc,"downloadbar_mc",10,55,3);
			me.downloadBar_fdb.move(10,75-6);
		}

		downloadListener.onProgress = function(file:FileReference, bytesLoaded:Number, bytesTotal:Number):Void {
			me.downloadBar_fdb.setPerc(bytesLoaded/bytesTotal);
		}
		downloadListener.onComplete = function(file:FileReference):Void {
			me.downloadBar_fdb.hide();
		}
		downloadListener.onIOError = function(file:FileReference):Void {
			trace("onIOError: " + file.name);
		}


		downloadFile = new FileReference ();
		downloadFile.addListener (downloadListener);
	}
	
	// ***************************
	// *****   P U B L I C   *****
	// ***************************
	
	/**
	* startLoading method starts the loading of the thumbnail
	*/
	
	public function startLoading( Void ) : Void
	{
		thumb_bt.loadMovie(image_url);
		loadStatus = "loading";
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
	
	private function goToFlickrPage ( obj:MovieClip, item:ContextMenuItem ) : Void
	{
		getURL(data_obj.permalink_str,"_blank");
	}
	
	private function goToFlickrAccount ( obj:MovieClip, item:ContextMenuItem ) : Void
	{
		getURL("http://www.flickr.com/photos/"+accountID+"/","_blank");
	}
	
	private function downloadOriginal ( obj:MovieClip, item:ContextMenuItem ) : Void
	{
		/* this is the trick to create the right url of the original image
		* using the fake extension of the thumbnail */
		var o_url = image_url.substr(0,image_url.lastIndexOf("_"))+"_o"+file_ext;
		downloadFile.cancel();
		downloadFile.download (o_url);
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
	* onThumbLoad is used to handle the cascade loading of thumbnails
	* inside the panel.
	* 
	* @param eventObject		the event object
	*/
	
	private function onThumbLoaded ( Void ) : Void
	{
		loadStatus = "loaded";
		var eventObject:Object = {target:this, type:'load'};  
		dispatchEvent(eventObject);
	}
	
	/**
	* __onRollOver dispatches the rollover event over the thumbnail to the listeners
	*/
	
	private function __onRollOver ( Void ) : Void
	{
		var eventObject:Object = {target:this, type:'rollOver', obj:data_obj};  
		dispatchEvent(eventObject);
	}
	
	/**
	* __onRollOver dispatches the rollout event over the thumbnail to the listeners
	*/
	
	private function __onRollOut ( Void ) : Void
	{
		var eventObject:Object = {target:this, type:'rollOut', obj:data_obj};  
		dispatchEvent(eventObject);
	}
	
	/**
	* __onRollOver dispatches the release event over the thumbnail to the listeners
	*/
	
	private function __onClick ( Void ) : Void
	{
		goToFlickrPage();
		var eventObject:Object = {target:this, type:'click', obj:data_obj};  
		dispatchEvent(eventObject);
	}
	
	
	
	// *****************************
	// *****   P R I V A T E   *****
	// *****************************
	
	/**
	* createChildren method creates all the movieclip needed inside the class
	*/
	
	private function createChildren ( Void ) : Void
	{
		thumb_bt = new BrushThumb(this_mc, "thumb_mc", 0, new Rectangle(0,0,75,75));
		thumb_bt.addEventListener("load", Delegate.create(this, onThumbLoaded));
		thumbColor = new Color(this_mc.thumb_mc);
		var me = this;
		this_mc.thumb_mc.onRelease = Delegate.create(this, __onClick);
		this_mc.thumb_mc.onRollOver = Delegate.create(this, __onRollOver);
		this_mc.thumb_mc.onRollOut = this_mc.thumb_mc.onReleaseOutside = Delegate.create(this, __onRollOut);
		
		blue_fl = new FlickrLed(this_mc, "blue_mc", 1, 0x1C73D2);
		blue_fl.move(null,76);
		blue_fl.setValue(data_obj.viewFactor_float);
		
		pink_fl = new FlickrLed(this_mc, "pink_mc", 2, 0xFD0095);
		pink_fl.move(null,79);
		pink_fl.setValue(data_obj.commentFactor_float);
	}
	
	/**
	* setLum method fades gradually the luminosity of the thumbnail
	*/
	
	public function setLum ( val:Number, speed:Number ) : Void
	{
		var me = this;
		this_mc.onEnterFrame = function(){
			me.thumbLum += (val-me.thumbLum)*speed;
			if(Math.round(me.thumbLum) == val){
				delete this.onEnterFrame;
				me.thumbLum = val;
			}
			var t = {ra:100,rb:me.thumbLum,ga:100,gb:me.thumbLum,ba:100,bb:me.thumbLum,aa:100,ab:0};
			me.thumbColor.setTransform(t);
		}
	}
	
}