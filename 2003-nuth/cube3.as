dRoot=this;
titoli_array=[];
titoli_array[0]=["NUTHINKING  ","PHILOSOPHY  ","WHATWEDO","PORTFOLIO   ","CONTACT "];
titoli_array[1]=["PHILOSOPHY  ","EXPERIENCE  ","APPROACH","PROCESS ","BACK"];
titoli_array[2]=["WHATWEDO","GRAPHIC ","ANIMATIONS  ","INTERACTIVE ","BACK"];
titoli_array[3]=["PORTFOLIO   ","WEBSITES","CDROMS  ","ANIMATIONS  ","BACK"];
titoli_array[4]=["CONTACT ","","","","BACK"];
//
testi_array=[];
//
testi_array[1]=[];
testi_array[1][1]="Through NuThinking users can discover the utility of new multimedia technology in improving their experience. \nThese factors besides helping the user to simplify and cheer our jobs' reception of the contents, make it easier for the same customer thanks to their features.";

testi_array[1][2]="Generally within the new-media environment, the lifiteme of a communication project is relatively short. \nNuthinking offers to customer long lasting solutions with updated and futuristic technology. \nOur approach is focused primarily to establish a perfect relationship with the client, considering him/her as the main actor in the project development. \nThe client's involvement in the project is extremely important to make it responding to the company's requirements, in terms of philosophy, target and communication.";

testi_array[1][3]="With the aim of obtaining the best results optimizing works and reducing the waste of energy, Nuthinking takes care of all the steps behind the project's development. \nSummirizing, we think some of theese important steps are: \n \n- Study the identity of the client \n- Understanding the needs of the client \n- Understanding the targets of the project \n- Choose the right means \n- Understanding the right components to create a team \n- Choose the right language for the communication \n- Choose the right design style \n- Development of the product \n- Testing the technology required \n- Possible modifications \n- The end product";
//

testi_array[2]=[];
testi_array[2][1]="For a society, to face the problem to communicate is already a first step in the direction of a qualification of the assets and the services that it produces. \nNuthinking with its competence in piloting the attention, in operating visible distinctions, with its ability to attribute to a shape and an identity to the communication, contributes to confer existence and consistency to your communication.";

testi_array[2][2]="Nuthinking creates any form of animation or media format. \nThanks to our updated background of technology we are able to impress your users. \nIt is a pleasure for us to use our best creativity, never missing to reach the target of the project.";

testi_array[2][3]="Nuthinking creates interactive products for all the media services (www, CD-Roms, DVD's, games, kiosks). \nWe believe that using an intensive interaction of all the media services is important to make the client feels like the masterpiece of the project, modifying his experience through his actions and letting communicate with us and with other users.";
//

//
testi_array[3]=[];
testi_array[3][1]="- e10dance \n- NuThinking \n- CGWS \n- Gritti & Sherrard \n- Moavero";
testi_array[3][2]="- St.Jude Medical Europe";
testi_array[3][3]="- HTML.it contest \n- Fi-Credits";
//
testi_array[4]=["NuThinking is located in Monza, a very closer town near Milan (Italy). \n \nNuThinking S.r.l. \nVia Cavour, 2 \n20052 Monza (MI) \nItaly \n \nTelephone and fax: \n+39 039 2303277 \n \nE-mail: \ninfo@nuthinking.com \n \nFounder: \nChristian Giordano \n+39 335 6855817 \nchristian@nuthinking.com"];
//
titoli=[];
for(var i=0; i<titoli_array.length; i++){
	titoli[i]=[];
	for(var j=0; j<5; j++){
		titoli[i][j]=[];
		for(var k=0; k<titoli_array[i][j].length; k++){
			var pos=k%4;
			titoli[i][j][pos]+=titoli_array[i][j].substr(k,1);
		}
	}
}
/*
titoli[0]=[["NIN","UNG","TK ","HI "],["WW","HE","AD","TO"],["POH","HSY","IO ","LP "],["PFO","OO ","RL ","TI "],["CA","OC","NT","T "]];
titoli[1]=[["WW","HE","AD","TO"],["AAN","NTS","II ","MO "],["IRI","NAV","TCE","ET "],["GH","RI","AC","P "],["B","A","C","K"]];
titoli[2]=[["POH","HSY","IO ","LP "],["CSI","RMA","OE ","SD "],["AO","PA","PC","RH"],["PE","RS","OS","C "],["B","A","C","K"]];
titoli[3]=[["PFO","OO ","RL ","TI "],["WI","ET","BE","SS"],["CM","DS","R ","O "],["AAN","NTS","II ","MO "],["B","A","C","K"]];
titoli[4]=[["CA","OC","NT","T "],[],[],[],["B","A","C","K"]];*/
colori=[]
colori[0]=["0xF0182E","0x6BEE1C","0x17E8F2","0xC51AF0","0xE7F217"];
//
colori[1]=["0x6BEE1C","0x70D931","0x75C446","0x7AAF5B","0x666666"];
colori[2]=["0x17E8F2","0x32CED6","0x4EB5BB","0x699DA0","0x666666"];
colori[3]=["0xC51AF0","0xB435D5","0xA44FBA","0x946A9F","0x666666"];
colori[4]=["0xE7F217","0xCDD632","0xB5BB4E","0x9DA069","0x666666"];
//
livello=0;
areaSel=0;
path=pathIn="nuthinking/";
path_txt.text=pathIn;
l0.stop();
home_btn.enabled=false;
function pulisciTitolo(titolo){
	titolo=titolo.toLowerCase();
	var testo="";
	for(var i=0; i<titolo.length; i++){
		var lett=titolo.substr(i,1);
		if(lett != " "){
			testo+=lett;
		}
	}
	return testo;
}
function cambiaParola(liv,id){
	for(var i=0; i<4; i++){
		this["l"+i].lettere=titoli[liv][id][i];
		this["l"+i].gotoAndStop("attesa");
		this["l"+i].cLett=0;
		colori_obj["col"+i].setRGB(colori[liv][id]);
	}
	l0.gotoAndPlay(1);
}
function insButt(mc){
	trace("fn: insButt");
	mc.attachMovie("butt_trasp", "butt",0);
	mc.butt._alpha=0;
	mc.butt.onRollOver=function(){
		if(!entra){
			cambiaParola(areaSel,this._parent.id+1);
			if(livello==0){
				path2_txt._x=path_txt._x+path_txt.textWidth+.5;
				trace("rollover: "+titoli_array[areaSel][this._parent.id+1]);
				path2_txt.text=titoli_array[areaSel][this._parent.id+1].toLowerCase();
			}else{
				if(this._parent.id==3){
					path2_txt.text=testo+"/";
					path_txt.text=pathIn;
					path2_txt._x=path_txt._x+path_txt.textWidth+.5;
				}else{
					path2_txt._x=path_txt._x+path_txt.textWidth+.5;
					trace("rollover: "+titoli_array[areaSel][this._parent.id+1]);
					path2_txt.text=titoli_array[areaSel][this._parent.id+1].toLowerCase();
				}
			}
		}
	}
	mc.butt.onRollOut=mc.butt.onReleaseOutside=function(){
		if(!entra){
			cambiaParola(areaSel,0);
			if(livello==0){
			}else{
				path_txt.text=path;
			}
			path2_txt._x=2000;
		}
	}
	mc.butt.onRelease=function(){
		path2_txt._x=2000;
		for(var j=0; j<4; j++){
			_root["l"+j].play();
		}
		if(livello==0){
			areaSel=this._parent.id+1;
			if(this._parent.id==3){
				trace("click su Contact");
				path_txt.text=pathIn+"contact/";
				testo="";
				entra=true;
				areaSel_2=0;
				//areaSel=0;
			}else{
				home_btn.enabled=true;
				livello=1;
				testo=pulisciTitolo(titoli_array[areaSel][0]);
				//trace("areaSel: "+titoli_array[areaSel]);
				path=pathIn+testo+"/"
				path_txt.text=path;
			}
		}else{
			if(this._parent.id==3){
				areaSel=0;
				livello=0;
				path_txt.text=pathIn;
			}else{
				areaSel_2=this._parent.id+1;
				entra=true;
				path_txt.text=path+pulisciTitolo(titoli_array[areaSel][areaSel_2]).toLowerCase()+"/";
			}
		}
		fine=true;
		c_fine=0;
		mcNoButt=this._parent;
		this.removeMovieClip();
		//this.enabled=false;
		//cambiaParola(areaSel,this._parent.id+1);
	}
}
home_btn.onRelease=function(){
	areaSel=0;
	livello=0;
	path_txt.text=pathIn;
	path=pathIn
	fine=true;
	c_fine=0;
	this.enabled=false;
	cambiaParola(areaSel,0);
}
cambiaParola(0,0);
for(var i=0; i<4; i++){
	var clip=this["l"+i];
	clip.id=i;
	insButt(clip);
}
colori_obj=new Object();
for(var i=0; i<4; i++){
	colori_obj["col"+i]=new Color(this["q"+i].cop_mc.colorato);
}
sfondi_clr=new Color();
MovieClip.prototype.assolvi=function(val){
	this.onEnterFrame=function(){
		//trace(val);
		var da=(val-this._alpha)/10;
		this._alpha+=da;
		//trace(this._alpha+" : "+ val);
		//trace("da: "+da);
		if(Math.abs(da)<0.4){
			//trace("fine");
			this._alpha=val;
			delete this.onEnterFrame;
		}
	}
}
function dissolvi(){
	this._alpha+=(0-this._alpha)/10;
	if(this._alpha<=1){
		//trace("dissolto");
		this._alpha=0;
		delete this.onEnterFrame;
	}
}
mc2dis=null;
dRoot.onEnterFrame=function(){
	//if(cursore._x>=50 && cursore._x<850){
		if(cursore._x<220){
			t_mc=0;
		}else if(cursore._x<420){
			t_mc=1;
		}else if(cursore._x<620){
			t_mc=2;
		}else{
			t_mc=3;
		}
		if(t_mc!=mc2dis){
			//trace("IN");
			for(var i=0; i<4; i++){
				val=100-(Math.abs(i-t_mc)*33);
				this["q"+i].cop_mc.assolvi(val);
			}
			mc2dis=t_mc;
			/*
			this["q"+mc2dis].cop_mc.onEnterFrame=dissolvi;
			trace("assolvi: "+t_mc);
			this["q"+mc2dis].cop_mc.onEnterFrame=assolvi;*/
		}
	//}else{
		/*
		t_mc=4;
		if(t_mc!=mc2dis){
			//trace("OUT");
			for(var i=0; i<4; i++){
				this["q"+i].cop_mc.assolvi(0);
			}
			mc2dis=null;
		}
	}*/
}
function backRoll(){
	trace("fn: backRoll");
	x_ref=x0;
	var titolo="BACK";
	var b=0;
	var count=3;
	dRoot.onEnterFrame=function(){
		if(count>=2){
			if(b<titolo.length && titolo.substr(b,1)!=" "){
				var q=this.attachMovie("q_titolo","b_"+b, b+20);
				var colore=new Color(q.sfondo_mc);
				colore.setRGB("0xBABABA");
				q.char=titolo.substr(b,1);
				q._x=x_ref;
				q._y=20;
				x_ref+=20;
				b++;
			}else{
				delete this.onEnterFrame;
			}
			count=0;
		}else{
			count++;
		}
	}
}
function backRollOut(){
	delete dRoot.onEnterFrame;
	for(var i in dRoot){
		if(dRoot[i]._name.substr(0,2)=="b_"){
			dRoot[i].gotoAndPlay(8);
		}
	}
}
function entraSez(){
	home_btn.enabled=false;
	copertura_mc.onEnterFrame=function(){
		this._y+=0.1+((250-this._y)/5);
		if(this._y>=250){
			//trace("copertura arrivata");
			this._y=250;
			delete this.onEnterFrame;
		}
	}
	componiTesto();
	for(var j=0; j<4; j++){
		dRoot["l"+j].butt.enabled=false;
	}
	var titolo=titoli_array[areaSel][areaSel_2];
	//path_txt.text=pathIn+titolo.toLowerCase()+"/";
	trace("titolo: "+titolo);
	old_ent=dRoot.onEnterFrame;
	c=0;
	x0=20;
	var count=3;
	dRoot.onEnterFrame=function(){
		if(count>=2){
			if(c<titolo.length && titolo.substr(c,1)!=" "){
				var q=this.attachMovie("q_titolo","q_"+c, c);
				var colore=new Color(q.sfondo_mc);
				colore.setRGB(colori[areaSel][areaSel_2]);
				q.char=titolo.substr(c,1);
				q._x=x0;
				q._y=20;
				x0+=20;
				c++;
			}else{
				var q=this.attachMovie("q_titolo_back","q_"+c, c);
				q._x=x0;
				q._y=20;
				x0+=20;
				delete this.onEnterFrame;
			}
			count=0;
		}else{
			count++;
		}
	}
}
function esciSezione(){
	var count=3;
	thumb_mc.gotoAndStop(2);
	var testo_array=testo_mc.testo1_txt.text.split("\r");
	var testo2_array=testo_mc.testo2_txt.text.split("\r");
	testo_mc.onEnterFrame=function(){
		if(testo2_array.length>0){
			//trace("testo2_array: "+testo2_array);
			//trace("testo2_length: "+testo2_array.length);
			testo2_array.splice(testo2_array.length-1,1);
			temp_array=testo2_array.slice(0);
			this.testo2_txt.text=temp_array.join("\r");
		}else if(testo_array.length>0){
			testo_array.splice(testo_array.length-1, 1);
			temp_array=testo_array.slice(0);
			this.testo1_txt.text=temp_array.join("\r");
		}else{
			delete this.onEnterFrame;
		}

	}
	dRoot.onEnterFrame=function(){
		if(count>=2){
			if(c>=0){
				var q=this["q_"+c];
				q.play();

				c--;
			}else{
				delete this.onEnterFrame;
			}
			count=0;
		}else{
			count++;
		}
	}
	trace("path: "+path);
	path_txt.text=path;
}
function riparti(){
	if(areaSel_2==0) {
		areaSel=0;
	}else{
		home_btn.enabled=true;
	}
	trace("livello: "+livello);
	trace("areaSel: "+areaSel);
	//cambiaParola(areaSel,0);
	entra=false;
	fine=false;
	c_fine=0;
	l0.play();
	for(var j=0; j<4; j++){
		dRoot["l"+j].butt.enabled=true;
	}
	dRoot.onEnterFrame=old_ent;
	copertura_mc.onEnterFrame=function(){
		this._y+=0.1+((170-this._y)/5);
		if(this._y<=190){
			//trace("copertura arrivata");
			this._y=190;
			delete this.onEnterFrame;
		}
	}
}
// T E S T O
testoTF = new TextFormat();
testoTF.font = "_sans";
testoTF.size = "11";
testoTF.leftMargin = 0;
testoTF.leading=0;
testoTF.color="0x666666";
function componiTesto(){
	dRoot.createEmptyMovieClip("testo_mc",100);
	dRoot.testo_mc.createTextField("testo1_txt",0,18,45,292,190);
	dRoot.testo_mc.createTextField("testo2_txt",2,328,45,292,190);
	var t=dRoot.testo_mc.testo1_txt;
	var t2=dRoot.testo_mc.testo2_txt;
	//trace("testo: "+testi_array[areaSel][areaSel_2]);
	t.selectable=false;
	t.wordWrap=true;
	t.setNewTextFormat(testoTF);
	t2.selectable=false;
	t2.wordWrap=true;
	t2.setNewTextFormat(testoTF);
	var testo_array=testi_array[areaSel][areaSel_2].split(" ");
	var testo2_array=testi_array[areaSel][areaSel_2].split("\n");
	//trace(testo2_array);
	var limit=1;
	var temp="";
	dRoot.testo_mc.onEnterFrame=function(){
		this.testo1_txt.text=testo_array[testo_array.length-1]+" "+this.testo1_txt.text;
		if(this.testo1_txt.maxscroll>limit){
			limit++;
			if(testo2_array[testo2_array.length-1]==" "){
				trace("scarica");
				temp+="\n";
			}else{
				this.testo2_txt.text=testo2_array[testo2_array.length-1]+temp+"\n"+this.testo2_txt.text;
				temp="";
			}
			testo2_array.splice(testo2_array.length-1,1);
		}
		testo_array.splice(testo_array.length-1,1);
		if(testo_array.length<1){
			trace("fine");
			img=dRoot.attachMovie("thumb_mc","thumb_mc",50);
			img._x=330;
			img._y=125;
			var colore=new Color(img.sfondo_mc);
			colore.setRGB(colori[areaSel][areaSel_2]);
			trace(areaSel+" "+areaSel_2);
			if(areaSel_2==0){
				var gap=1;
			}else{
				var gap=areaSel_2;
			}
			trace("gap: "+gap);
			frame=((areaSel-1)*3)+gap;
			trace("frame: "+frame);
			delete this.onEnterFrame;
		}
	}
}