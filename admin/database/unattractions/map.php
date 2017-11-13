<?php 
//include the database connectivity setting
$root = realpath($_SERVER["DOCUMENT_ROOT"]);
include ("$root/admin/inc/dbconn.php");
include ("$root/admin/session.php");
	?>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Members</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="<?php $root ?>/admin/css/bootstrap.min.css">
  <!-- Loading Flat UI Pro -->
    <link href="<?php $root ?>/admin/css/flat-ui-pro.css" rel="stylesheet">
    <link rel="shortcut icon" href="<?php $root ?>/admin/img/favicon.png">
    <script src="http://maps.google.com/maps/api/js?sensor=false" 
          type="text/javascript"></script>
    

 
  
</head>
<body>

<?php 
//include the navigation bar
include ("$root/admin/inc/navbar.php");
$results = array();
$location = array();
$queryr = "SELECT * FROM `unattractions` ORDER BY `att_no`";
$qrq=mysqli_query($db,$queryr);
if($qrq==false){
	echo ("Query cannot be executed!<br>");
	echo ("SQL Error : ".mysqli_error($db));
}
else{
	$i = 0;
	$j = 0;
	/*
	while($results=mysqli_fetch_array($qrq))
	{
	
		echo $results["member_no"]. " ";
		echo $results["att_no"]. " ";
		echo $results["latitude"]. " ";
		echo $results["longitude"]. " ";
	
		$location[i][0] = $results["member_no"];
		$location[i][1] = $results["att_no"];
		$location[i][2] = $results["latitude"];
		$location[i][3] = $results["longitude"];
		$i = $i + 1;
		
		$location[] = $row;
	}
	*/
 while($row =mysqli_fetch_assoc($qrq))
    {
        $location[] = $row;
    }
}

/*
while($line = mysql_fetch_array($query, MYSQL_ASSOC)){
    $results[] = $line;
}
*/
?>

<div class="container">
	<br>
	<br>
  

  <div class="row">
    
    <div class="col-md-9" name="maincontent" id="maincontent">
		
		<div id="exercise" name="exercise" class="panel panel-info">
		<div class="panel-heading"><h5>Member</h5></div>
			<div class="panel-body">
			<!-- ***********Edit your content STARTS from here******** -->
			
			<div class="form-group">
    <div class="input-group">
     <span class="input-group-addon">Search</span>
     <input type="text" name="search_text" id="search_text" placeholder="Search by Member Details" class="form-control" />
    </div>
   </div>
   <br />
   
	<div id="map" style="width: 500px; height: 400px;"></div>			
		<script type="text/javascript">
			/*
    var locations = [
      ['Bondi Beach', -33.890542, 151.274856, 4],
      ['Coogee Beach', -33.923036, 151.259052, 5],
      ['Cronulla Beach', -34.028249, 151.157507, 3],
      ['Manly Beach', -33.80010128657071, 151.28747820854187, 2],
      ['Maroubra Beach', -33.950198, 151.259302, 1]
    ];
	*/
	var locations = <?php echo json_encode($location); ?>;
	//console.log(locations);
    var map = new google.maps.Map(document.getElementById('map'), {
      zoom: 17,
     // center: new google.maps.LatLng(-33.92, 151.25),
     	center: new google.maps.LatLng(7.827548, 98.312406),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    var infowindow = new google.maps.InfoWindow();

    var marker, i;

    for (i = 0; i < locations.length; i++) {  
    	//console.log(i, locations[i]["un_id"]);
      marker = new google.maps.Marker({
        position: new google.maps.LatLng(locations[i]["latitude"], locations[i]["longitude"]),
        map: map
      });

      google.maps.event.addListener(marker, 'click', (function(marker, i) {
        return function() {
          infowindow.setContent(locations[i]["member_no"]);
          infowindow.open(map, marker);
        }
      })(marker, i));
    }
  </script>
				
				
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
