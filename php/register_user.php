<?php
include_once("dbconnect.php");
if(isset($_POST['name'])){
$name = $_POST['name'];
$add = $_POST['address'];
$email = $_POST['email'];
$password = sha1($_POST['password']);
$otp = rand(1000,9999);

$sqlregister = "INSERT INTO user(NAME,ADDRESS,EMAIL,PASSWORD,OTP) VALUES('$name','$add','$email','$password','$otp')";

if(mysqli_query($conn,$sqlregister)){
    echo 'succes';
	$to = $email;
	$subject = "MyHelper Admin";
	$txt = "Thank you for registering. Please click this link='https://starxdev.com/stiw2044/activate_acc.php?otp=$otp&email=$email' to activate your account";
	$headers = "From: MyHelper@admin.com.my";
	mail($to,$subject,$txt,$headers);
}else{
    echo mysqli_error($conn);
}}
?>
