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
    
     <script src="http://code.jquery.com/jquery-latest.js"></script>     
 
  
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

 while($row =mysqli_fetch_assoc($qrq))
    {
        $location[] = $row;
    }
}

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
  		
  function getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2-lat1);  // deg2rad below
    var dLon = deg2rad(lon2-lon1); 
    var a = 
      Math.sin(dLat/2) * Math.sin(dLat/2) +
      Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * 
      Math.sin(dLon/2) * Math.sin(dLon/2)
      ; 
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
    var d = R * c; // Distance in km
    return d * 1000; // km to meter
  }

  function deg2rad(deg) {
      return deg * (Math.PI/180)
  }

  var locations = <?php echo json_encode($location); ?>;
	console.log(locations);

    var map = new google.maps.Map(document.getElementById('map'), {
      zoom: 11,
      center: new google.maps.LatLng(7.948735, 98.336685),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    var infowindow = new google.maps.InfoWindow();

    var citymap = {
        "Bang Pae Waterfall": {
          center: {lat: 8.039301, lng: 98.391280},
          border: {lat: 8.041956, lng: 98.393812},
          distance: 0.4060
        },
        
       "Big Buddha": {
          center: {lat: 7.827521, lng: 98.312399},
          border: {lat: 7.826901, lng: 98.311446},
          distance: 0.1256
        },
    
        "Chalong Temple": {
          center: {lat: 7.846880, lng: 98.336915},
          border: {lat: 7.846411, lng:  98.337869},
          distance: 0.1173
        },

        "Kamala Beach1": {
          center: {lat: 7.960474, lng: 98.280831},
          border: {lat: 7.960432, lng: 98.284650},
          distance: 0.4206
        },

        "Kamala Beach2": {
          center: {lat: 7.956310, lng: 98.280175},
          border: {lat: 7.956128, lng: 98.283953},
          distance: 0.4162
        },

        "Kamala Beach3": {
          center: {lat: 7.952086, lng: 98.278202},
          border: {lat: 7.951540, lng: 98.282193},
          distance: 0.4437
        },

        "Karon Beach1": {
          center: {lat: 7.850062, lng: 98.284692},
          border: {lat: 7.850651, lng: 98.294719},
          distance: 1.106
        },

        "Karon Beach2": {
          center: {lat: 7.842530, lng: 98.286709},
          border: {lat: 7.842780, lng: 98.295550},
          distance: 0.9743
        },

        "Karon Beach3": {
          center: {lat: 7.835666, lng: 98.286709},
          border: {lat: 7.835630, lng: 98.296019},
          distance: 1.026
        },

        "Kata Beach1": {
          center: {lat: 7.821980, lng: 98.294231},
          border: {lat: 7.822214, lng: 98.297149},
          distance: 0.3225
        },

        "Kata Beach2": {
          center: {lat: 7.819238, lng: 98.295658},
          border: {lat: 7.819472, lng: 98.298812},
          distance: 0.3484
        },

        "Kata Beach3": {
          center: {lat: 7.816315, lng: 98.297374},
          border: {lat: 7.816294, lng: 98.299853},
          distance: 0.2731
        },

        "Patong Beach1": {
          center: {lat: 7.904886, lng: 98.291686},
          border: {lat: 7.904652, lng: 98.297866},
          distance: 0.6812
        },

        "Patong Beach2": {
          center: {lat: 7.899403, lng: 98.288296},
          border: {lat: 7.899169, lng: 98.297201},
          distance: 0.9811
        },

        "Patong Beach3": {
          center: {lat: 7.892835, lng: 98.289927},
          border: {lat: 7.893048, lng: 98.294733},
          distance: 0.1256
        },

        "Patong Beach4": {
          center: {lat: 7.889689, lng: 98.288210},
          border: {lat: 7.886799, lng: 98.291450},
          distance: 0.4802
        },
        
      };

    for (var city in citymap) {  

      var cityCircle = new google.maps.Circle({
              strokeColor: '#FF0000',
              strokeOpacity: 0.8,
              strokeWeight: 0,
              fillColor: '#FF0000',
              fillOpacity: 0.1,
              map: map,
              center: citymap[city].center,
              radius: getDistanceFromLatLonInKm(citymap[city].center.lat, citymap[city].center.lng, citymap[city].border.lat, citymap[city].border.lng)
            });
    }z

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
