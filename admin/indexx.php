<?php
	
	session_start();
	if(!isset($_SESSION["member_no"])){

		header("location: public-not-login.php");
	}
	else{

		header("location:php-db-template.php")
	}



?>