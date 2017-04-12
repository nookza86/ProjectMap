<?php
$db=mysqli_connect("localhost","root","root","mapofmemdb");
//Check connection
if (mysqli_connect_errno()) {
	echo "Connect failed: %s\n", mysqli_connect_error($db);
	exit();
}
?>