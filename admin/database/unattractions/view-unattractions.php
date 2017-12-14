<?php 
//include the database connectivity setting
$root = realpath($_SERVER["DOCUMENT_ROOT"]);
include ("$root/admin/session.php");
include ("$root/admin/inc/dbconn.php");?>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>View Unlock Attractions</title>
  <meta charset="utf-8">
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
include ("$root/admin/inc/navbar.php");?>

<div class="container">
	<br>
	<br>
  

  <div class="row">
    
    <div class="col-md-9" name="maincontent" id="maincontent">
		
		<div id="exercise" name="exercise" class="panel panel-info">
		<div class="panel-heading"><h5>View Unlock attractions Info</h5></div>
			<div class="panel-body">
			<!-- ***********Edit your content STARTS from here******** -->
			
						
				<?php
				$id=$_GET['id'];
				//Create SQL query

				$query="select *
				from unattractions where un_id = '$id'";
				//echo $query;
				//Execute the query
				$qr=mysqli_query($db,$query);
				if($qr==false){
					echo ("Query cannot be executed!<br>");
					echo ("SQL Error : ".mysqli_error($db));
				}
				else{//no error in sql
					$rec=mysqli_fetch_array($qr);

					$queryr='SELECT att_name FROM attractions WHERE att_no = '.$rec['att_no'].'';

				$qrq=mysqli_query($db,$queryr);
				if($qrq==false){
					echo ("Query cannot be executed!<br>");
					echo ("SQL Error : ".mysqli_error($db));
				}
				else{
					$Att_Name=mysqli_fetch_array($qrq);

					$query_Name='SELECT first_name, last_name FROM members WHERE member_no = '.$rec['member_no'].'';

					$qrqq=mysqli_query($db,$query_Name);
						if($qrqq==false){
							echo ("Query cannot be executed!<br>");
							echo ("SQL Error : ".mysqli_error($db));
						}
						else{
							$Mem_Name=mysqli_fetch_array($qrqq);
						}

				}
				}
				
					$results = array();
					$location = array();
					//$queryr = "SELECT * FROM `unattractions` ORDER BY `att_no`";
					$queryr = "SELECT * FROM `unattractions` WHERE un_id = $id ORDER BY att_no;";
					$qrq=mysqli_query($db,$queryr);
					if($qrq==false){
						echo ("Query cannot be executed!<br>");
						echo ("SQL Error : ".mysqli_error($db));
					}
					else{

					 while($row =mysqli_fetch_assoc($qrq))
					    {
					        $location[] = $row;
					    }
					}

					$queryr2 = "SELECT * FROM `diary` ORDER BY att_no;";
					$qrq2=mysqli_query($db,$queryr2);
					if($qrq2==false){
					  echo ("Query cannot be executed!<br>");
					  echo ("SQL Error : ".mysqli_error($db));
					}
					else{

					 while($row =mysqli_fetch_assoc($qrq2))
					    {
					        $diary[] = $row;
					    }
					}

			?>

				<form role="form" name="" action="" method="GET">
				<div class="row">
				  <div class="col-xs-9"></div>
				  <div class="col-xs-6">
<div id="map" style="width: 400px; height: 400px;"></div>			
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

  var diarys = <?php echo json_encode($diary); ?>;
	console.log(diarys);

    var map = new google.maps.Map(document.getElementById('map'), {
      zoom: 15,
      center: new google.maps.LatLng(locations[0]["latitude"], locations[0]["longitude"]),
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
          center: {lat: 7.827648, lng: 98.312619},
          border: {lat: 7.826333, lng: 98.311464},
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
          center: {lat: 7.953159, lng: 98.278395},
          border: {lat: 7.951764, lng: 98.282461},
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
    }

    for (i = 0; i < locations.length; i++) {  
    	//console.log(i, locations[i]["un_id"]);
      marker = new google.maps.Marker({
        animation: google.maps.Animation.DROP,
        position: new google.maps.LatLng(locations[i]["latitude"], locations[i]["longitude"]),
        map: map
      });

      google.maps.event.addListener(marker, 'click', (function(marker, i) {
        return function() {
          /*
          if (marker.getAnimation() !== null) {
          marker.setAnimation(null);
        } else {
          marker.setAnimation(google.maps.Animation.BOUNCE);
        }
        */
          var ContentText = '<a href="http://mapofmem.esy.es/admin/database/members/view-members.php?id='+ locations[i]["member_no"]+'">Profile Info</a>';
          for (j = 0; j < diarys.length; j++) { 

              if (locations[i]["member_no"] == diarys[j]["member_no"] && locations[i]["att_no"] == diarys[j]["att_no"]) {
                  ContentText = '<a href="http://mapofmem.esy.es/admin/database/members/view-members.php?id='+ locations[i]["member_no"]+'">Profile Info</a><br>'+
                  '<a href="http://mapofmem.esy.es/admin/database/diary/view-diary.php?id='+ diarys[j]["diary_id"]+'">Diary Info</a>';
                  break;
               }
               else{
                  ContentText = '<a href="http://mapofmem.esy.es/admin/database/members/view-members.php?id='+ locations[i]["member_no"]+'">Profile Info</a>';
               }
          }//j
          infowindow.setContent(ContentText);
          infowindow.open(map, marker);
        }
      })(marker, i));
    }
  </script>
				  </div>
				  <div class="col-xs-6">

				  	Unlock No  <input class="form-control" name="staffname" type="text" value="<?php echo $rec['un_id']; ?>" ">

				  	  Member No  <input class="form-control" name="staffname" type="text" value="<?php echo $rec['member_no'].'. '.$Mem_Name['first_name'].' '.$Mem_Name['last_name']; ?>" ">
				  	  
					  Attraction Name  <input class="form-control" name="staffname" type="text" value="<?php echo $rec['att_no'].'. '.$Att_Name['att_name']; ?>" ">
					  
					  Latitude  <input class="form-control" name="staffname" type="text" value="<?php echo $rec['latitude']; ?>" ">

					  Longitude  <input class="form-control" name="staffname" type="text" value="<?php echo $rec['longitude']; ?>" ">
					  
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
