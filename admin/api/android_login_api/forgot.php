<?php
//http://www.kodingmadesimple.com/2015/01/convert-mysql-to-json-using-php.html
$root = realpath($_SERVER["DOCUMENT_ROOT"]);
require_once 'include/dbconn.php';
//include ("$root/admin/api/android_login_api/include/dbconn.php");
// json response array
$response = array("error" => FALSE);

if (isset($_POST['ForgotSend'])) { 
  $ForgotData = json_decode($_POST['ForgotSend'], true);

  $email = $ForgotData["email"];

  $sql = "SELECT member_no, uniqid FROM members WHERE email = '$email';";
  //echo $sql;
    $result = mysqli_query($db, $sql) or die("Error " . mysqli_error($db));

    if (mysqli_num_rows($result) > 0) {
    // output data of each row
    while($row = mysqli_fetch_assoc($result)) {
        $member_no = $row["member_no"];
        $uniqid = $row["uniqid"];
        $strTo = $email;
        $strSubject = "Reset account password";
        $strHeader = "Content-type: text/html; charset=windows-874\n"; // or UTF-8 //
        $strHeader .= "From: admin@map.com\nReply-To: admin@map.com";
        $strMessage = "";
        $strMessage .= "=================================<br>";
        $strMessage .= "Reset password account click here.<br>";
        $strMessage .= "mapofmem.esy.es/admin/login/reset.php?mid=".$member_no."&uid=".$uniqid."<br>";
        $strMessage .= "=================================<br>";

        $flgSend = mail($strTo,$strSubject,$strMessage,$strHeader); 

        $response["error"] = FALSE;
        echo json_encode($response);
    }
} else {
    $response["error"] = TRUE;
    $response["error_msg"] = "Email are wrong. Please try again!";
    echo json_encode($response);
}
          
}else{ echo "need param";}
?> 