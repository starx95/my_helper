<?php
include("dbconnect.php");
if(isset($_GET['otp'])){
	$email = $_GET['email'];
	$sql = "UPDATE user SET otp=0 WHERE email='".$email."'";
	if(mysqli_query($conn,$sql)){
		echo "your account has been activated successfully. You are now allowed to login";
	} else {
		echo "error";
}
}
?>