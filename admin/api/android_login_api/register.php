<?php
 
require_once 'include/DB_Functions.php';
$db = new DB_Functions();
 
// json response array
$response = array("error" => FALSE);
 
//if (isset($_POST['fname']) && isset($_POST['email']) && isset($_POST['password'])) {
if (isset($_POST['RegisterSend'])) { 
    $RegisterData = json_decode($_POST['RegisterSend'], true);

    // receiving the post params
    $fname = $RegisterData['fname'];
    $lname = $RegisterData['lname'];
    $email = $RegisterData['email'];
    $password = $RegisterData['password'];
    $gender = $RegisterData['gender'];
    $BirthMonth = $RegisterData['BirthMonth'];
    $BirthDay = $RegisterData['BirthDay'];
    $BirthYear = $RegisterData['BirthYear'];
    $Country = $RegisterData['Country'];
    $UserFrom = $RegisterData['UserFrom'];
    $UserImage = $RegisterData['UserImage'];

    // check if user is already existed with the same email
    if ($db->isUserExisted($email)) {
        // user already existed
        $response["error"] = TRUE;
        $response["error_msg"] = "User already existed with " . $email;
        echo json_encode($response);
    } else {
        // create a new user
        $user = $db->storeUser($fname, $lname, $email, $password, $gender, $BirthMonth, $BirthDay, $BirthYear, $Country, $UserFrom, $UserImage);
       // echo $user;
        if ($user) {
            // user stored successfully
            $response["error"] = FALSE;
            $response["member_no"] = $user["member_no"];
            $response["user"]["first_name"] = $user["first_name"];
            $response["user"]["last_name"] = $user["last_name"];
            $response["user"]["email"] = $user["email"];
            $response["user"]["gender"] = $user["gender"];
            $response["user"]["dob"] = $user["dob"];
            $response["user"]["Country"] = $user["country"];
            $response["user"]["UserFrom"] = $user["userfrom"];
            $response["user"]["UserImage"] = $user["user_img"];
            $response["user"]["LastUpdate"] = $user["last_update"];
            echo json_encode($response);
        } else {
            // user failed to store
            $response["error"] = TRUE;
            $response["error_msg"] = "Unknown error occurred in registration!";
            echo json_encode($response);
        }
    }
} else {
    $response["error"] = TRUE;
    $response["error_msg"] = "Required parameters (name, email or password) is missing!";
    echo json_encode($response);
}
?>