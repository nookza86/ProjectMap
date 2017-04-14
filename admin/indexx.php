<?php
	
	session_start();
	if(!isset($_SESSION["member_no"])){

		header("location: login.html");
	}
	else{

		header("location:php-db-template.php")
	}



?>