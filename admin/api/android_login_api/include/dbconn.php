<?php
require_once 'include/Config.php';
/*
   $db=mysqli_connect("localhost","root","root","mapofmemdb");
//Check connection
if (mysqli_connect_errno()) {
	echo "Connect failed: %s\n", mysqli_connect_error($db);
	exit();
}
*/
$db=mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_DATABASE);
//Check connection
if (mysqli_connect_errno()) {
	echo "Connect failed: %s\n", mysqli_connect_error($db);
	exit();
}

?>