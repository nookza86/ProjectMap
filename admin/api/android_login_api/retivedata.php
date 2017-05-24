<?php
require_once 'include/DB_Functions.php';
$db = new DB_Functions();
 
// json response array
$response = array("error" => FALSE);

//if (isset($_POST['email']) && isset($_POST['password'])) {

    //$TableName = $_POST['TableName']
    $TableName = "attractions";
    $db->getData($TableName);
 

?> 