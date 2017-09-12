<?php
require_once 'include/DB_Functions.php';
$db = new DB_Functions();
 
if (trim($_GET['mid']) != null) { 


    $member_no = trim($_GET['mid']);
    $uniqid =trim($_GET['uid']);
   //echo $member_no. $uniqid;
  //  $hash = $db->hashSSHA($password);
   // $encrypted_password = $hash["encrypted"]; // encrypted password
  //  $salt = $hash["salt"]; // salt
    echo '<form action="reset_result.php" method="post">';
    echo 'Password: <input type="text" name="pass"><br>';
    echo 'RePassword: <input type="text" name="re_pass"><br>';
    echo '<input type="hidden" name="member_no" value= "'.$member_no.'">';
    echo '<input type="hidden" name="uniqid" value="'.$uniqid.'">';
    echo '<input type="submit">';

} else {
    // required post params is missing
    $response["error"] = TRUE;
    $response["error_msg"] = "Required parameters email or password is missing!";
    echo json_encode($response);
}
?>