<?php
// upload.php
// Simple File uploader using HTTP PUT
//
// This app makes several assumptions:
// 1. You have a folder named "upload" that is a child folder where this script resides.
// 2. The web server has the ability to create files in that folder.  You have to make sure permissions
//    are correct.
// 3. Your web server allows this to work.
// 4. This script will live in a folder that does not have write permission.
// 5. You understand the perils of allowing scripts to run on your web server that allow people to
//    write arbitrary files that you don't have control over.
//
// Please read and understand all of the information here: 
// http://www.php.net/manual/en/features.file-upload.php
// before going into production with this.  Expect to spend time getting this right.
//
// Code to handle sending back HTTP response codes.  See: 
// http://stackoverflow.com/questions/3258634/php-how-to-send-http-response-code
// for more information.
//
// For 4.3.0 <= PHP <= 5.4.0

if (!function_exists('http_response_code'))
{
    function http_response_code($newcode = NULL)
    {
        static $code = 200;
        if($newcode !== NULL)
        {
            header('X-PHP-Response-Code: '.$newcode, true, $newcode);
            if(!headers_sent())
                $code = $newcode;
        }       
        return $code;
    }
}
//
// This is an arbitary limit.  Your PHP server has it's own limits, which may be more or 
// less than this limit.  Consider this an exercise in learning more about how your PHP
// server is configured.   If it allows less, then your script will fail.
//
// See: http://stackoverflow.com/questions/2184513/php-change-the-maximum-upload-file-size
// for more information on file size limits.
//
$MAX_FILESIZE = 5 * 1024 * 1024;  // 5 megabyte limit -- arbitrary value based on your needs

if ((isset($_SERVER["HTTP_FILENAME"])) && (isset($_SERVER["CONTENT_TYPE"])) && (isset($_SERVER["CONTENT_LENGTH"]))) {
    $filesize = $_SERVER["CONTENT_LENGTH"];
    // get the base name of the file.  This should remove any path information, but like anything
    // that writes to your file server, you may need to take extra steps to harden this to make sure
    // there are no path remnants in the file name.
    //
    $filename = basename($_SERVER["HTTP_FILENAME"]);
    $filetype = $_SERVER["CONTENT_TYPE"];
    $att_no = substr($filename,0,1);
    //
    // enforce the arbirary file size limits here
    // 
    if ($filesize > $MAX_FILESIZE) {
        http_response_code(413);
        echo("File too large");
        exit;
    }
    //
    // Make sure the filename is unique.
    // This will cause files after 100 of the same name to overwrite each other.
    // And it won't notify you.  Don't depend on this logic for production.
    // You should code this to fit your needs.
    //
/*
    if (file_exists("upload/" . $filename)) {
        //echo("duplicate filename");
        $i = 1;
        $path_parts = pathinfo($filename);
        
        $filename = $path_parts['filename'] . "_" . $i . "." . $path_parts['extension'];
        while(file_exists("upload/" . $filename))  {
            $i++;
            if ($i > 100) {
                break;
            }
            $filename = $path_parts['filename'] . "_" . $i . "." . $path_parts['extension'];
        }
    }*/

    /* PUT data comes in on the stdin stream */
    $putdata = fopen("php://input", "r");

    if ($putdata) {
        /* Open a file forw riting */
        $tmpfname = tempnam("upload", "myapp");
        $fp = fopen($tmpfname, "w");
        if ($fp) {
            /* Read the data 1 KB at a time and write to the file */
            while ($data = fread($putdata, 1024)) {
                fwrite($fp, $data);
            }
            /* Close the streams */
            fclose($fp);
            fclose($putdata);
            $result = rename($tmpfname, "upload/diary/$att_no/" . $filename);  
            chmod("upload/diary/$att_no/" . $filename, 0777);
            if ($result) {
                http_response_code(201);
                echo("File Created " . $filename);
            } else {
                http_response_code(403);
                echo("Renaming file to upload/diary/$att_no/" . $filename . " failed.");
            }          
        } else {
            http_response_code(403);
            echo("Could not open tmp file " . $tmpfname);
        }
    } else {
        http_response_code(403);
        echo("Could not read upload stream.");
    }
} else {
    http_response_code(500);
    echo("Malformed Request");
}
?>
