<?php
$root = realpath($_SERVER["DOCUMENT_ROOT"]);	

include ("$root/admin/inc/dbconn.php");
		
		//echo trim($_GET['sid']).trim($_GET['uid']);
		$sql = "SELECT * FROM members WHERE uniqid = '".trim($_GET['sid'])."' AND member_no = '".trim($_GET['uid'])."' ";
		//echo $sql;
		$result = mysqli_query($db, $sql);
	
	//$objResult = mysql_fetch_array($result);

	if(!$result)
	{
			echo "Activate Invalid !";
	}
	else
	{	
			$sql = "UPDATE members SET Active = 'Yes'  WHERE uniqid = '".trim($_GET['sid'])."' AND member_no = '".trim($_GET['uid'])."' ";
			$result = mysqli_query($db, $sql);

		echo "Activate Successfully !";
	}

	mysqli_close($db);
?>