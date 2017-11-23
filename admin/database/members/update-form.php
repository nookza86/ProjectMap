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
		<div class="panel-heading"><h5>UPDATE existing member</h5></div>
			<div class="panel-body">
			<!-- ***********Edit your content STARTS from here******** -->
			<?php
				//fetch old record to display in form
				$id=$_GET['id'];
				//sql to fetch selected staff
				$sql="select * from members 
					where member_no ='$id'";
					//echo $sql;
				$rs=mysqli_query($db,$sql);
				//check sql command
				if($rs==false){//sql error
					echo ("Query cannot be executed!<br>");
					echo ("SQL Error : ".mysqli_error($db));
				}
				else{//no sql error
					$rekod=mysqli_fetch_array($rs);
				}
			?>
				
				<form role="form" name="" action="save-update.php" method="GET">
					<div class="form-group">

					  Member No <input class="form-control" name="member_no" 
					  type="text" maxlength="6" 
					  value="<?php echo $rekod['member_no']?>" readonly>
					  Firstname <input class="form-control" name="first_name" type="text" 
					  value ="<?php echo $rekod['first_name']?>" >
					  Lastname <input class="form-control" name="last_name" type="text" 
					  value ="<?php echo $rekod['last_name']?>" >
					  Email 
					  <input class="form-control" name="email" type="text" 
					  value ="<?php echo $rekod['email']?>" >
					  Gender 
					  <input class="form-control" name="gender" type="text" 
					  value ="<?php echo $rekod['gender']?>" >
					  Date of Birth 
					  <input class="form-control" name="dob" type="text" 
					  value ="<?php echo $rekod['dob']?>" >
					  Country 
					  <input class="form-control" name="country" type="text" 
					  value ="<?php echo $rekod['country']?>" >
					  User from 
					  <input class="form-control" name="userfrom" type="text" 
					  value ="<?php echo $rekod['userfrom']?>" >
					  Image 
					  <input class="form-control" name="user_img" type="text" 
					  value ="<?php echo $rekod['user_img']?>" >
					  Last Update 
					  <input class="form-control" name="last_update" type="text" 
					  value ="<?php echo $rekod['last_update']?>" readonly>
					  
					  <br><input class="btn btn-embosed btn-primary" type="submit" value="Save" >
					</div>
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
