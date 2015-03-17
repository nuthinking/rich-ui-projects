
<?
$link = mysql_connect("localhost","xxx","xxx");
$mydb = mysql_select_db("xxx",$link);
$strsql = "select * from cgws_guestbook order by id DESC";
$result = mysql_query($strsql,$link);
$i=1;
echo "&";
while($row=mysql_fetch_array($result)){
	echo "user$i=".$row["nome"]."&";
	echo "myDate$i=".$row["data"]."&";
	echo "comment$i=".$row["messaggio"]."&";
	$i++;
}
echo "nComment=".($i-1)."&";
echo "caricamento=true";
?>