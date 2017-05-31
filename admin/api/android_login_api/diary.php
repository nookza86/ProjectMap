<?php
//http://www.kodingmadesimple.com/2015/01/convert-mysql-to-json-using-php.html
$root = realpath($_SERVER["DOCUMENT_ROOT"]);
require_once 'include/dbconn.php';
//include ("$root/admin/api/android_login_api/include/dbconn.php");

if (isset($_POST['DiarySend'])) { 
  $DiaryData = json_decode($_POST['DiarySend'], true);

  $member_no = $DiaryData["member_no"];
  $att_no = $DiaryData['att_no'];
  $diary_note = $DiaryData['diary_note'];
  $impression = $DiaryData['impression'];
  $beauty = $DiaryData['beauty'];
  $att_no = $DiaryData['clean'];
  $diary_pic1 = $DiaryData['diary_pic1'];
  $diary_pic2 = $DiaryData['diary_pic2'];
  $diary_pic3 = $DiaryData['diary_pic3'];
  $diary_pic4 = $DiaryData['diary_pic4'];

  $sql = "INSERT INTO `diary`(`member_no`, `att_no`, `diary_note`, `impression`, `beauty`, `clean`, `diary_pic1`, `diary_pic2`, `diary_pic3`, `diary_pic4`, `last_update`) VALUES ('$member_no','$att_no', '$diary_note','$impression','$beauty','$att_no','$diary_pic1','$diary_pic2','$diary_pic3','$diary_pic4',NOW());";
  //echo($sql);
    $result = mysqli_query($db, $sql) or die("Error " . mysqli_error($db));

    if($result==false){
            echo ("Query cannot be executed!<br>");
            echo ("SQL Error : ".mysqli_error($db));
          }
          else{//insert successfull
            echo "finish";
          }
          /*
    $emparray = array();
    while($row =mysqli_fetch_assoc($result))
    {
        $emparray[] = $row;
    }
    echo json_encode($emparray);
    */
}else{ echo "need param";}
?> 