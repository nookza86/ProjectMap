<?php 
//include the database connectivity setting
$root = realpath($_SERVER["DOCUMENT_ROOT"]);
include ("$root/admin/session.php");
include ("$root/admin/inc/dbconn.php");?>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Attractions</title>
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
  SELECT * FROM attractions 
  WHERE att_name LIKE '%".$search."%'
  OR att_no LIKE '%".$search."%' 
 ";
}
else
{
 $query = "
  SELECT att_no, att_name, att_img FROM attractions ORDER BY att_no
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
                <th>Name</th>
                          
              </tr>
            </thead>
 ';
 while($row = mysqli_fetch_array($result))
 {  
            $id=$row["att_no"];
            $urlview="view-attractions.php?id=$id";
            $urlupdate="update-form.php?id=$id";
            $urldelete="delete.php?id=$id";
  $output .= '
   <tr>
    <td>'.$row["att_no"].'</td>
    <td>'.$row["att_name"].'</td> 
   
    
    <td><a href="'.$urlview.'" class="btn btn-info" title="View complete attractions info" 
            data-toggle="tooltip" >
              <span class="fui-search"></span> 
            
            <a href="'.$urlupdate.'" class="btn btn-warning" title="Update attractions record" 
            data-toggle="tooltip" > 

            <span class="fui-new"></span></a>
            <a href="'.$urldelete.'" class="btn btn-danger" title="Delete attractions record!" 
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