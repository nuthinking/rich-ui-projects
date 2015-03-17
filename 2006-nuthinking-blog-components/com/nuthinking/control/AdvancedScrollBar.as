/**
* @fileoverview AdvancedScrollBar class, particular usefull for abstract panels
*
* @author Christian Giordano - http://nuthinking.com
* @version 1.0
*/

/**
* usage:

import com.nuthinking.control.AdvancedScrollBar;
import mx.utils.Delegate;
import mx.events.EventDispatcher;

var test_ss = new AdvancedScrollBar(this, "scrollbar_mc", 0, 8, 0x3294AD, 0xffffff, 1, null, null, 14);
test_ss.addEventListener ( "scroll", Delegate.create(this,onScroll));
test_ss.move(300, 30);
test_ss.initBar(220, content_txt._y, content_txt._height+10, 220);
test_ss.onRollOver = function(){
	test_ss.expand();
}
test_ss.onRollOut = function(){
	test_ss.collapse();
}

function onScroll ( event_obj:Object ) : Void
{
	content_txt._y = event_obj.target.content_y;
}

*/

import mx.utils.Delegate;
import mx.events.EventDispatcher;

class com.nuthinking.control.AdvancedScrollBar
{
	// new mcs
	private var this_mc:MovieClip;
	private var bg_mc:MovieClip;
	private var scroll_mc:MovieClip;
	private var activator_mc:MovieClip;
	
	// passed parameters
	private var target_mc:MovieClip;
	public var width:Number = 12;
	private var base_color:Number					= 0x000000;
	private var scroll_color:Number					= 0xffffff; // it will be alphed
	private var bordersize:Number					= 0;
	private var border_color:Number					= 0x000000;
	private var alignment:String					= "right"; // or "left" or "center"
	
	private var availableHeight:Number;
	private var contentHeight:Number;
	private var height:Number;
	
	
	// new attributes
	public var content_y:Number						= 0;
	private var initial_width:Number;
	private var final_width:Number;
	private var initial_x:Number					= 0;
	private var scroll_height:Number;
	private var factor:Number;
	private var yi:Number;
	private var mouseListener:Object;
	private var isDragging:Boolean					= false;
	private var activator_dx:Number;
	
	function dispatchEvent() {};
 	function addEventListener() {};
 	function removeEventListener() {};
	
	/**
	* This is the constructor
	*
	* @param t_parent					the timeline (movieclip) where the scrollbar will be created
	* @param t_name						the name of the movieclip that will be created and will contain the graphics
	* @param t_depth					the depth of the movieclip in the timeline
	* @param t_width (optional)			the initial width of the scrollbar, default value is 12px
	* @param t_base_color (optional)	the background color of the scrollbar, default is 0x000000 (black)
	* @param t_scroll_color (optional)	the color of the scrolling part, default is 0xffffff (white)
	* @param t_bordersize (optional)	the size of the border around the scrolling part, default is 0px
	* @param t_border_color (optional)	the color of the border around the scrolling part, default is 0x000000 (black)
	* @param t_alignment (optional)		the side the scrollbar will be fixed in case of expansion, default is "right"
	* @param t_final_width (optional)	the width the scrollbar will have when expanded
	* 
	*/
	
	function AdvancedScrollBar(t_parent:MovieClip,t_name:String,t_depth:Number,t_width:Number,t_base_color:Number,t_scroll_color:Number,t_bordersize:Number,t_border_color:Number, t_alignment:String, t_final_width:Number)
	{
		this_mc = t_parent.createEmptyMovieClip(t_name,t_depth);
		if(t_width != null) width = t_width;
		if(t_base_color != null) base_color = t_base_color;
		if(t_scroll_color != null) scroll_color = t_scroll_color;
		if(t_bordersize != null) bordersize = t_bordersize;
		border_color = (t_border_color != null ? t_border_color : base_color);
		if(t_alignment != null) alignment = t_alignment;
		final_width = (t_final_width != null ? t_final_width : width);
		
		initial_width = width;
		
		createChildren();
		
		var me = this;
		mouseListener = {};
		mouseListener.onMouseMove = function() {
			if(me.isDragging){
				me.__onScroll();
			}else if(!me.mouseIn()){
				me.makeInactive();
			}
		};
		
		EventDispatcher.initialize(this);
	}
	
	// ***************************
	// *****   P U B L I C   *****
	// ***************************

	/**
	* The following 4 methods will wrap the _yscale and _visible property to the movieclip
	*/

	function get _yscale ():Number {
		return this_mc._yscale;
	}
	function set _yscale (v):Void {
		this_mc._yscale = v;
	}
	
	function get _visible ():Boolean {
		return this_mc._visible;
	}
	function set _visible (v):Void {
		this_mc._visible = v;
	}
	
	/**
	* expand method is uses to change the width from the initial width to the final width
	*
	* @param t_speed (optional)			the speed of the transition, it has to be bigger than 0 and smaller or equals to 1.
	* 									Bigger means faster. It's optional and default value is 0.5.
	*/
	
	public function expand ( t_speed:Number ) : Void
	{
		var speed = (t_speed != null ? t_speed : .5);
		var w = final_width;
		var xf;
		switch (alignment)
		{
			case "left":
				xf = initial_x;
				break;
			case "center":
				xf = initial_x - Math.round((w - initial_width) * .5);
				break;
			case "right":
				xf = initial_x - ( w - initial_width);
				break;
		}
		
		var me = this;
		var x = this_mc._x;
		scroll_mc.onEnterFrame = function ()
		{
			me.width += (w - me.width) * speed;
			x += (xf - x) * speed;
			if(Math.round(me.width) == Math.round(w) && Math.round(x) == Math.round(xf)){
				delete this.onEnterFrame;
				me.width = w;
				x = xf;
			}
			me.this_mc._x = x;
			me.activator_mc._x = me.activator_dx - (x - me.initial_x);
			me.draw();
		}
	}
	
	/**
	* collapse method is uses to change the width from the final width to the initial width
	*
	* @param t_speed (optional)			the speed of the transition, it has to be bigger than 0 and smaller or equals to 1.
	* 									Bigger means faster. It's optional and default value is 0.5.
	*/
	
	public function collapse ( t_speed:Number ) : Void
	{
		var speed = (t_speed != null ? t_speed : .5);
		var xf = initial_x;
		var w = initial_width;
		var me = this;
		var x = this_mc._x;
		scroll_mc.onEnterFrame = function ()
		{
			me.width += (w - me.width) * speed;
			x += (xf - x) * speed;
			if(Math.round(me.width) == Math.round(w) && Math.round(x) == Math.round(xf)){
				delete this.onEnterFrame;
				me.width = w;
				x = xf;
			}
			me.this_mc._x = x;
			me.activator_mc._x = me.activator_dx - (x - me.initial_x);
			me.draw();
		}
	}
	
	/**
	* move method is meant to simplify the positioning actions
	*
	* @param x							the new _x of the whole scrollbar. If null it won't be changed.
	* @param y							the new _y of the whole scrollbar. If null it won't be changed.
	*/
	
	public function move(x:Number,y:Number):Void
	{
		if( x != null) this_mc._x = x;
		if( y != null) this_mc._y = y;
		
		initial_x = this_mc._x;
	}
	
	/**
	* clear method is meant to remove the scrollbar liberating more resources as possible
	*/

	public function clear(Void):Void
	{
		this_mc.removeMovieClip();
	}
	
	/**
	* initBar method is the one called to resize initially the scrollbar passing the parameters necessary
	* to calculate the relations with the target object
	*/
	
	public function initBar(t_availableHeight:Number, t_content_yi:Number, t_contentHeight:Number,t_height:Number)
	{
		if(t_contentHeight<=t_availableHeight){
			this_mc._visible = false;
			return;
		}
		this_mc._visible = true;
		yi = content_y = t_content_yi;
		availableHeight=t_availableHeight;
		contentHeight=t_contentHeight;
		height=t_height;
		scroll_height=Math.floor(t_availableHeight/t_contentHeight*t_height);;
		factor=(t_contentHeight-t_availableHeight)/(t_height-scroll_height);
		
		draw();
	}
	
	/**
	* updateScroll method is meanth to be called when the target position changes value for commands outside this class.
	*/
	
	public function updateScroll ( cy:Number ) : Void
	{
		content_y = cy;
		scroll_mc._y = Math.round((yi - content_y)/factor);
	}
	
	// ***************************
	// *****   E V E N T S   *****
	// ***************************
	
	/**
	* The following declared methods are created to give the possibilities to associate standar mouse events to the scrollbar
	*/
	
	public function onRollOver ( Void ) : Void {}
	public function onRollOut ( Void ) : Void {}
	public function onRelease ( Void ) : Void {}
	
	/**
	* The following methods are the internal events called while standard mouse actions happen. The dispatch the events
	* and call the ones that can be implemented from outside the class.
	*/

	private function __onRollOver ( Void ) : Void
	{
		var eventObject:Object = {target:this, type:'rollover'};  
		dispatchEvent(eventObject);
		onRollOver();
	}
	
	private function __onRollOut ( Void ) : Void
	{
		var eventObject:Object = {target:this, type:'rollout'};  
		dispatchEvent(eventObject);
		onRollOut();
	}
	
	private function __onRelease ( Void ) : Void
	{
		var eventObject:Object = {target:this, type:'release'};  
		dispatchEvent(eventObject);
		onRelease();
	}
	
	/**
	* __onScroll method is called to update the target position value and dispatch the event.
	*/
	
	private function __onScroll ( Void ) : Void
	{
		content_y = Math.round(yi-(scroll_mc._y*factor));
		var eventObject:Object = {target:this, type:'scroll'};  
		dispatchEvent(eventObject);
	}
	
	// *****************************
	// *****   P R I V A T E   *****
	// *****************************
	
	/**
	* The mouseIn method checks the rollover without using the movieclip method,
	* probably there could be issues if the _x and _y of the _root are not equal to 0.
	*/
	
	private function mouseIn(Void):Boolean
	{
		return activator_mc.hitTest(_root._xmouse, _root._ymouse, false);
	}
	
	/**
	* makeActive method that is called on rollover (on activator_mc)
	*/
	
	private function makeActive ( Void ) : Void
	{
		activator_mc._visible = false;
		Mouse.addListener(mouseListener);
		__onRollOver();
	}
	
	/**
	* makeInactive method that is called on rollout (!mouseIn)
	*/

	private function makeInactive ( Void ) : Void
	{
		activator_mc._visible = true;
		Mouse.removeListener(mouseListener);
		__onRollOut();
	}
	
	/**
	* init method associate all the events to the objects in the scrollbar and set up the allignement
	*/
	
	private function init(Void):Void
	{
		var me=this;
		scroll_mc._alpha=80;
		scroll_mc.onRollOver=function(){
			this._alpha=100;
		}
		scroll_mc.onRollOut=function(){
			this._alpha=80;
			if(!me.mouseIn() && !me.isDragging) me.makeInactive();	
		}
		scroll_mc.onPress=function(){
			me.isDragging = true;
			this.startDrag(false,0,0,0,me.height-me.scroll_height);
		}
		scroll_mc.onRelease = function(){
			delete this.onEnterFrame;
			stopDrag();
			me.isDragging = false;
			me.__onRelease();
		}
		
		scroll_mc.onReleaseOutside = function(){
			this._alpha=80;
			delete this.onEnterFrame;
			stopDrag();
			me.isDragging = false;
			if(!me.mouseIn()) me.makeInactive();
			me.__onRelease();
		}
		
		bg_mc.useHandCursor=false;
		bg_mc.onPress=function(){
			if(me.this_mc._ymouse < me.scroll_mc._y){
				me.scrollUp();
			}else if(me.this_mc._ymouse > me.scroll_mc._y + me.scroll_mc._height){
				me.scrollDown();
			}
			var delay = 3;
			var count = 0;
			this.onEnterFrame = function ()
			{
				if(++count < delay) return;
				count = 0;
				if(me.this_mc._ymouse < me.scroll_mc._y){
					me.scrollUp();
				}else if(me.this_mc._ymouse > me.scroll_mc._y + me.scroll_mc._height){
					me.scrollDown();
				}
			}
		}
		bg_mc.onRollOut = bg_mc.onRelease = bg_mc.onReleaseOutside = function(){
			delete this.onEnterFrame;
		}
		
		activator_mc.useHandCursor = false;
		activator_mc.onRollOver = Delegate.create(this,makeActive);
		
		switch (alignment)
		{
			case "left":
				break;
			case "center":
				activator_mc._x =  - Math.round((final_width - initial_width) * .5);
				break;
			case "right":
				activator_mc._x =  - ( final_width - initial_width);
				break;
		}
		activator_dx = activator_mc._x;
	}
	
	/**
	* scrollDown method is called when we click the scrollbar underneath the scrolling part for a fast scrolling
	*/

	private function scrollDown(Void):Void
	{
		scroll_mc._y=Math.min(height-scroll_mc._height,scroll_mc._y+=scroll_mc._height);
		__onScroll();
	}
	
	/**
	* scrollUp method is called when we click the scrollbar over the scrolling part for a fast scrolling
	*/

	private function scrollUp(Void):Void
	{
		scroll_mc._y=Math.max(0,scroll_mc._y-=scroll_mc._height);
		__onScroll();
	}
	
	/**
	* the method draw draw the graphic elements, called also during resizing
	*/
	
	private function draw ( Void ) : Void
	{
		bg_mc.clear();
		drawRectangle(bg_mc,0,0,width,height,base_color);
		activator_mc.clear();
		drawRectangle(activator_mc,0,0,final_width,height,0xFF0000);
		scroll_mc.clear();
		if(bordersize>0){
			drawRectangle(scroll_mc,0,0,width,scroll_height,border_color);
		}
		drawRectangle(scroll_mc,bordersize,bordersize,width-bordersize*2,scroll_height-bordersize*2,scroll_color);
	}
	
	/**
	* createChildren method creates all the movieclip needed inside the class
	*/
	
	private function createChildren ( Void ) : Void
	{
		bg_mc=this_mc.createEmptyMovieClip("bg_mc",0);
		scroll_mc=this_mc.createEmptyMovieClip("scroll_mc",1);
		activator_mc = this_mc.createEmptyMovieClip("activator_mc",2);
		activator_mc._alpha = 0;
		
		init();
	}
	
	/**
	* drawRectangle method helps to simplify the drawing of all the graphics part being rectangles
	* 
	* @param mc							the timeline (movieclip) where to draw the rectangle
	* @param x							the x position of the rectangle inside the timeline
	* @param y							the y position of the rectangle inside the timeline
	* @param w							the width size of the rectangle inside the timeline
	* @param h							the height size of the rectangle inside the timeline
	* @param c							the color of the rectangle
	*/
	
	private function drawRectangle(mc:MovieClip,x:Number,y:Number,w:Number,h:Number,c:Number)
	{
		mc.beginFill(c);
		mc.moveTo(x,y);
		mc.lineTo(x+w,y);
		mc.lineTo(x+w,y+h);
		mc.lineTo(x,y+h);
		mc.lineTo(x,y);
		mc.endFill();
	}
}