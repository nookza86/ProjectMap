<?php
	$host = "localhost";                //replace with your hostname
	$username = "id1128718_dbadmin";     //replace with your username
	$password = "123456789";             //replace with your password
	$db_name = "id1128718_mapofmem";     //replace with your database

	$connect = mysql_connect($host, $username, $password)or die("cannot connect");

	mysql_select_db($db_name) or die ("cannot select DB");

	$sql = "select * from members";    //replace with your table name
	$result = mysql_query($connect,$sql);
	$json = array();
	$count = 0;
	echo "BEFORE IF";
	if(mysql_num_rows($result)){
		while($row=mysql_fetch_row($result)) {
			$count = $count+1;
			$json["members".$count]=$row;
		}
	}

	mysql_close($db_name);
	echo json_encode($json);
?>