<?php session_start(); ?>


<!-- INDEX ATHENA -->

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Athena</title>
		<link rel="shortcut icon" href="./file/ico/favicon.ico">

		<!-- CSS Framework -->
		<link href="http://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
		<link href="assets/css/flaticon.css" type="text/css" rel="stylesheet" media="screen,projection"/>
		<link rel="stylesheet" href="//cdn.materialdesignicons.com/1.8.36/css/materialdesignicons.min.css">
		<link href="./framework/css/main.css" rel="stylesheet">
		<link href="./framework/css/style.css" rel="stylesheet">

		<!-- SCRIPTS -->
		<?php include('./include/utility/scripts.php'); ?>
	</head>
	<body>
<?php
	if (!empty($_SESSION["Auth"])) {
		include('./include/body/header.php');
		echo "<main>";
		include('./include/body/body.php');
		echo "</main>";
		include('./include/body/footer.php');
	}
	else {

		// VIP URL ?

		$url = $_SERVER['HTTP_HOST'];
		$tmp = explode(':', $url);
		$port = $tmp[1];

		if (!empty($port)) {
			switch ($port) {
				case 4244:
					$db = "AthenaDEV";
				break;
				case 4243:
					$db = "AthenaPREPROD";
				break;
				default:
					$db = "Athena";
			}
		}
		else {
			$url = $_SERVER['HTTP_HOST'];
			$tmp = explode('/', $url);
			$domain = $tmp[0];
			$tmp = explode('.', $domain);
			$env = $tmp[0];
			$_SESSION["Env"] = $env;
			switch ($env) {
				case "dev":
					$db = "AthenaDEV";
				break;
				case "preprod":
					$db = "AthenaPREPROD";
				break;
				default:
					$db = "Athena";
			}
		}
		$_SESSION["db"] = $db;
		
		include('./include/utility/connect.php');
	}
?>
	<script type="text/javascript">
		document.title = document.title + " - <?=$env;?>"
	</script>
	</body>
</html>