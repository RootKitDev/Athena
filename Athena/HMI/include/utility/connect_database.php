<?php
	session_start();
	
	$db = $_SESSION["db"];
	$link = mysqli_connect("localhost", "AthenaWeb", "AthenaWebPassword", $db);

	if (mysqli_connect_errno()) {
		printf("Échec de la connexion : %s ", mysqli_connect_error());
		exit();
	}
?>