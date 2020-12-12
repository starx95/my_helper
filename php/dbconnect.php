<?php
$servername = "localhost";
$username   = "starxdev";
$password   = "01Gaidl!9[EM0Y";
$dbname     = "starxdev_myHelper";
$conn = mysqli_connect($servername, $username, $password, $dbname);
if ($conn->connect_error) {
   die("Connection failed: " . $conn->connect_error);
}
	?>