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
		<div class="panel-heading"><h5>INSERT new staff</h5></div>
			<div class="panel-body">
			<!-- ***********Edit your content STARTS from here******** -->
				Insert new Staff Info<br>
				<form role="form" name="" action="" method="GET">
					<div class="form-group">
					  Staff ID <input class="form-control" name="empno" type="text" maxlength="6" 
					  placeholder ="Employee number (Example 000567)" >
					  Firstname <input class="form-control" name="firstname" type="text" 
					  placeholder ="Staff firstname here..." >
					  Lastname <input class="form-control" name="lastname" type="text" 
					  placeholder ="Staff lastname here..." >
					  Department 
					  <select class="form-control" name="workdept">
						<option value="B01">B01 PLANNING</option>
						<option value="C01">C01 INFORMATION CENTER</option>
						<option value="D01">D01 DEVELOPMENT CENTER</option>
						<option value="E11">E11 OPERATIONS</option>
						<option value="E21">E21 SOFTWARE SUPPORT</option>
					  </select>
					  
					  Phone <input class="form-control" name="phoneno" type="text" maxlength="4" 
					  placeholder="The staff phone extension..." >
					  
					  <input class="btn btn-embosed btn-primary" type="submit" value="Save new staff record" >
					</div>
				</form>
				<hr>
						
				<?php
				//check staff name input by the user if null
				if(!isset($_GET['empno'])){
					
				}
				else{//if there's user search - then perform db search
				//Create SQL query
					$empno=$_GET['empno'];
					$firstname=$_GET['firstname'];
					$lastname=$_GET['lastname'];
					$workdept=$_GET['workdept'];
					$phoneno=$_GET['phoneno'];
					$query="INSERT INTO employee(empno, firstname, lastname, workdept, phoneno) 
					values ('$empno','$firstname','$lastname','$workdept','$phoneno')";
					//Execute the query
					$qr=mysqli_query($db,$query);
					if($qr==false){
						echo ("Query cannot be executed!<br>");
						echo ("SQL Error : ".mysqli_error($db));
					}
					else{//insert successfull
						echo "The new staff has been saved...<br>";
						echo "<a href='php-db-template.php?staffname=$firstname'>View $firstname $lastname</a>";
					}
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
