<?php
	$servername = "localhost";
	$username = "id1128718_dbadmin";
	$password = "123456789";
	$dbname = "id1128718_mapofmem";

	$connect = mysqli_connect($servername,$username,$password,$dbname);

	if (!$connect) {
    	die("Connection failed: " . mysqli_connect_error()).'<br>';
    }
	else{ echo "Connected successfully";
	}
	$sql = 'SELECT * FROM users';
	$result = mysqli_query($connect, $sql);
	if(!$result){
		echo mysqli_error().'<br>';
		die('Can not access database!');
	}
	else {
		echo '<table border = "1" cellpading = "0" cellspacing = "0" >';
		echo '<tr>';
		echo '<td>';
		echo '';
		echo '</td>';
			echo '<td>';
			echo 'Username';
			echo '</td>';
			echo '<td>';
			echo 'Email';
			echo '</td>';
			echo '<td>';
			echo 'password';
			echo '</td>';
		echo '</tr>';

		while($row = mysqli_fetch_assoc($result)){
			echo '<tr>';
				while(list($key,$value)=each($row)){
					if($value == ''){
						echo '<td>'.'&nbsp;'.'</td>';
					}//if
					else{
						echo '<td>'.$value.'</td>';
					}//else
				}
			echo '</tr>';
		}
		echo '</table>';
		mysqli_close($connect);
	}
?>