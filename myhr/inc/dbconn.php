<?php
$db=mysqli_connect("localhost","id1128718_dbadmin","123456789","id1128718_mapofmem");
//Check connection
if (mysqli_connect_errno()) {
	echo "Connect failed: %s\n", mysqli_connect_error($db);
	exit();
}
?>