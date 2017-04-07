<?php 
//include the database connectivity setting
include ("inc/dbconn.php");?>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>FSTM.kuis.edu.my - PHP - MySQL</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="css/bootstrap.min.css">
  <!-- Loading Flat UI Pro -->
    <link href="css/flat-ui-pro.css" rel="stylesheet">
    <link rel="shortcut icon" href="img/favicon.png">
  
</head>
<body>

<?php 
//include the navigation bar
include ("inc/navbar.php");?>

<div class="container">
	<br>
	<br>
  

  <div class="row">
    
    <div class="col-md-9" name="maincontent" id="maincontent">
		
		<div id="exercise" name="exercise" class="panel panel-info">
		<div class="panel-heading"><h5>UPDATE existing staff</h5></div>
			<div class="panel-body">
			<!-- ***********Edit your content STARTS from here******** -->
			<?php

			//perform UPDATE
			//Create SQL query
			$empno=$_GET['empno'];
			$firstname=$_GET['firstname'];
			$lastname=$_GET['lastname'];
			$workdept=$_GET['workdept'];
			$phoneno=$_GET['phoneno'];
			
			//SQL to update record
			$query="UPDATE employee SET 
			   FIRSTNAME='$firstname', 
			   LASTNAME='$lastname', 
			   WORKDEPT='$workdept', 
			   PHONENO='$phoneno' 
			   where EMPNO='$empno'";
			   //echo $query;
			   
			//Execute the query
			$qr=mysqli_query($db,$query);
			if($qr==false){
				echo ("Query cannot be executed!<br>");
				echo ("SQL Error : ".mysqli_error($db));
			}
			else{//insert successfull
				echo "UPDATE has been saved...<br>";
				echo "<a href='php-db-template.php?staffname=$firstname'>View $firstname $lastname</a>";
			}

			?>
						
				
			
			<!-- ***********Edit your content ENDS here******** -->	
			</div> <!--body panel main -->
		</div><!--toc -->
		
    </div><!-- end main content -->
	
    <div class="col-md-3">
		<?php 
		//include the sidebar menu
		include ("inc/sidebar-menu.php");?>
    </div><!-- end main menu -->
  </div>
</div><!-- end container -->


<?php 
//include the footer
include ("inc/footer.php");?>

</body>
</html>
