xml_txt.text = stringXML;
chartXML = new XML();
chartXML.ignoreWhite = true;
chartXML.parseXML(stringXML);

// Set the title of the Chart
title_txt.htmlText = '<P ALIGN="CENTER"><FONT FACE="_sans" SIZE="12" COLOR="#333333" LETTERSPACING="0" KERNING="0"><i>'+chartXML.firstChild.childNodes[0].childNodes[0].nodeValue+'</i></FONT></P>';

// Set the information about the Chart
var rootNode = chartXML.childNodes[0].childNodes[1];
var len = rootNode.childNodes.length;
col1_txt.htmlText = "<b>"+rootNode.childNodes[0].childNodes[0].childNodes[0].childNodes[0].nodeValue+"</b>";
col2_txt.htmlText = "<b>"+rootNode.childNodes[0].childNodes[1].childNodes[0].childNodes[0].nodeValue+"</b>";

// Create an array containing ChartItems' data
var chart_arr = [];
var i = 1;
while (i<len) {
	chart_arr.push({label:rootNode.childNodes[i].childNodes[0].childNodes[0].nodeValue,data:Number(rootNode.childNodes[i].childNodes[1].childNodes[1].childNodes[0].nodeValue)});
	++i;
}

// Instantiate the Chart passing the data
var chart_mc = this.attachMovie("chart_mc","chart_mc",1,{chart_arr:chart_arr});
chart_mc._y = 42;

// Set the actions to the buttons
order_alpha_mc.pos = 1;
order_alpha_mc.label_mc.gotoAndStop(1);
order_alpha_mc.onRelease=function(){
	if(this.pos == 1){
		this.pos = 2;
		chart_mc.changeOrder("az");
	}else{
		this.pos = 1;
		chart_mc.changeOrder("za");
	}
	this.label_mc.gotoAndStop(this.pos);
}

order_num_mc.pos = 4;
order_num_mc.label_mc.gotoAndStop(4);
order_num_mc.onRelease=function(){
	if(this.pos == 3){
		this.pos = 4;
		chart_mc.changeOrder("90");
	}else{
		this.pos = 3;
		chart_mc.changeOrder("09");
	}
	this.label_mc.gotoAndStop(this.pos);
}
