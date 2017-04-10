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
		echo 'ID';
		echo '</td>';
			echo '<td>';
			echo 'First name';
			echo '</td>';
			echo '<td>';
			echo 'Last name';
			echo '</td>';
			echo '<td>';
			echo 'Email';
			echo '</td>';
			echo '<td>';
			echo 'password';
			echo '</td>';
			echo '<td>';
			echo 'salt';
			echo '</td>';
			echo '<td>';
			echo 'Gender';
			echo '</td>';
			echo '<td>';
			echo 'Date of Birth';
			echo '</td>';
			echo '<td>';
			echo 'Country';
			echo '</td>';
			echo '<td>';
			echo 'User from';
			echo '</td>';
			echo '<td>';
			echo 'Create Date';
			echo '</td>';
			echo '<td>';
			echo 'Update';
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
		echo 'NOTE User from 0 Register in Application';
		echo 'NOTE User from 1 Register in FACEBOOK';
		mysqli_close($connect);
	}
?>