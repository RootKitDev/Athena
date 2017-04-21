<?php

// Connect ATHENA

session_start();

if (!empty($_SESSION["db"])) {

	$db = $_SESSION["db"];
	$link = mysqli_connect("localhost", "AthenaWeb", "AthenaWebPassword", $db);

	if (!isset($_POST['pseudo'])) {
	?>
		<div id="login-page" class="row">
			<div class="col s12 z-depth-4 card-panel">
				<form class="login-form" method="post" action="./include/utility/connect.php">
					<div class="row">
						<div class="input-field col s12 center">
							<p class="center login-form-text">Connexion</p>
						</div>
					</div>

					<div class="row margin">
						<div class="input-field col s12">
							<i class="mdi-social-person-outline prefix"></i>
							<label for="pseudo" class="center-align">Utilisateur</label><input name="pseudo" type="text" id="pseudo" />
						</div>
					</div>

					<div class="row margin">
						<div class="input-field col s12">
							<i class="mdi-action-lock-outline prefix"></i>
							<label for="password" class="center-align">Mot de Passe</label><input id="password" type="password" name="password" />
						</div>
					</div>

					<div class="row">
						<div class="input-field col s12">
							<p><input class="btn waves-effect waves-light col s12 blue darken-1" type="submit" value="Connexion" /></p>
						</div>
					</div>
				</form>
			</div>
		</div>	

		<div class="row">
			<div class="input-field col s6 m6 l6">
				<p class="margin medium-small"><a href="page-register.html">Register Now!</a></p>
			</div>

			<div class="input-field col s6 m6 l6">
				<p class="margin right-align medium-small"><a href="page-forgot-password.html">Forgot password ?</a></p>
			</div>
		</div>
	<?php
	}
	else{
		if (!empty($_SESSION["pseudo"])) {
			$Pseudo = $_SESSION['pseudo'];
			$Passwd = $_SESSION['password'];
		}
		else {
			$Pseudo = $_POST['pseudo'];
			$Passwd = $_POST['password'];
		}

		if (empty($Pseudo) || empty($Passwd)) {
			$message='Merci de remplir tous les champs';
		}
		else {

			$query = "SELECT password, role, active FROM User WHERE login='$Pseudo'";
			$result = mysqli_query($link, $query);
			$row = mysqli_fetch_array($result, MYSQLI_NUM);

			if ($row[2] != 0){
				if (password_verify($Passwd, $row[0])) {
					$_SESSION['pseudo'] = $Pseudo;
					$_SESSION['password'] = $Passwd;
					$_SESSION['Auth'] = 1;
					$_SESSION['Role'] = $row[1];
					header('Refresh: 0; url=../../index.php');
				}
				else {
					$message = 'Une erreur s\'est produite. Le mot de passe ou le pseudo entré n\'est pas correcte';
				}
			}
			else {
				$message = 'Une erreur s\'est produite le compte saisie est inactif';
			}
		}
		if(!empty($message)) {
			echo '<script type="text/javascript">window.alert("'.$message.'");</script>';
			header('Refresh: 0; url=../../index.php');
		}
	}
}
else {
	header('Refresh: 0; url=../../index.php');
}
?>
