// Class mappa

function Mappa(x,y,nome,val,perc,side){
	this.x=x;
	this.y=y;
	this.nome=nome;
	this.val=val;
	this.perc=perc;
	this.side=side;
	this.useHandCursor=false;
	trace(this._x);
}

Mappa.prototype=new MovieClip();

Mappa.prototype.onRollOver=function(){
	if(dRoot.azione){
		dRoot.track.addPoint(this.x,this.y);
		this._alpha=70;
		this.onEnterFrame=function(){ this._alpha=15+Math.random()*15; }
		this.mc=dRoot.attachMovie("etichetta","etichetta_"+dRoot.c_etichette,dRoot.c_etichette++,{x:this.x,yi:this.y,nome:this.nome,val:this.val,perc:this.perc,side:this.side});
		if(dRoot.c_etichette>=90) dRoot.c_etichette=0;
		dRoot.using=true;
		dRoot.bip_snd.start(0,1);
	}
}

Mappa.prototype.onRollOut=Mappa.prototype.onReleaseOutside=function(){
	if(dRoot.azione){
		delete this.onEnterFrame;
		this._alpha=0;
		this.mc.removeMe();
		dRoot.using=false;
		dRoot.srolla_snd.start(0,1);
	}
}