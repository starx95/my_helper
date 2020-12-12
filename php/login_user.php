<?php
session_start();
include_once("dbconnect.php");
if(isset($_POST['email'])){
$email = $_POST['email'];
$password = sha1($_POST['password']);

$sqllogin = "SELECT * FROM user WHERE email = '$email' AND password = '$password' AND otp = '0'";
$queryResult = mysqli_query($conn, $sqllogin);

if (mysqli_num_rows($queryResult) == 1) {
   while($row = $queryResult->fetch_assoc()){
                $db_data[] = $row;
            }
            // Send back the complete records as a json
            echo json_encode($db_data);
}else{
    echo mysqli_error($conn);
}
}
?>