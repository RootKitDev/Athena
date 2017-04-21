<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
	
		<title>Relance de l'export</title>
	
		<link rel="shortcut icon" href="../img/ico/favicon.ico">
		
		<!-- Bootstrap core CSS -->
		<link href="../bootstrap-3.3.7/dist/css/bootstrap.min.css" rel="stylesheet">
	
		<!-- Custom styles for this template -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
		<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	</head>
 
	<body>
		<br />
		<br />
		<?php

			$WIP= true;
			if ((!empty($_GET['month'])) || $WIP) {
				$_SESSION['Month'] = substr($_GET['month'], 0, 2);
				$_SESSION['Day'] = $_GET['day'];
				$_SESSION['Year'] = exec('date +"%Y"');
				$page = $_SERVER['REQUEST_URI'];

		?>
		Demande de confirmation
		<h4>Relance d'export !</h4>
		<p>
			Vous avez demander la relance de l'export la sauvegarde du <strong><?php echo $_SESSION['Day']."/".$_SESSION['Month']."/".$_SESSION['Year']; ?></strong>.
		</p>
		<p>Merci de valider la relance de l'export</p>
		<form method="post" action="<?php echo $page; ?>">
			<input type="submit" name="Go" value="Valider l'action"/> <a href="../index.php" class="btn btn-inverse">Annuler l'action</a></p>
		</form>
		<?php
			}
			
			include('./include/utility/connect_database.php');
			$query = "SELECT DisplayState as '' FROM State INNER JOIN Save ON State.id = Save.state WHERE month=".$_SESSION['Month']." and day=".$_SESSION['Day'];
			$result = mysqli_query($link, $query);
			$row = mysqli_fetch_array($result, MYSQLI_NUM);
			$Etat = $row[0];

			if($_SERVER['REQUEST_METHOD'] == 'POST'){
				if($Etat != "OK-NE"){
					$message = "La sauvegarde cible n'est pas exportable, car à l'état $Etat.";
				}
				else{
					if (!empty($_POST["Go"])) {
						$Day = $_SESSION['Day'];
						$Month =$_SESSION['Month'];
						$File=exec('ls /home/athena/Core/Data_Export | grep '.$Day);
						//exec('sudo -u athena /var/www/html/Outils/IHM/scripts_sh/./manuel_export.sh'.$File);
						//header('Refresh: 0; url=../index.php?Cat=1');
					}
				}
			}
			if(!empty($message)) {
				echo '<script type="text/javascript">window.alert("'.$message.'");</script>';
			}
		?>
	</body>
</html>