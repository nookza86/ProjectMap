<?php 
//include the database connectivity setting
$root = realpath($_SERVER["DOCUMENT_ROOT"]);
include ("$root/myhr/inc/dbconn.php");?>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>FSTM.kuis.edu.my - PHP - MySQL</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="<?php $root ?>/myhr/css/bootstrap.min.css">
  <!-- Loading Flat UI Pro -->
    <link href="<?php $root ?>/myhr/css/flat-ui-pro.css" rel="stylesheet">
    <link rel="shortcut icon" href="img/favicon.png">
  
</head>
<body>

<?php 
//include the navigation bar
include ("$root/myhr/inc/navbar.php");?>

<div class="container">
	<br>
	<br>
  

  <div class="row">
    
    <div class="col-md-9" name="maincontent" id="maincontent">
		
		<div id="exercise" name="exercise" class="panel panel-info">
		<div class="panel-heading"><h5>Template for PHP-MySQL Exercises</h5></div>
			<div class="panel-body">
			<!-- ***********Edit your content STARTS from here******** -->
			
				
				

				<?php
				
					$query="select * from members ";
					//echo $query;
					//Execute the query
					$qr=mysqli_query($db,$query);
					if($qr==false){
						echo ("Query cannot be executed!<br>");
						echo ("SQL Error : ".mysqli_error($db));
					}
					
					//Check the record effected, if no records,
					//display a message

				//display a message
				if(mysqli_num_rows($qr)==0)
				{
					echo ("No record <br>");
				}//end no record
				else
				{//there is/are record(s)
				?>

					<h5>Members</h5><br>
					<table width="90%" class="table table-hover">
						<thead>
							<tr >
								<th>Member no.</th>
								<th>Firstname</th>
								<th>Lastname</th>
								<th>Gender</th>
								<th>Country</th>
							</tr>
						</thead>
				<?php
					while ($rekod=mysqli_fetch_array($qr)){//redo to other records
				?>
					<tr>
						<td>
						<?php
						$id=$rekod['member_no'];
						echo $id;
						$urlview="view-members.php?id=$id";
						$urlupdate="update-form.php?id=$id";
						$urldelete="delete.php?id=$id";
						?>
						<a href="<?php echo $urlview?>" class="btn btn-info" title="View complete members info" 
						data-toggle="tooltip" > 

						<a href="<?php echo $urlupdate?>" class="btn btn-warning" title="Update staff record" 
						data-toggle="tooltip" > 

						<span class="fui-new"></span></a>
						<a href="#" class="btn btn-danger" title="Delete staff record!" 
						data-toggle="tooltip" onclick="alertdelete()"> 
						<script>

							//script to redirect delete page
							function alertdelete() {
								var r = confirm("You really want to delete the staff?");
								if (r == true) {
									window.location="<?php echo $urldelete?>";
								} else {
									
								}
							}
							</script>
						<span class="fui-trash"></span></a>
						
						</td>
						<td><?php echo $rekod['first_name']?></td>
						<td><?php echo $rekod['last_name']?></td>
						<td><?php echo $rekod['gender']?></td>
						<td><?php echo $rekod['country']?></td>
					</tr>
				<?php
					}//end of records
				?>
				</table>
				<?php
				}//end if there are records
			
			?>
			
			<!-- ***********Edit your content ENDS here******** -->	
			</div> <!--body panel main -->
		</div><!--toc -->
		
    </div><!-- end main content -->
	
    <div class="col-md-3">
		<?php 
		//include the sidebar menu
		include ("$root/myhr/inc/sidebar-menu.php");?>
    </div><!-- end main menu -->
  </div>
</div><!-- end container -->


<?php 
//include the footer
include ("$root/myhr/inc/footer.php");?>

</body>
</html>
