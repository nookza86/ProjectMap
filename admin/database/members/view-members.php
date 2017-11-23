<?php 
//include the database connectivity setting
$root = realpath($_SERVER["DOCUMENT_ROOT"]);
include ("$root/admin/session.php");
include ("$root/admin/inc/dbconn.php");?>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Member</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="<?php $root ?>/admin/css/bootstrap.min.css">
  <!-- Loading Flat UI Pro -->
    <link href="<?php $root ?>/admin/css/flat-ui-pro.css" rel="stylesheet">
    <link rel="shortcut icon" href="<?php $root ?>/admin/img/favicon.png">
  
</head>
<body>

<?php 
//include the navigation bar
include ("$root/admin/inc/navbar.php");?>

<div class="container">
	<br>
	<br>
  

  <div class="row">
    
    <div class="col-md-9" name="maincontent" id="maincontent">
		
		<div id="exercise" name="exercise" class="panel panel-info">
		<div class="panel-heading"><h5>View Member Info</h5></div>
			<div class="panel-body">
			<!-- ***********Edit your content STARTS from here******** -->
			
						
				<?php
				$id=$_GET['id'];
				//Create SQL query

				$query="select *
				from members where member_no = '$id'";
				//echo $query;
				//Execute the query
				$qr=mysqli_query($db,$query);
				if($qr==false){
					echo ("Query cannot be executed!<br>");
					echo ("SQL Error : ".mysqli_error($db));
				}
				else{//no error in sql
					$rec=mysqli_fetch_array($qr);
				}
						
			?>

				<form role="form" name="" action="" method="GET">
				<div class="row">
				  <div class="col-xs-9"></div>
				  	<div class="col-xs-4"><img src="<?php $root ?>/admin/api/android_upload_api/upload/profile/<?php echo $rec['user_img']; ?>" alt="Cinque Terre" class="img-thumbnail">
				  	</div>
				  <div class="col-xs-6">
				  	  Member No  <input class="form-control" name="staffname" type="text" value="<?php echo $rec['member_no']; ?>" ">
				  	  
				  	  FirstName  <input class="form-control" name="staffname" type="text" value="<?php echo $rec['first_name']; ?>" ">
				
					  LastName  <input class="form-control" name="staffname" type="text" value="<?php echo $rec['last_name']; ?>" ">
					  
					  Email  <input class="form-control" name="staffname" type="text" value="<?php echo $rec['email']; ?>" ">
					
					  Gender  <input class="form-control" name="staffname" type="text" value="<?php echo $rec['gender']; ?>" ">
					  
					  Date of Birth  <input class="form-control" name="staffname" type="text" value="<?php echo $rec['dob']; ?>" ">
				
					  Country  <input class="form-control" name="staffname" type="text" value="<?php echo $rec['country']; ?>" ">
					  
					  User from  <input class="form-control" name="staffname" type="text" value="<?php echo $rec['userfrom']; ?>" ">
					
					  User Image  <input class="form-control" name="staffname" type="text" value="<?php echo $rec['user_img']; ?>" ">
					 
					  Last Update  <input class="form-control" name="staffname" type="text" value="<?php echo $rec['last_update']; ?>" ">
					 
					  </div>
				</div>
<!--
					<div class="form-group">
					  Member No : <?php echo $rec['member_no']; ?> <br>
					  FirstName : <?php echo $rec['first_name']; ?> <br>
					  LastName : <?php echo $rec['last_name']; ?> <br>
					  Email : <?php echo $rec['email']; ?> <br>
					  Gender : <?php echo $rec['gender']; ?> <br>
					  Date of Birth : <?php echo $rec['dob']; ?> <br>
					  Country : <?php echo $rec['country']; ?> <br>
					  User from : <?php echo $rec['userfrom']; ?> <br>
					  User Image : <?php echo $rec['user_img']; ?> <br>
					  Last Update : <?php echo $rec['last_update']; ?> <br>
					</div>
-->
				</form>
				<hr>
			
			<!-- ***********Edit your content ENDS here******** -->	
			</div> <!--body panel main -->
		</div><!--toc -->
		
    </div><!-- end main content -->
	
    <div class="col-md-3">
		<?php 
		//include the sidebar menu
		include ("$root/admin/inc/sidebar-menu.php");?>
    </div><!-- end main menu -->
  </div>
</div><!-- end container -->


<?php 
//include the footer
include ("$root/admin/inc/footer.php");?>

</body>
</html>
