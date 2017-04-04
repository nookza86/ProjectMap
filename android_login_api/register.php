<?php
 
require_once 'include/DB_Functions.php';
$db = new DB_Functions();
 
// json response array
$response = array("error" => FALSE);
 
if (isset($_POST['fname']) && isset($_POST['email']) && isset($_POST['password'])) {
 
    // receiving the post params
    $fname = $_POST['fname'];
    $lname = $_POST['lname'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    $gender = $_POST['gender'];
    $BirthMonth = $_POST['BirthMonth'];
    $BirthDay = $_POST['BirthDay'];
    $BirthYear = $_POST['BirthYear'];
    $Country = $_POST['Country'];
    $UserFrom = $_POST['UserFrom'];

    // check if user is already existed with the same email
    if ($db->isUserExisted($email)) {
        // user already existed
        $response["error"] = TRUE;
        $response["error_msg"] = "User already existed with " . $email;
        echo json_encode($response);
    } else {
        // create a new user
        $user = $db->storeUser($fname, $lname, $email, $password, $gender, $BirthMonth, $BirthDay, $BirthYear, $Country, $UserFrom);
        if ($user) {
            // user stored successfully
            $response["error"] = FALSE;
            $response["uid"] = $user["id"];
            $response["user"]["fname"] = $user["fname"];
            $response["user"]["lname"] = $user["lname"];
            $response["user"]["email"] = $user["email"];
            $response["user"]["gender"] = $user["gender"];
            $response["user"]["dob"] = $user["dob"];
            $response["user"]["Country"] = $user["country"];
            $response["user"]["UserFrom"] = $user["userfrom"];
            $response["user"]["created_at"] = $user["created_at"];
            $response["user"]["updated_at"] = $user["updated_at"];
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