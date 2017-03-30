<?php
	$servername = "localhost";
	$username = "id1128718_dbadmin";
	$password = "123456789";
	$dbname = "id1128718_mapofmem";

	$connect = mysqli_connect($servername,$username,$password,$dbname);
	$json = array();
	$count = 0;

	// Check connection
	if (mysqli_connect_errno())
	  {
	  echo "Failed to connect to MySQL: " . mysqli_connect_error();
	  }

		$sql = "SELECT * FROM members";

		if ($result=mysqli_query($connect,$sql))
		  {
		  // Fetch one and one row
		  while ($row=mysqli_fetch_row($result))
		    {
		   // echo 'id :'.$row[0]. '<br>';
		   // echo 'Username :'.$row[1]. '<br>';
		   // echo 'Email :'.$row[2]. '<br>';
		   // echo 'Pass :'.$row[3]. '<br><br>';
		    $count = $count+1;
			$json["member".$count]=$row;
		    }
		  // Free result set
		  mysqli_free_result($result);
		}

	mysqli_close($connect);
	echo json_encode($json);
	
?>