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


    public function SendEmailActivation($email, $uuid, $member_no)
    {
        $strTo = $email;
        $strSubject = "Activate Member Account";
        $strHeader = "Content-type: text/html; charset=windows-874\n"; // or UTF-8 //
        $strHeader .= "From: admin@map.com\nReply-To: admin@map.com";
        $strMessage = "";
        $strMessage .= "Welcome : <br>";
        $strMessage .= "=================================<br>";
        $strMessage .= "Activate account click here.<br>";
        $strMessage .= "mapofmem.esy.es/admin/activate/activate.php?sid=".$uuid."&uid=".$member_no."<br>";
        $strMessage .= "=================================<br>";

        $flgSend = mail($strTo,$strSubject,$strMessage,$strHeader);   
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