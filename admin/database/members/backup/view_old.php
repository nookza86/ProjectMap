<?php 
//include the database connectivity setting
$root = realpath($_SERVER["DOCUMENT_ROOT"]);
include ("$root/admin/inc/dbconn.php");?>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>FSTM.kuis.edu.my - PHP - MySQL</title>
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
		<div class="panel-heading"><h5>Member</h5></div>
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

					
					<table width="90%" class="table table-hover">
						<thead>
							<tr >
								<th>No.</th>
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
						
						
						</td>
						<td><?php echo $rekod['first_name']?></td>
						<td><?php echo $rekod['last_name']?></td>
						<td><?php echo $rekod['gender']?></td>
						<td><?php echo $rekod['country']?></td>

						<td><a href="<?php echo $urlview?>" class="btn btn-info" title="View complete members info" 
						data-toggle="tooltip" >
							<span class="fui-search"></span> 
						
						<a href="<?php echo $urlupdate?>" class="btn btn-warning" title="Update staff record" 
						data-toggle="tooltip" > 

						<span class="fui-new"></span></a>
						<a href="<?php echo $urldelete?>" class="btn btn-danger" title="Delete staff record!" 
						data-toggle="tooltip" onClick = "return confirmDelete();"> 

						<script language = "JavaScript">
							function confirmDelete(){
								return confirm('Are you sure you want to delete this?');
							}
						</script>
						<span class="fui-trash"></span></a></td>
						
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
		include ("$root/admin/inc/sidebar-menu.php");?>
    </div><!-- end main menu -->
  </div>
</div><!-- end container -->


<?php 
//include the footer
include ("$root/admin/inc/footer.php");?>

</body>
</html>
