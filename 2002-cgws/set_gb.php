<?
$link = mysql_connect("localhost","xxx","xxx");
$mydb = mysql_select_db("xxx",$link);
$day = date("d",time());
$month = date("m",time());
$year = date("Y",time());
$strsql = "insert into cgws_guestbook values (NULL, '$nome', '$day.$month.$year', '$messaggio')";
if($result = mysql_query ($strsql,$link)) {
	mail("christian@nuthinking.com", "New record in the GuestBook", "Go just to check!" , "From: CGWS GuestBook <blog@nuthinking.com>");
	echo "insert=1";
} else {
	echo "error=1";
}
?>