<?php
require_once 'include/DB_Functions.php';
$db = new DB_Functions();
 
// json response array
$response = array("error" => FALSE);
 
//if (isset($_POST['email']) && isset($_POST['password'])) {
if (isset($_POST['LoginSend'])) { 

    $LoginData = json_decode($_POST['LoginSend'], true);

    //echo $LoginData;
   // echo $LoginData["email"].$LoginData["password"];

    // receiving the post params
    $email = $LoginData["email"];
    $password = $LoginData['password'];
 
    // get the user by email and password
    $user = $db->getUserByEmailAndPassword($email, $password);
 
    if ($user != false) {
        // use is found
        $response["error"] = FALSE;
        $response["member_no"] = $user["member_no"];
        $response["user"]["first_name"] = $user["first_name"];
        $response["user"]["last_name"] = $user["last_name"];
        $response["user"]["email"] = $user["email"];
        $response["user"]["gender"] = $user["gender"];
        $response["user"]["dob"] = $user["dob"];
        $response["user"]["Country"] = $user["country"];
        $response["user"]["UserFrom"] = $user["userfrom"];
        $response["user"]["active"] = $user["active"];
        $response["user"]["UserImage"] = $user["user_img"];
        $response["user"]["LastUpdate"] = $user["last_update"];
        echo json_encode($response);
    } else {
        // user is not found with the credentials
        $response["error"] = TRUE;
        $response["error_msg"] = "Login credentials are wrong. Please try again!";
        echo json_encode($response);
    }
} else {
    // required post params is missing
    $response["error"] = TRUE;
    $response["error_msg"] = "Required parameters email or password is missing!";
    echo json_encode($response);
}
?>