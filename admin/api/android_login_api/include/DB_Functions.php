<?php
 
/**
 * @author Ravi Tamada
 * @link http://www.androidhive.info/2012/01/android-login-and-registration-with-php-mysql-and-sqlite/ Complete tutorial
 */
 
class DB_Functions {
 
    private $conn;
 
    // constructor
    function __construct() {
        require_once 'DB_Connect.php';
        // connecting to database
        $db = new Db_Connect();
        $this->conn = $db->connect();
    }
 
    // destructor
    function __destruct() {
         
    }

    public function SendEmailActivation($email, $uuid, $member_no )
    {
        $strTo = $email;
        $strSubject = "Activate Member Account";
        $strHeader = "Content-type: text/html; charset=windows-874\n"; // or UTF-8 //
        $strHeader .= "From: admin@map.com\nReply-To: admin@map.com";
        //$strHeader .= "From: admin@hiddenjourney\nReply-To: Hidden Journey";
        $strMessage = "";
        $strMessage .= "Welcome to hidden journey: <br>";
        $strMessage .= "=================================<br>";
        $strMessage .= "Thank you for sign up. Please confirm your email address by ";
        //$string .= "mapofmem.esy.es/admin/activate/activate.php?sid=".$uuid."&uid=".$member_no;
        //$strMessage .= rawurlencode($string);

        $query_string = 'sid=' . urlencode($uuid) . '&uid=' . urlencode($member_no);

        $strMessage .= '<a href="mapofmem.esy.es/admin/activate/activate.php?' . htmlentities($query_string) . '">';
        $strMessage .= "click here.";
        //$strMessage .= "<br>================================<br>";

        $flgSend = mail($strTo,$strSubject,$strMessage,$strHeader);   
    }
 
    /**
     * Storing new user
     * returns user details
     */
    public function UpdatePasswordUser($password,  $member_no) {
        $uuid = uniqid('', true);
        $hash = $this->hashSSHA($password);
        $encrypted_password = $hash["encrypted"];
        $salt = $hash["salt"];

        $stmt = $this->conn->prepare("UPDATE `members` SET `encrypted_password` = ?, `salt` = ? WHERE member_no = ?");

        $stmt->bind_param("sss", $encrypted_password, $salt, $member_no);
        $result = $stmt->execute();
        $stmt->close();
        if ($result) {
            return "FALSE"; 
        }else{
            return "TRUE"; 
        }
    }

     public function UpdateForgotPasswordUser($pass,  $member_no, $uniqid, $encrypted_password, $salt) {
        $stmt = $this->conn->prepare("UPDATE `members` SET `encrypted_password` = ?, `salt` = ? WHERE member_no = ? and uniqid = ?");
        $stmt->bind_param("ssss", $encrypted_password, $salt, $member_no, $uniqid);
        $result = $stmt->execute();
        $stmt->close();
        if ($result) {
            echo "Finish";
        }else{
            echo "try agin";
        }
    }

    /**
     * Storing new user
     * returns user details
     */
    public function UpdateInformationUser($member_no, $fname, $lname, $email, $gender, $BirthDay, $BirthMonth, $BirthYear, $Country) {
        $dob = "{$BirthYear}-{$BirthMonth}-{$BirthDay}";
        $inputdob = date("Y-m-d",strtotime($dob));

        $stmt = $this->conn->prepare("UPDATE `members` SET `first_name`= ?,`last_name`= ?,`email`= ?,`gender`= ?,`dob`= ?,`country`= ? WHERE member_no = ?");

        $stmt->bind_param("sssssss", $fname, $lname, $email, $gender, $dob, $Country, $member_no);
        $result = $stmt->execute();
        $stmt->close();
        if ($result) {
            return "FALSE"; 
        }else{
            return "TRUE"; 
        }
    }

    /**
     * Storing new user
     * returns user details
     */
    public function storeUser($fname, $lname, $email, $password, $gender, $BirthMonth, $BirthDay, $BirthYear, $Country, $UserFrom, $UserImage) {
        $uuid = uniqid('', true);
        $hash = $this->hashSSHA($password);
        $encrypted_password = $hash["encrypted"]; // encrypted password
        $salt = $hash["salt"]; // salt
        $dob = "{$BirthYear}-{$BirthMonth}-{$BirthDay}";
        $inputdob = date("Y-m-d",strtotime($dob));

        $stmt = $this->conn->prepare("INSERT INTO `members`(`first_name`, `last_name`, `email`, `encrypted_password`, `salt`, `gender`, `dob`, `country`, `userfrom`, uniqid, `user_img`, last_update) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())");
        $stmt->bind_param("sssssssssss", $fname, $lname, $email, $encrypted_password, $salt, $gender, $inputdob, $Country, $UserFrom, $uuid, $UserImage);
        $result = $stmt->execute();
        $stmt->close();
 
        // check for successful store
        if ($result) {
            $stmt = $this->conn->prepare("SELECT * FROM members WHERE email = ?");
            $stmt->bind_param("s", $email);
            $stmt->execute();
            
            //$user = $stmt->get_result()->fetch_assoc();

            $user = array();

           $stmt->bind_result($member_no, $first_name, $last_name, $email, $encrypted_password, $salt, $gender, $dob, $country, $userfrom, $uuid, $active, $user_img, $last_update);

            while ($stmt->fetch()) {
                //printf ("%s %s %s %s %s %s %s %s %s %s %s %s\n", $member_no, $first_name, $last_name, $email, $encrypted_password, $salt, $gender, $dob, $country, $userfrom, $user_img, $last_update);
                echo "";

             }
            $ImgPath = $member_no.".jpg";

            $stmt = $this->conn->prepare("UPDATE members SET user_img = ? WHERE member_no = ?");
            $stmt->bind_param("ss", $ImgPath, $member_no );
            $stmt->execute();

                $user["member_no"] = $member_no;
                $user["first_name"] = $first_name;
                $user["last_name"] = $last_name;
                $user["email"] = $email;
                $user["encrypted_password"] = $encrypted_password;
                $user["salt"]= $salt;
                $user["gender"] = $gender;
                $user["dob"] = $dob;
                $user["country"] = $country;
                $user["userfrom"] = $userfrom;
                $user["uuid"] = $uuid;
                $user["active"] = $active;
                $user["user_img"] = $user_img;
                $user["last_update"] = $last_update;

                 $this->SendEmailActivation($email, $uuid, $member_no);

            $stmt->close();
 
            return $user;
        } else {
            return false;
        }
    }
 
    /**
     * Get user by email and password
     */
    public function getUserByEmailAndPassword($email, $password) {
 
        $stmt = $this->conn->prepare("SELECT * FROM members WHERE email = ?");
 
        $stmt->bind_param("s", $email);
 
        if ($stmt->execute()) {
           // $user = $stmt->get_result()->fetch_assoc();

           $user = array();

           $stmt->bind_result($member_no, $first_name, $last_name, $email, $encrypted_password, $salt, $gender, $dob, $country, $userfrom, $uuid, $active, $user_img, $last_update);

            while ($stmt->fetch()) {
                //printf ("%s %s %s %s %s %s %s %s %s %s %s %s\n", $member_no, $first_name, $last_name, $email, $encrypted_password, $salt, $gender, $dob, $country, $userfrom, $user_img, $last_update);
                echo "";

             }

                $user["member_no"] = $member_no;
                $user["first_name"] = $first_name;
                $user["last_name"] = $last_name;
                $user["email"] = $email;
                $user["encrypted_password"] = $encrypted_password;
                $user["salt"]= $salt;
                $user["gender"] = $gender;
                $user["dob"] = $dob;
                $user["country"] = $country;
                $user["userfrom"] = $userfrom;
                $user["uuid"] = $uuid;
                $user["active"] = $active;
                $user["user_img"] = $user_img;
                $user["last_update"] = $last_update;

            $stmt->close();
 
            // verifying user password
            $salt = $user['salt'];
            $encrypted_password = $user['encrypted_password'];
            $hash = $this->checkhashSSHA($salt, $password);
            // check for password equality
            if ($encrypted_password == $hash) {
                // user authentication details are correct
                return $user;
            }
        } else {
            return NULL;
        }
    }
 
    /**
     * Check user is existed or not
     */
    public function isUserExisted($email) {
        $stmt = $this->conn->prepare("SELECT email from members WHERE email = ?");
 
        $stmt->bind_param("s", $email);
 
        $stmt->execute();
 
        $stmt->store_result();
 
        if ($stmt->num_rows > 0) {
            // user existed 
            $stmt->close();
            return true;
        } else {
            // user not existed
            $stmt->close();
            return false;
        }
    }
 
    /**
     * Encrypting password
     * @param password
     * returns salt and encrypted password
     */
    public function hashSSHA($password) {
 
        $salt = sha1(rand());
        $salt = substr($salt, 0, 10);
        $encrypted = base64_encode(sha1($password . $salt, true) . $salt);
        $hash = array("salt" => $salt, "encrypted" => $encrypted);
        return $hash;
    }
 
    /**
     * Decrypting password
     * @param salt, password
     * returns hash string
     */
    public function checkhashSSHA($salt, $password) {
 
        $hash = base64_encode(sha1($password . $salt, true) . $salt);
 
        return $hash;
    }
 
}
 
?>