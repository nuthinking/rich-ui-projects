/**
* @fileoverview BrushThumb load images and create a brush effect when
* the image is loaded.
* Having an own physicity and containing other movieclips it extends
* CgwsUIComponent.
*
* @author Christian Giordano - http://nuthinking.com
* @version 1.0
*/

import com.nuthinking.CgwsUIComponent;
import flash.display.BitmapData;
import flash.geom.*;
import com.nuthinking.effects.BrushPath;
import mx.events.EventDispatcher;
import mx.utils.Delegate;

class com.nuthinking.image.BrushThumb extends CgwsUIComponent
{
	private var this_mc:MovieClip;
	private var bg_mc:MovieClip;
	private var img_mc:MovieClip;
	
	private var BG_COLOR:Number			= 0x181818;
	private var STROKE_COLOR:Number		= 0xFFFFFF;
	private var THUMB_HEIGHT:Number				= 75;
	private var alexia_folder_str:String;
	private var thumbLoader:MovieClipLoader		= null;
	private var thumbLoaderListener:Object		= null;
	public var width:Number;
	public var height:Number;
	
	private var mask_mc:MovieClip;
	private var picture_mask:BitmapData;
	
	/**
	* Constructor
	* 
	* @class FlickrMenuButton
	* 
	* @param t_parent		the MovieClip where to create our MovieClip
	* @param t_name			name of the MovieClip instance
	* @param t_depth		depth of our new MovieClip
	* @param t_rect			useful to define the size of the image
	*/
	
	function BrushThumb(t_parent:MovieClip, t_name:String, t_depth:Number, t_rect:Rectangle)
	{
		super(t_parent,t_name,t_depth);
		
		width = t_rect.width;
		height = t_rect.height;
		
		createChildren();
	}
	
	/**
	* loadMovie is the method to load an image by its url
	* 
	* NOTE: this kind of effect with Flash Player 8 requires that the pictures
	* are in the same server of the script. Solution is to have a serverside
	* file wrapper. This is far to be a brilliant solution but it seems Adobe
	* will fix soon this bug.
	* 
	* @param url		the url of the image
	*/
	
	public function loadMovie(url:String) : Void
	{
		delete mask_mc.onEnterFrame;
		picture_mask.dispose();

		if(thumbLoader != null){
			thumbLoader.removeListener(thumbLoaderListener);
		}
		var me = this;
		thumbLoader = new MovieClipLoader();
		thumbLoaderListener = {};
		thumbLoaderListener.onLoadInit = Delegate.create(this, onLoad)

		thumbLoader.addListener(thumbLoaderListener);
		thumbLoader.loadClip(url, img_mc);
		draw();
	}
	
	/**
	* loadThumb is the method to load an image by a post object. This object
	* is used only from some parts of my blog.
	* 
	* @param post_obj	the post object
	*/
	
	public function loadThumb(post_obj:Object) : Void
	{
		delete mask_mc.onEnterFrame;
		picture_mask.dispose();
		var thumb_url:String = null;
		var scaleFactor:Number = 1;
		height = THUMB_HEIGHT;
		width = 75;
		switch(post_obj.type_str){
			case "delicious":
				if(post_obj.thumb_url_str){
					thumb_url = alexia_folder_str + post_obj.thumb_url_str;
					scaleFactor = THUMB_HEIGHT/82;
					width = Math.floor(111*scaleFactor);
				}
				break;
			default:
				thumb_url = post_obj.thumb_url_str;
		}
		if(thumbLoader != null){
			thumbLoader.removeListener(thumbLoaderListener);
		}
		var me = this;
		thumbLoader = new MovieClipLoader();
		thumbLoaderListener = {};
		thumbLoaderListener.onLoadInit = function(target_mc:MovieClip):Void
		{
			target_mc._xscale = target_mc._yscale = scaleFactor*100;
			me.startTransition();
		}

		thumbLoader.addListener(thumbLoaderListener);
		thumbLoader.loadClip(thumb_url, img_mc);
		draw();
	}
	
	/**
	* unloadThumb unload the image loaded and free more resource as possible
	*/

	public function unloadThumb ( Void ) : Void
	{
		bg_mc.clear();
		thumbLoader.unloadClip(img_mc);
		delete mask_mc.onEnterFrame;
		picture_mask.dispose();
	}
	
	/**
	* onLoad method is triggered when the images is loaded, make the transition start
	* and dispatches the event "load". It's called if you use loadMovie method to load
	* the image.
	* 
	* @param target_mc			being wrapped by MovieClipLoader it passes the movieclip
	* 							where the images has been loaded, in this class is irrilevant.
	*/
	
	private function onLoad ( target_mc:MovieClip ) : Void
	{
		startTransition();
		var eventObject:Object = {target:this, type:'load'};  
		dispatchEvent(eventObject);
	}
	
	/**
	* onUnmasked method is called when the transition effect is finished and dispatches
	* the event "unmasked".
	*/
	
	private function onUnmasked ( Void ) : Void
	{
		bg_mc.clear();
		var eventObject:Object = {target:this, type:'unmasked'};  
		dispatchEvent(eventObject);
	}
	
	/**
	* createChildren method creates all the movieclip needed inside the class
	*/
	
	private function createChildren ( Void ) : Void
	{
		bg_mc = this_mc.createEmptyMovieClip("bg_mc",0);
		img_mc = this_mc.createEmptyMovieClip("img_mc", 1);
		
		var mask_mc:MovieClip = this_mc.createEmptyMovieClip("mask_mc", 10);
		
		draw ();
	}
	
	/**
	* draw method draws the graphic elements
	*/
	
	private function draw ( Void ) : Void
	{
		bg_mc.clear();
		drawRectMc(bg_mc, 0, 0, width, height, STROKE_COLOR);
		drawRectMc(bg_mc, 1, 1, width - 2, height - 2, BG_COLOR);
		bg_mc.lineStyle(1, STROKE_COLOR);
		bg_mc.moveTo(0,0);
		bg_mc.lineTo(width, height);
		bg_mc.moveTo(width, 0);
		bg_mc.lineTo(0, height);
	}
	
	/**
	* startTransition method make the effect start
	*/
	
	private function startTransition ( Void ) : Void
	{
		img_mc._visible = false;
		var brush_mask:BitmapData = BitmapData.loadBitmap("brush_alphed");
		var picture:BitmapData = new BitmapData(width, height, true, 0x00000000);
		var scaleMatrix = new Matrix();
		var scaleFactor = _width/img_mc._width;
		scaleMatrix.scale(scaleFactor,scaleFactor);
		picture.draw(img_mc,scaleMatrix);
		picture_mask = new BitmapData(_width, _height, true, 0x00000000);
		var mask_mc:MovieClip = this_mc.createEmptyMovieClip("mask_mc", 10);
		mask_mc.attachBitmap(picture_mask, 0, "auto", true);
		var npaths = 5;
		var nsteps = 10;
		var paths = [];
		for (var i = 0; i<npaths; i++) {
			paths.push(BrushPath.generatePath(picture.width, picture.height, 3, 150, nsteps));
		}
		var dist=1000000;
		var cx=picture.width*.5;
		var cy=picture.height*.5;
		var firstIndex=-1;
		for(var i=0; i<npaths; i++){
			var o=paths[i][nsteps-1];
			var t_dist=Math.sqrt((cx-o.x)*(cx-o.x)+(cy-o.y)*(cy-o.y));
			if(t_dist<dist){
				dist=t_dist;
				firstIndex=i;
			}
		}
		if(firstIndex!=0){
			var firstPath=paths[firstIndex];
			paths.splice(firstIndex,1);
			paths.unshift(firstPath);
		}
		var circles_arr = [];
		var count = 0;
		var nfact=nsteps*.2;
		var pm = picture_mask;
		var me = this;
		mask_mc.onEnterFrame = function() {
			for (var i = 0; i<npaths; i++) {
				var o = paths[i][count];
				var size = o.scale;
				var sizePerc = size*.01;
				var s = Math.round(brush_mask.width*sizePerc);
				var $brush_mask = new BitmapData(s, s, true, 0x00ffffff);
				var mask_mx = new Matrix();
				mask_mx.scale(sizePerc, sizePerc);
				$brush_mask.draw(brush_mask, mask_mx);
				var destPoint = new Point(o.x-s*.5, o.y-s*.5);
				pm.copyPixels(picture, new Rectangle(destPoint.x, destPoint.y, s, s), destPoint, $brush_mask, new Point(), true);
				$brush_mask.dispose();
			}
			count++;
			npaths = Math.floor((nsteps-count)/nfact)+1;
			if (count>=paths[0].length) {
				var ao=-253;
				
				count=0;
				this.onEnterFrame=function(){
					var colorTrans:ColorTransform = new ColorTransform();
					colorTrans.alphaOffset=ao;
					pm.draw(picture,new Matrix(),colorTrans);
					ao+=3;
					count++;
					if(count>=30){
						pm.draw(picture);
						me.onUnmasked();
						delete this.onEnterFrame;
					}
				}
			}
		};
	}
}
		