<?php
require_once 'include/DB_Functions.php';
$db = new DB_Functions();


    $pass = $_POST['pass'];
    $re_pass = $_POST['re_pass'];
    $member_no = $_POST['member_no'];
    $uniqid = $_POST['uniqid'];

//echo $pass.$re_pass.$member_no.$uniqid;
    $hash = $db->hashSSHA($pass);
    $encrypted_password = $hash["encrypted"]; // encrypted password
    $salt = $hash["salt"]; // salt
   // echo "en = ".$encrypted_password;
    //echo "salt = ".$salt;


   $db->UpdatePasswordUser($pass,  $member_no, $uniqid, $encrypted_password, $salt);
   
    


   
?>