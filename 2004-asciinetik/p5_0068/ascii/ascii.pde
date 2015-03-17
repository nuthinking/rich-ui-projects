
int DimX;
int DimY;
int nCell;
int Vel;
float Rall;
int Agg;
int Low;
float Xo[]=new float[7];
float Xd[]=new float[7];
float XoMo[]=new float[7];
float LX[]=new float[7];
//
float Yo[]=new float[7];
float Yd[]=new float[7];
float YoMo[]=new float[7];
float LY[]=new float[7];
//
Letter letters[][]=new Letter[80][60];
//BImage[] imgs;
//BImage[] portions= new BImage[7];
BFont kfont;
int count;

void setup() {
	size(400, 300);
	beginVideo(80, 60, 30);
	kfont = loadFont("kroeger_05_53.vlw");
	//textFont(kfont, 8);
	int margin=5;
	//
	int laX=0;
	int laY=0;
	for(int i=0; i<letters.length; i++){
		for(int j=0; j<letters[0].length; j++){
			letters[i][j]= new Letter(laX,laY);
			laY+=margin;
		}
		laX+=margin;
		laY=0;
	}
	count=0;
}

void loop(){
	//background(255);
	image(video, 0, 0);
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
	}
}

void printArray(float[] arr){
  for(int i=0; i<arr.length; i++){
    print(arr[i]+",");
  }
  println(" ");
}
//        //
//  Quad  //
//        //
class Letter
{
	int xi;
	int yi;
	int index;
	color c;
	float _alpha;
	String lettera;
	color colors[]=new color[16];
	String alphabet[]=new String[16];
	int fontSize;
	/*
	i = 4	j,l = 5	I = 5	1,r = 6	f,t,J,Y = 7	7,c,o,v,x,L = 8	a,n,u,T,V,X = 9	e,h,k,s,z = 10	4,b,d,C,K,U = 11	0,g,p,y,F,O,P = 12	6,8,9,w,H,M,N,Q,S,Z = 13	3,m,A,D,R = 14	2,5,G = 15	B,E,W = 16
	*/
	Letter(int tx, int ty)
	{
		int c=0;
		alphabet[c++]="B,E,W";
		alphabet[c++]="2,5,G,$";
		alphabet[c++]="3,m,A,D,R";
		alphabet[c++]="6,8,9,w,H,M,N,Q,S,Z,@";
		alphabet[c++]="0,g,p,y,F,O,P";
		alphabet[c++]="4,b,d,C,K,U,&,£";
		alphabet[c++]="e,h,k,s,z,=";
		alphabet[c++]="a,n,u,T,V,X,+";
		alphabet[c++]="7,c,o,v,x,L";
		alphabet[c++]="f,t,J,Y,%,?";
		alphabet[c++]="1,r";
		alphabet[c++]="j,l,/,(,),<,>";
		alphabet[c++]="i,;,°,!";
		alphabet[c++]="^";
		alphabet[c++]=":,-,'";
		alphabet[c++]=".";
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
	//println (this);
	}
	void update()
	{
	//println(xi+" "+yi+" "+dimX+" "+dimY);
	}
	void getPortion()
	{
	//portion=get(0,0,dimX,dimY);
	//println(xi+" "+yi+" "+dimX+" "+dimY);
	//portion=get(xi,yi,dimX,dimY);
	}
	void getColor()
	{
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
	}
	void change()
	{
		if(fontSize<20){
			fontSize+=3;
		}
		//println("cambiato");
	}
	void draw()
	{
		c=color(0,204,204,_alpha);
		fill(c);
		textFont(kfont, fontSize);
		text(lettera, xi, yi);
		if(fontSize>8){
			fontSize--;
		}
	}
}
