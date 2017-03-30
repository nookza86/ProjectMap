<?php
$user = $_POST['username'];
$pass = $_POST['password'];
$email = $_POST['email'];

//echo  "Username: " . $user . "<br>";
//echo  "Password: " . $pass . "<br>";
//echo  "Email: " . $email . "<br>";

	$servername = "localhost";
	$username = "id1128718_dbadmin";
	$password = "123456789";
	$dbname = "id1128718_mapofmem";

	$connect = mysqli_connect($servername,$username,$password,$dbname);

	if (!$connect) {
    	die("Connection failed: " . mysqli_connect_error()).'<br>';
    }
	else{ 
		//echo "Connected successfully <br>";
		$sql = 'INSERT INTO members VALUES ("","'.$user.'","'.$email.'","'.$pass.'")';
	//echo $sql;
	$result = mysqli_query($connect, $sql);
		echo "successfully";
	}
	

	mysqli_close($connect);
?>