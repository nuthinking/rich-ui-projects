<?php
    class commService {
        function commService() {
            $this->methodTable = array(
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
                )
            );
         	$this->conn = mysql_connect("localhost","xxx","xxx");
            mysql_select_db ("xxx");
        }
	function getComments($ref) {
		    return mysql_query("select * from tb_comm_natal where ref = '$ref'");
        }
	function addComment($ref,$comment,$name) {
		$comment = addslashes($comment);
		$strsql = "insert into tb_comm_natal (ref, nome, commento) values ('$ref', '$name', '$comment')";
		if($result = mysql_query ($strsql)) {
			mail("youremail@yourdomain.com", "New comment in the Natal Album", "Go just to check!" , "From: Natal Album <youremail@yourdomain.com>");
			return "true";
		} else {
			return "false";
		}
	}
    }
?>
