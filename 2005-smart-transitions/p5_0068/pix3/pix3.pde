
int w;
int h;
int npixels;
//
Pix pixs[];
//
int count;
int pause;
boolean inited;
color black;
int gshift;
int rshift;
color stamp[];

void setup() {
	w=320;
	h=240;
	npixels=w*h;
	//
	size(w, h);
	beginVideo(w, h, 15);
	//
	int c=0;
	pixs=new Pix[npixels];
	stamp=new color[npixels];
	for(int y=0; y<h; y++){
		for(int x=0; x<w; x++){
			pixs[(w*y)+x]=new Pix(x,y);
			pixs[(w*y)+x].id=c;
			c++;
		}
	}
	//
	image(video, 0, 0);
	inited=false;
	black=color(0,0,0);
	gshift = 255<<8;
	rshift = 255<<16;
	pause=50;
}

void loop(){
	if(!inited){
		if(pixels[int(random(npixels))]!=black){
			initApp();
		}
	}
	//
	count++;
	for(int i=0; i<npixels; i++){
		try{
			pixs[i].moveMe();
			pixs[i].draw();
		}catch(Exception e){
			println(i+" "+e);
		}
	}
	//
	if(count>=pause){
		count=0;
		reasign();
	}
	//saveFrame("pix_####");
	/*
	//background(255);

	//
	// Catch the color
	//
	for(int i=0; i<letters.length; i++){
		//println(letters.length+" "+letters[i].length);
		for(int j=0; j<letters[i].length; j++){
			try {
				letters[i][j].getColor();
			} catch(Exception ex) {
				println(ex);
			}
		}
	}
	fill(255);
	rect(0,0,400,300);
	for(int i=0; i<letters.length; i++){
		for(int j=0; j<letters[0].length; j++){
			letters[i][j].draw();
		}
	}
	if(count<300){
		//saveFrame("ascii_####");
		count++;
	}*/
}
//
void initApp(){
	println("init app");
	int x,y;
	for(int i=0; i<npixels; i++){
		try{
			pixs[i].getEnd(int(random(npixels)));
			//pixs[i].update();
			//pixs[i].setEnd(random(w),random(h));
		}catch(Exception e){
			println(e);
		}
	}
	count=0;
	inited=true;
}
//
void reasign(){
	for(int i=0; i<npixels; i++){
		stamp[i]=pixels[i];
	}
	image(video, 0, 0);
	//
	color posa,posb;
	int range;
	int tolleration;
	boolean found;
	boolean isLower;
	for(int i=0; i<npixels; i++){
		range=1;
		tolleration=30;
		if(!isSimilar(pixs[i].c,pixels[i],tolleration)){
			//find new place
			posa=i-range;
			posb=i+range;
			found=false;
			isLower=true;
			while(!found){
				tolleration++;
				range++;
				posa=max(i-range,0);
				posb=min(i+range,npixels-1);
				if(isSimilar(pixs[i].c,pixels[posa],tolleration)){
					found=true;
					isLower=true;
				}else if(isSimilar(pixs[i].c,pixels[posb],tolleration)){
					found=true;
					isLower=false;
				}
			}
			if(isLower){
				pixs[i].getEnd(posa);
			}else{
				pixs[i].getEnd(posb);
			}
			pixs[i].startMoving();
		}else{
			pixs[i].c=pixels[i];
		}
	}
	//
	/*int x,y;
	for(int i=0; i<npixels; i++){
		x=int(random(w));
		y=int(random(h));
		pixs[i].setEnd(random(w),random(h));
		pixs[i].startMoving();
	}*/
	for(int i=0; i<npixels; i++){
		pixels[i]=stamp[i];
	}
}
//
void printArray(float[] arr){
  for(int i=0; i<arr.length; i++){
    print(arr[i]+",");
  }
  println(" ");
}
boolean isSimilar(color c1,color c2, int tolleration)
{
	//int tolleration=90;
	//
	int b1=c1 & 255;
	int g1=(c1 & gshift) >> 8;
	int r1=(c1 & rshift) >> 16;
	//
	int b2=c2 & 255;
	int g2=(c2 & gshift) >> 8;
	int r2=(c2 & rshift) >> 16;
	//
	//println(b1+" "+b2);
	//
	int difference = abs(b1-b2)+abs(g1-g2)+abs(r1-r2);
	/*if(difference>0){
	 println("diverso: "+difference);
	}*/
	//println(difference);
	if(difference>tolleration){
		//println("false: "+difference);
		return false;
	}else{
		//println("true: "+difference);
		return true;
	}
}
//        //
//  Pix   //
//        //
class Pix
{
	float x;
	float y;
	//
	int xi;
	int yi;
	//
	int xf;
	int yf;
	//
	float speed;
	//
	int id;
	//
	color c;
	color cf;
	//
	boolean has2move;
	//
	Pix(int tx, int ty)
	{
		x=xi=tx;
		y=yi=ty;
		has2move=false;
		//
		speed=10;
		/*
		int c=0;

		//
		xi=tx;
		yi=ty;
		int grado;
		float fact=255/alphabet.length;
		for(int i=0; i<alphabet.length; i++){
			grado=int(fact*i);
			colors[i]=color(grado,grado,grado);
		}
		fontSize=8;
	//println (this);*/
	}
	void update()
	{
		if(id==0){
			println("update");
		}
		x=xi;
		y=yi;
		c=pixels[int((w*y)+x)];
	}
	void getEnd(int pos)
	{
		int y=int(pos/w);
		int x=pos%w;
		setEnd(x,y);
	}
	void setEnd(int tx, int ty)
	{
		xf=tx;
		yf=ty;
		cf=pixels[(w*yf)+xf];
		//
		if(id==0){
			println("setEnd:"+xf+" - "+yf);
		}
	}
	void startMoving()
	{
		if(id==0){
			println("startMoving");
		}
		has2move=true;
		c=cf;
	}
	void moveMe()
	{
		if(!has2move){
			return;
		}
		x+=(xf-x)/speed;
		y+=(yf-y)/speed;
		//
		if(id==0){
			//print(x+"|"+y+" ");
		}
		//
		if(round(x*100)==xf*100 && round(y*100)==yf*100){
			//print(id+" ");
			x=xf;
			y=yf;
			if(id==0){
				println("arrived");
			}
			has2move=false;
		}
	}
	void draw()
	{
		int pos=int((w*round(y))+round(x));
		pixels[pos]=c;
		//if(pos<npixels){

		//}
		/*
		c=color(0,204,204,_alpha);
		fill(c);
		textFont(kfont, fontSize);
		text(lettera, xi, yi);
		if(fontSize>8){
			fontSize--;
		}*/
	}
	int round(float n)
	{
		float m=n%int(n);
		if(m>=.5){
			return int(n)+1;
		}else{
			return int(n);
		}
	}
	void getColor()
	{
		/*
		c=get(xi/5,yi/5);
		int t_index=index;
		for(int i=0; i<10;i++){
			if(c>colors[i]){
				t_index=i;
			}
		}
		if(t_index != index){
			change();
			index=t_index;
		}
		String list[] = splitStrings(alphabet[index], ',');
		lettera=list[int(random(list.length))];
		_alpha=255-(index*(255/alphabet.length));
		*/
	}
	void change()
	{
	}
}
