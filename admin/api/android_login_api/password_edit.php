<?php
 
require_once 'include/DB_Functions.php';
$db = new DB_Functions();
 
// json response array
$response = array("error" => FALSE);
 
if (isset($_POST['EditPassSend'])) { 
    $EditPassSend = json_decode($_POST['EditPassSend'], true);

    $member_no = $EditPassSend['member_no'];
    $password = $EditPassSend['password'];

    $UpPassResult = $db->UpdatePasswordUser($password,  $member_no);

    if ($UpPassResult == "FALSE") {
      $response["error"] = FALSE;
      $response["error_msg"] = "Update Complete!";
    }else{
      $response["error"] = TRUE;
      $response["error_msg"] = "Unknown error occurred in registration!";
    
    }
     echo json_encode($response);
    
} else {
    $response["error"] = TRUE;
    $response["error_msg"] = "Required parameters (name, email or password) is missing!";
    echo json_encode($response);
}
?>