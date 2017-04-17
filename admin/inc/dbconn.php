<?php
/*
   $db=mysqli_connect("localhost","root","root","mapofmemdb");
//Check connection
if (mysqli_connect_errno()) {
	echo "Connect failed: %s\n", mysqli_connect_error($db);
	exit();
}
*/
$db=mysqli_connect("mysql.hostinger.in.th","u890498555_admin","095863270","u890498555_map");
//Check connection
if (mysqli_connect_errno()) {
	echo "Connect failed: %s\n", mysqli_connect_error($db);
	exit();
}

?>