<?php
//http://www.kodingmadesimple.com/2015/01/convert-mysql-to-json-using-php.html
$root = realpath($_SERVER["DOCUMENT_ROOT"]);
require_once 'include/dbconn.php';
//include ("$root/admin/api/android_login_api/include/dbconn.php");

$response = array("error" => FALSE);

if (isset($_POST['unattractionsSendData'])) { 
  $UnlockData = json_decode($_POST['unattractionsSendData'], true);

  $member_no = $UnlockData["member_no"];
  $att_no = $UnlockData['att_no'];
  $latitude = $UnlockData['latitude'];
  $longitude = $UnlockData['longitude'];


  $sql = "INSERT INTO `unattractions`(`member_no`, `att_no`, `latitude`, `longitude`, `last_update`) VALUES ('$member_no','$att_no', $latitude, $longitude, NOW());";
  //echo($sql);
    $result = mysqli_query($db, $sql) or die("Error " . mysqli_error($db));
    

    if($result==false){
        //echo ("Query cannot be executed!<br>");
        //echo ("SQL Error : ".mysqli_error($db));
        $response["error"] = TRUE;
        $response["error_msg"] = "Query cannot be executed!";
        echo json_encode($response);
          }
    else{//insert successfull
        //echo "finish";
        $response["error"] = FALSE;
        $response["error_msg"] = "Finish!";
        echo json_encode($response);
           // echo $sql;
          }
          /*
    $emparray = array();
    while($row =mysqli_fetch_assoc($result))
    {
        $emparray[] = $row;
    }
    echo json_encode($emparray);
    */
}else{ 
  $response["error"] = TRUE;
  $response["error_msg"] = "Need param!";
  echo json_encode($response);
  }
?> 