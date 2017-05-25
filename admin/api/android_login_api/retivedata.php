<?php
//http://www.kodingmadesimple.com/2015/01/convert-mysql-to-json-using-php.html
require_once 'include/dbconn.php';

if (isset($_POST['Number'])) { 
  $LoginData = json_decode($_POST['Number'], true);

  $no = $LoginData["no"];
  $mem_no = $LoginData['mem_no'];

  switch ($no) {
      case 1:
          $sql = "SELECT * FROM attractions";
          break;

      case 2:
          $sql = "SELECT * FROM diary WHERE member_no = $mem_no";
          break;

      case 3:
          $sql = "SELECT * FROM unattractions WHERE member_no = $mem_no";
          break;
      
      default:
          # code...
          break;
  }
    $result = mysqli_query($db, $sql) or die("Error in Selecting " . mysqli_error($db));

    $emparray = array();
    while($row =mysqli_fetch_assoc($result))
    {
        $emparray[] = $row;
    }
    echo json_encode($emparray);
}else{ echo "need param";}
?> 