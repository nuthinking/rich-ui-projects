/*
 * @author: Christian Giordano
 * @email: christian at nuthinking dot com
 * @version: 1.0
 * @last update: 6.12.2005
 */
class com.nuthinking.effects.BrushPath
{
	function BrushPath (){
		
	}
	static function generatePath (w:Number,h:Number,si:Number,sf:Number,steps:Number):Array{
		var res_arr:Array=[];
		var b:Object = {x:Math.random()*w,y:Math.random()*h,scale:si};
		var t:Object = {x:Math.random()*w,y:Math.random()*h,xf:Math.random()*w,yf:Math.random()*h,count:Math.random()*steps*.33};
		var speed = .10;
		var t_speed = .2;
		var scale_fact=(sf-si)/steps;
		for(var i=0; i<steps; i++)
		{
			t.x+=(t.xf-t.x)*t_speed;
			t.y+=(t.yf-t.y)*t_speed;
			t.count--;
			if(t.count<0){
				t.count=Math.random()*steps*.33;
				t.xf=Math.random()*w;
				t.yf=Math.random()*h;
			}
			b.x+=(t.x-b.x)*speed;
			b.y+=(t.y-b.y)*speed;
			b.scale+=scale_fact;
			//b.scale*=scale_fact;
			res_arr.push({x:b.x,y:b.y,scale:b.scale});
		}
		return res_arr;
	}
}