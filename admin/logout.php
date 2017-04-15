<?php
$root = realpath($_SERVER["DOCUMENT_ROOT"]);

   session_start();
   
   if(session_destroy()) {
      header("Location: /admin/login.php");
   }
?>