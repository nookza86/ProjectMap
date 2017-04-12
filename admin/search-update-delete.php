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
		<div class="panel-heading"><h5>Template for PHP-MySQL Exercises</h5></div>
			<div class="panel-body">
			<!-- ***********Edit your content STARTS from here******** -->
			
				Search staff to update/delete record<br>
				<form class="form-inline" role="form" name="" action="" method="GET">
					<div class="form-group">
					  <input class="form-control" name="staffname" type="text" placeholder="Staff name...">
					  <input class="btn btn-embosed btn-primary" type="submit" value="Search">
					</div>
				</form>
				<hr>
				
				
				<?php
				//check staff name input by the user if null
				if(!isset($_GET['staffname'])){
					echo "Search result here will be displayed here<br>";
					//exit();
				}
				else{//if there's user search - then perform db search
				//Create SQL query
					$staffname=$_GET['staffname'];
					$query="select EMPNO, FIRSTNAME, LASTNAME, WORKDEPT, PHONENO
					from employee where FIRSTNAME like '%$staffname%' or LASTNAME like '%staffname%'";
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
					echo ("Sorry, seems that no record found by the keyword $staffname...<br>");
				}//end no record
				else
				{//there is/are record(s)
				?>
					<h5>Search result "<?php echo $staffname; ?>"</h5><br>
					<table width="90%" class="table table-hover">
						<thead>
							<tr >
								<th>Employee no.</th>
								<th>Firstname</th>
								<th>Lastname</th>
								<th>Department</th>
								<th>Phone</th>
							</tr>
						</thead>
				<?php
					while ($rekod=mysqli_fetch_array($qr)){//redo to other records
				?>
					<tr>
						<td>
						<?php
						$id=$rekod['EMPNO'];
						echo $id;
						$urlupdate="update-form.php?id=$id";
						$urldelete="delete.php?id=$id";
						?>
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
						<td><?php echo $rekod['FIRSTNAME']?></td>
						<td><?php echo $rekod['LASTNAME']?></td>
						<td><?php echo $rekod['WORKDEPT']?></td>
						<td><?php echo $rekod['PHONENO']?></td>
					</tr>
				<?php
					}//end of records
				?>
				</table>
				<?php
				}//end if there are records
			}//end db search
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
