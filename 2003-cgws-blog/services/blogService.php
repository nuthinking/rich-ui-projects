<?php
    class blogService {
        function blogService() {
            $this->methodTable = array(
                "getMonthStat" => array(
                    "description" => "Returns the status of the days in the month",
                    "access" => "remote",
                    "roles" => "role, list",
                    "arguments" => array ("month")
                ),
				"getNews" => array(
                    "description" => "Returns the news of the day",
                    "access" => "remote",
                    "roles" => "role, list",
                    "arguments" => array ("day")
                ),
				"getComments" => array(
                    "description" => "Returns the comments of the day",
                    "access" => "remote",
                    "roles" => "role, list",
                    "arguments" => array ("day")
                ),
				"addComment" => array(
                    "description" => "Returns the comments of the day",
                    "access" => "remote",
                    "roles" => "role, list",
                    "arguments" => array ("day")
                ),
				"updateStats" => array(
                    "description" => "Returns the comments of the day",
                    "access" => "remote",
                    "roles" => "role, list",
                    "arguments" => array ("day")
                )
            );
         	$this->conn = mysql_connect("localhost","xxx","xxx");
            mysql_select_db ("xxx");
        }
        function getMonthStat($month) {
			$d_1=$month."01000000";
			$d_2=$month."31235959";
			return mysql_query("select id,data,important from blog_news where data >= $d_1 AND data <= $d_2 order by id DESC");
        }
		function getNews($d_2) {
			$d_2=$d_2."235959";
            return mysql_query("select * from blog_news where data <= $d_2 order by id DESC limit 0,10");
        }
		function getComments($id_1,$id_2) {
            return mysql_query("select * from blog_comm where ref >= $id_1 AND ref <= $id_2 order by id DESC");
        }
		function addComment($ref,$comment,$name,$email,$site) {
    		$date = date('m.d.Y , h:i a');
			$comment = addslashes($comment);
    		$strsql = "insert into blog_comm (ref, testo, nome, email, site, time) values ('$ref', '$comment', '$name', '$email', '$site', '$date')";
    		if($result = mysql_query ($strsql)) {
			mail("christian@nuthinking.com", "New comment in the Blog", "Go just to check!" , "From: CGWS Blog <blog@nuthinking.com>");
   		    	return "true";
    		} else {
    			return "false";
			}
		}
		function updateStats($linkStat) {
			$path=dirname(dirname(__FILE__))."/xxx.txt";
			if(!is_writeable($path)){
				return "Percorso non corretto";
			}else{
				$apri_file=fopen($path,"a");
				$a_capo=chr(13).chr(10);
				fputs($apri_file, $linkStat."\n");
				fclose($apri_file);
				return "percorso corretto";
			}
        }
    }
?>
