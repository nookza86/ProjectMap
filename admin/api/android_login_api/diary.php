<?php
//http://www.kodingmadesimple.com/2015/01/convert-mysql-to-json-using-php.html
$root = realpath($_SERVER["DOCUMENT_ROOT"]);
require_once 'include/dbconn.php';
//include ("$root/admin/api/android_login_api/include/dbconn.php");

$response = array("error" => FALSE);

if (isset($_POST['DiarySend'])) { 
  $DiaryData = json_decode($_POST['DiarySend'], true);

  $command = $DiaryData["command"];
  $member_no = $DiaryData["member_no"];
  $att_no = $DiaryData['att_no'];
  $diary_note = $DiaryData['diary_note'];
  $impression = $DiaryData['impression'];
  $beauty = $DiaryData['beauty'];
  $clean = $DiaryData['clean'];
  $diary_pic1 = $DiaryData['diary_pic1'];
  $diary_pic2 = $DiaryData['diary_pic2'];
  $diary_pic3 = $DiaryData['diary_pic3'];
  $diary_pic4 = $DiaryData['diary_pic4'];
  //echo $command;
  if ($command == "insert") {
    //echo "INSERTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT";
    $sql = "INSERT INTO `diary`(`member_no`, `att_no`, `diary_note`, `impression`, `beauty`, `clean`, `diary_pic1`, `diary_pic2`, `diary_pic3`, `diary_pic4`, `last_update`) VALUES ('$member_no','$att_no', '$diary_note','$impression','$beauty','$clean','$diary_pic1','$diary_pic2','$diary_pic3','$diary_pic4',NOW());";
  }
  
  else{
    //echo "UPPPDFATEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE";
     $sql = "UPDATE `diary` SET `diary_note`='$diary_note',`impression`='$impression',`beauty`='$beauty',`clean`='$clean',`diary_pic1`='$diary_pic1',`diary_pic2`='$diary_pic2',`diary_pic3`='$diary_pic3',`diary_pic4`='$diary_pic4',`last_update`=NOW() WHERE `member_no` = '$member_no' and `att_no` = '$att_no';";
  }
  

  
  //echo($sql);
    $result = mysqli_query($db, $sql) or die("Error " . mysqli_error($db));
    

    if($result==false){
        //echo ("Query cannot be executed!<br>");
        //echo ("SQL Error : ".mysqli_error($db));
        $response["error"] = TRUE;
        $response["error_msg"] = "Query cannot be executed!";
        echo json_encode($response);
          }

    else{
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