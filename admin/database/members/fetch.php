<?php 
//include the database connectivity setting
$root = realpath($_SERVER["DOCUMENT_ROOT"]);
include ("$root/admin/session.php");
include ("$root/admin/inc/dbconn.php");?>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Member</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="<?php $root ?>/css/bootstrap.min.css">
  <!-- Loading Flat UI Pro -->
    <link href="<?php $root ?>/css/flat-ui-pro.css" rel="stylesheet">
    <link rel="shortcut icon" href="<?php $root ?>/img/favicon.png">
  
</head>
<body>

<?php


$output = '';
if(isset($_POST["query"]))
{
 $search = mysqli_real_escape_string($db, $_POST["query"]);
 $query = "
  SELECT * FROM members 
  WHERE first_name LIKE '%".$search."%'
  OR last_name LIKE '%".$search."%' 
  OR member_no LIKE '%".$search."%'
  OR gender LIKE '%".$search."%' 
 
  OR country LIKE '%".$search."%'
 
 ";
}
else
{
 $query = "
  SELECT * FROM members ORDER BY member_no
 ";
}
$result = mysqli_query($db, $query);
if(mysqli_num_rows($result) > 0)
{
 $output .= '
  <table width="90%" class="table table-hover">
            <thead>
              <tr >
                <th>No.</th>
                <th>Firstname</th>
                <th>Lastname</th>
                <th>Gender</th>
                <th>Country</th>
              </tr>
            </thead>
 ';
 while($row = mysqli_fetch_array($result))
 {  
            $id=$row["member_no"];
            $urlview="view-members.php?id=$id";
            $urlupdate="update-form.php?id=$id";
            $urldelete="delete.php?id=$id";
  $output .= '
   <tr>
    <td>'.$row["member_no"].'</td>
    <td>'.$row["first_name"].'</td>
    <td>'.$row["last_name"].'</td>
    <td>'.$row["gender"].'</td>
    <td>'.$row["country"].'</td>

            

    <td><a href="'.$urlview.'" class="btn btn-info" title="View complete members info" 
            data-toggle="tooltip" >
              <span class="fui-search"></span> 
            
            <a href="'.$urlupdate.'" class="btn btn-warning" title="Update staff record" 
            data-toggle="tooltip" > 

            <span class="fui-new"></span></a>
            <a href="'.$urldelete.'" class="btn btn-danger" title="Delete staff record!" 
            data-toggle="tooltip" onClick = "return confirmDelete();"> 

            <script language = "JavaScript">
              function confirmDelete(){
                return confirm("Are you sure you want to delete this?");
              }
            </script>
            <span class="fui-trash"></span></a></td>
   </tr>
  ';
 }
 echo $output;
}
else
{
 echo 'Data Not Found';
}

?>

</body>
</html>