<?php 
//include the database connectivity setting
$root = realpath($_SERVER["DOCUMENT_ROOT"]);
include ("$root/admin/inc/dbconn.php");?>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Attractions</title>
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
		<div class="panel-heading"><h5>UPDATE existing attraction</h5></div>
			<div class="panel-body">
			<!-- ***********Edit your content STARTS from here******** -->
			<?php

			//perform UPDATE
			//Create SQL query
			$att_no=$_GET['att_no'];
			$att_name=$_GET['att_name'];
			$descriptions=$_GET['descriptions'];
			$att_img=$_GET['att_img'];
			
			//SQL to update record
			$query="UPDATE attractions SET 
			   att_name='$att_name', 
			   descriptions='$descriptions', 
			   att_img='$att_img', 
			   last_update=NOW()
			   where att_no = $att_no ";

			//echo $query;
			   
			//Execute the query
			$qr=mysqli_query($db,$query);
			if($qr==false){
				echo ("Query cannot be executed!<br>");
				echo ("SQL Error : ".mysqli_error($db));
			}
			else{//insert successfull
				echo"<div class='alert'><center>UPDATE has been saved.<br/>Back to Attractions Info in 2 sec.</center><br />";
				echo "<meta http-equiv='refresh' content='2;url=\"view-attractions.php?id=$att_no\"'><br /></div>";

			}

			?>
						
				
			
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
