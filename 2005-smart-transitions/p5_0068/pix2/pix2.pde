
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
	pause=100;
}

void loop(){
        //saveFrame("pix_####");
	if(!inited){
		if(pixels[int(random(npixels))]!=black){
			initApp();
		}
	}
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
	if(count<pause){
		return;
	}
	count=0;
	for(int i=0; i<npixels; i++){
		stamp[i]=pixels[i];
	}
	image(video, 0, 0);
	for(int i=0; i<npixels; i++){
		pixs[i].update();
	}
	//
	int x,y;
	for(int i=0; i<npixels; i++){
		x=int(random(w));
		y=int(random(h));
		pixs[i].setEnd(random(w),random(h));
		pixs[i].startMoving();
	}
	for(int i=0; i<npixels; i++){
		pixels[i]=stamp[i];
	}
        //
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
void initApp(){
	println("init app");
	int x,y;
	for(int i=0; i<npixels; i++){
		try{
			pixs[i].update();
			pixs[i].setEnd(random(w),random(h));
		}catch(Exception e){
			println(e);
		}
	}
	count=0;
	inited=true;
}
//
void printArray(float[] arr){
  for(int i=0; i<arr.length; i++){
    print(arr[i]+",");
  }
  println(" ");
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
		xi=tx;
		yi=ty;
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
	void setEnd(float tx, float ty)
	{
		xf=int(tx);
		yf=int(ty);
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
