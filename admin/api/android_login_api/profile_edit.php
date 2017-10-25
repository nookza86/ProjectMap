<?php
 
require_once 'include/DB_Functions.php';
$db = new DB_Functions();
 
// json response array
$response = array("error" => FALSE);
 
//if (isset($_POST['fname']) && isset($_POST['email']) && isset($_POST['password'])) {
if (isset($_POST['EditProfileSend'])) { 
    $EditProfileSend = json_decode($_POST['EditProfileSend'], true);

    // receiving the post params
    $member_no = $EditProfileSend['member_no'];
    $fname = $EditProfileSend['fname'];
    $lname = $EditProfileSend['lname'];
    $email = $EditProfileSend['email'];
    $gender = $EditProfileSend['gender'];
    $BirthMonth = $EditProfileSend['BirthMonth'];
    $BirthDay = $EditProfileSend['BirthDay'];
    $BirthYear = $EditProfileSend['BirthYear'];
    $Country = $EditProfileSend['Country'];

    $UpInforResult = $db->UpdateInformationUser($member_no, $fname, $lname, $email, $gender, $BirthDay, $BirthMonth, $BirthYear, $Country);

    if ($UpInforResult == "FALSE" ) {
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