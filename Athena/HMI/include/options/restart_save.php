<?php 
session_start();
?>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
	
		<title>Relance de la sauvegarde</title>
	
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

			if (!empty($_GET['month'])) {
				$_SESSION['Month'] = substr($_GET['month'], 0, 2);
				$_SESSION['Day'] = $_GET['day'];
				$_SESSION['Year'] = exec('date +"%Y"');
				$page = $_SERVER['REQUEST_URI'];

		?>
		Demande de confirmation
		<h4>Relance de la sauvegarde !</h4>
		<p>
			Vous avez demander la relance de la sauvegarde du <strong><?php echo $_SESSION['Day']."/".$_SESSION['Month']."/".$_SESSION['Year']; ?></strong>.
		</p>
		<p>Merci de valider la relance de la sauvegarde</p>
		<form method="post" action="<?php echo $page; ?>">
			<input type="submit" name="Go" value="Valider l'action"/> <a href="../index.php" class="btn btn-inverse">Annuler l'action</a></p>
		</form>
		<?php
			}
			if($_SERVER['REQUEST_METHOD'] == 'POST'){
				$Month=$_SESSION['Month'];
				$Day=$_SESSION['Day'];

				include('../utility/connect_database.php');

				$query = "SELECT DisplayState as '' FROM State INNER JOIN Save ON State.id = Save.state WHERE month=".$Month." and day=".$Day;
				$result = mysqli_query($link, $query);
				$row = mysqli_fetch_array($result, MYSQLI_NUM);
				$Etat = $row[0];

				if($Etat != "KO"){
					$message = "La sauvegarde cible n'est pas exploitable, car à l'état $Etat. Merci d'en choisir une autre";
				}
				else{
					if (!empty($_POST["Go"])) {
						exec('sudo -u athena nohup /var/www/html/Outils/IHM/scripts_sh/./restart_save.sh'.$Month.' '.$Day);
						header('Refresh: 0; url=../../index.php?Cat=1');
					}
				}
			}
			if(!empty($message)) {
				echo '<script type="text/javascript">window.alert("'.$message.'");</script>';
			}
			
		?>
	</body>
</html>
