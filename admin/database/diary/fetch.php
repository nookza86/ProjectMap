<?php 
//include the database connectivity setting
$root = realpath($_SERVER["DOCUMENT_ROOT"]);
include ("$root/admin/session.php");
include ("$root/admin/inc/dbconn.php");?>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Diary</title>
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
  SELECT * FROM diary 
  WHERE member_no LIKE '%".$search."%'
  OR att_no LIKE '%".$search."%' 
  OR diary_note LIKE '%".$search."%'
  OR impression LIKE '%".$search."%'
  OR beauty LIKE '%".$search."%'
  OR clean LIKE '%".$search."%'
 ";
}
else
{
 $query = "
  SELECT * FROM diary ORDER BY diary_id
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
                <th>Member</th>
                <th>Attration</th>
                
                <th>Impression</th>
                <th>Beauty</th>
                <th>Clean</th>
              </tr>
            </thead>
 ';
 while($row = mysqli_fetch_array($result))
 {  
            $id=$row["diary_id"];
            $urlview="view-diary.php?id=$id";
            $urlupdate="update-form.php?id=$id";
            $urldelete="delete.php?id=$id";
  $output .= '
   <tr>
    <td>'.$row["diary_id"].'</td>
    <td>'.$row["member_no"].'</td>
    <td>'.$row["att_no"].'</td>
    
    <td>'.$row["impression"].'</td>
    <td>'.$row["beauty"].'</td>
    <td>'.$row["clean"].'</td>

            

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