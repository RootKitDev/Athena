<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">

		<title>Logs</title>

		<link rel="shortcut icon" href="./file/ico/favicon.ico">
		
		<!-- CSS Framework -->
		<link href="../../framework/css/main.css" rel="stylesheet">

		<?php include('../utility/scripts.php'); ?>
	</head>
 
	<body>
<?php

include('../body/header.php');

if (!empty($_GET['month'])) {

	$Month = $_GET['month'];
	$Day = $_GET['day'];

	$MonthArray=array(
		"01"=>"Jan",
		"02"=>"Feb",
		"03"=>"Mar",
		"04"=>"Apr",
		"05"=>"May",
		"06"=>"Jun",
		"07"=>"Jul",
		"08"=>"Aug",
		"09"=>"Sep",
		"10"=>"Oct",
		"11"=>"Nov",
		"12"=>"Dec");

	$MonthArrayFr=array(
		"01"=>"Janvier",
		"02"=>"Février",
		"03"=>"Mars",
		"04"=>"Avril",
		"05"=>"Mai",
		"06"=>"Juin",
		"07"=>"Juillet",
		"08"=>"Août",
		"09"=>"Septembre",
		"10"=>"Octobre",
		"11"=>"Novembre",
		"12"=>"Décembre");

	$res = substr($Day, 0, 1);

	if ($res == 0) {
		$Day = substr($Day, 1, 1);
	}
	$File = "/home/athena/Core/Logs.d/WebLog.log";

	exec("sed -n /\"".$Day." ".$MonthArray[$Month]."\"/,/\"Fin du script\"/p /home/athena/Core/Logs.d/Save.log > ".$File);

	$log=exec("cat ".$File);

	if (empty($log)) {
		exec("sed -n /\"".$MonthArray[$Month]." ".$Day."\"/,/\"Fin du script\"/p /home/athena/Core/Logs.d/Save.log > /home/athena/Core/Logs.d/WebLog.log");
	}
?>

	<div class="section center z-depth-3">
		<h5>Log de la Sauvegarde du <?php echo $Day." ".$MonthArrayFr[$Month];?></h5>
	</div>

<?php
}
else{
	$File = "/home/athena/Core/Logs.d/Demo.log";

?>
	<div class="section center z-depth-3">
		<h5>Log de demo d'une Sauvegarde</h5>
	</div>

<?php
}

$lines = file($File);
$Open_File = fopen($File, 'r+');
$line = fgets($Open_File);
fclose($Open_File);

?>

	
			<div class="container">
				<div class="row">
      				<div class="col s12 m6 l8">
        				<div class="card-panel">



<?php
if (empty($line)) {
	echo "Pas de Logs pour cette sauvegarde";
}
else {
	foreach ($lines as $line) 
	{
		if (strpos($line, 'Save_SQL.log') !== false) {
			echo exec("sed -n /\"".$Day." ".$MonthArray[$Month]."\"/,/\"Fin du script\"/p /home/athena/Core/Logs.d/Save_SQL.log > /home/athena/Core/Logs.d/WebLog.log");

			$FileSQL = "/home/athena/Core/Logs.d/WebLog.log";
			$linesSQL = file($FileSQL);
			$Open_File = fopen($FileSQL, 'r+');
			$lineSQL = fgets($Open_File);
			fclose($Open_File);

			foreach ($linesSQL as $lineSQL) 
			{
				echo htmlspecialchars($lineSQL)."<br />";
			}
		}
		else {
			echo htmlspecialchars($line)."<br />";
		}
	}
}

?>

      					</div>
      				</div>
    			</div>
			</div>
	
	</body>
</html>
