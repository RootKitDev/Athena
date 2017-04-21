<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">

		<title>CheckSum</title>

		<link rel="shortcut icon" href="../img/ico/favicon.ico">

		<!-- CSS Framework -->
		<link href="../../framework/css/main.css" rel="stylesheet">

		<?php include('../utility/scripts.php'); ?>

	</head>

	<body>
		<?php

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
				exec("sed -n /\"".$MonthArray[$Month]." ".$Day."\"/,/\"Fin du script\"/p /home/athena/Core/Logs.d/Save.log > ".$File);
			}

			$lines = file($File);

			$Open_File = fopen($File, 'r+');
			$line = fgets($Open_File);
			fclose($Open_File);
		}
		?>

		<div class="panel panel-primary">
			<div class="panel-heading"><center>CheckSum de la Sauvegarde du <?php echo $Day." ".$MonthArrayFr[$Month];?></center></div>
			<div class="panel-body">
				<center>
				<?php
					if (empty($lines)) {
						echo "Il n'y a pas de information CheckSum pour cette sauvegarde";
					} else {
						foreach ($lines as $line) {
							if (strpos($line, 'Le CheckSum de') !== false) {
								$CheckSum = explode(" ", $line);
								$size=sizeof($CheckSum);
								$CheckSum=$CheckSum[$size-2]." ".$CheckSum[$size-1];
								echo "Le CheckSum pour cette sauvegarde est : ".$CheckSum.".";
							}
						}
					}
				?>
				</center>
			</div>
		</div>
	</body>
</html>