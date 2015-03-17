// *************************
// *****	 etichetta.as	*****
// *************************
//p1=0,-93
//p2=139,-93
//
//p3=0,-73
//p4=139,-73
//p5=0,66
//p6=139,66

function etichetta (){
	this._x=this.x;
	this.x0=-20;
	//this.yi=yi;
	//this.nome=nome;
	//this.val=val;
	//this.perc=perc;
	this.speed=5;
	if(this.side== "l"){
		this.lato=-1;
		this.gotoAndStop(2);
	}else{
		this.lato=1;
		this.gotoAndStop(1);
	}
	this.xo*=this.lato;
	this.init();
}

etichetta.prototype=new MovieClip();

etichetta.prototype.init=function(){
	this.etichetta1_mc.titolo1_txt.text=this.nome;
	this.etichetta1_mc.titolo2_txt.text=this.nome;
	this.etichetta1_mc.ettari1_txt.text=this.val;
	this.etichetta1_mc.ettari2_txt.text=this.val;
	this.etichetta2_mc.percentuale_txt.text=this.perc;
	this._y=500;
	this.etichetta2_mc.onEnterFrame=function(){
		//this._visible=!this._visible;
		this._alpha=Math.random()*50;
	}
	this.onEnterFrame=function(){
		var yf=this.yi+(_root._ymouse-this.yi)*3;
		this._y+=(yf-this._y)/this.speed;
		this.drawLines();
		this.etichetta2_mc._y=(_root._ymouse-this.yi)*4;
	}
}

etichetta.prototype.drawLines=function(){
	var y0=-this._y+this.yi;
	var mc=this.linee_mc;
	mc.clear();
	mc.lineStyle(1, 0xFF0000, 50);
	//
	mc.moveTo(this.x0,y0);
	mc.lineTo(0,-93);
	//
	mc.moveTo(this.x0,y0);
	mc.lineTo(139*this.lato,-93);
	//
	mc.lineStyle(1, 0xFFFFFF, 50);
	//
	mc.moveTo(this.x0,y0);
	mc.lineTo(0,-73);
	//
	mc.moveTo(this.x0,y0);
	mc.lineTo(139*this.lato,-73);
	//
	mc.moveTo(this.x0,y0);
	mc.lineTo(0,66);
	//
	mc.moveTo(this.x0,y0);
	mc.lineTo(139*this.lato,66);
}

etichetta.prototype.removeMe=function(){
	this.incremento=5;
	this.onEnterFrame=function(){
		this._alpha-=10;
		this._y-=this.incremento;
		this.drawLines();
		this.etichetta2_mc._y=this.yi+(_root._ymouse-this.yi)*4;
		if(this._y>-500){
			this.incremento*=1.5;
		}else{
			trace("RIMUOVIMI:"+this);
			this.removeMovieClip();
		}
	}
}

Object.registerClass("etichetta", etichetta);