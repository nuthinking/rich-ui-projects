﻿class com.nuthinking.nuCover.elements.Banda_1 extends MovieClip
{
	private var wi : Number = 20;
	private var hi : Number = 20;
	private var angle : Number;
	private var speed : Number;
	private var rad : Number;
	private var sina : Number;
	private var cosa : Number;
	private var fact : Number = 100/wi;
	//
	private var tHeight : Number;
	private var tWidth : Number;
	private var colore ="00FF00";
	//
	function Banda_1(){
		this.beginFill(colore, 100);
		this.lineTo(20, 0);
		this.lineTo(20, 20);
		this.lineTo(0, 20);
		this.lineTo(0, 0);
		this.endFill();
		trace(this.tHeight+" : "+this.tWidth);
		var segno = this.angle/Math.abs(this.angle);
		this.rad=this.angle*Math.PI/180*segno;
		this.cosa=Math.cos(this.rad);
		this.sina=Math.sin(this.rad);
		//
		this._width=1;
		this._rotation=this.angle;
		var w=this._xscale/5;
		var h = this.sina*w;
		if(angle>0)this._y=-h;
		var cat=(-this._y+this.tHeight)/this.cosa;
		this._yscale=Math.sqrt((cat*cat)+(h*h))*5;
		this._x=Math.random()*this.tWidth;
		//
		this.onEnterFrame=function(){
			var w=this._width;
			this._xscale+=this._xscale*this.speed/25;
			this._x -= (this._width-w)/2;
			//
			var l=this._xscale/5;
			var h=this.sina*l;
			if(angle>0)this._y=-h;
			var cat=(h+this.tHeight)/ this.cosa;
			this._yscale=Math.sqrt((cat*cat)+(h*h))*this.fact;
			if(l>=tWidth*3){
				trace("finito");
				delete this.onEnterFrame;
			}
		}
	}
	//

}