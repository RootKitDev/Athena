<script type="text/javascript">
	$(document).ready(function() {
	$('select').material_select();
	});
</script>
<?php

include('./include/utility/connect_database.php');

$Pseudo=$_SESSION['pseudo'];
$query = "SELECT login, role, active, nom, description
FROM User
INNER JOIN Role
ON role = Role.id
WHERE login='$Pseudo'";
$result = mysqli_query($link, $query);
$row = mysqli_fetch_array($result, MYSQLI_NUM);

if($row[2] == 1)

	$active="checked";

?>

	<div class="section center z-depth-3">
		<h5>Mon compte</h5>
	</div>

<div class="container">


	<form>
		<fieldset>
			<legend>Mon Profil</legend>
			<p>
				<label for="pseudo">Pseudo :</label><input readonly type="text" value="<?php echo $Pseudo ?>" /><br />
				<label for="Role">Role :</label><input readonly type="text" value="<?php echo $row[3] ?>"/><br />
				<label for="Droit">Droit :</label><input readonly type="text" value="<?php echo $row[4] ?>"/><br />
				<div class="switch">
					<label id="Active">Compte Actif : 
						<input <?php if ($_SESSION["Role"] != 1): ?>disabled <?php endif; echo $active ?> type="checkbox">
						<span class="lever"></span>
					</label>
				  </div>
			</p>
		</fieldset>
	</form>

</div>

<div class="container">

	<form>
		<fieldset>
			<legend>Mes Habilitations / Acces</legend>
			<p>
				<label for="pseudo">Habilitations Actuel  :</label><br />
				<textarea rows="4" cols="50" readonly>
					<?php echo $row[4] ?>
				</textarea><br />
				<br />
		</fieldset>
	</form>

	<form method='post' action="<?php echo "$page?Cat=8"; ?>">
		<fieldset>
			<div class="input-field col s12">
				<select>
			<?php
				$query = "SELECT nom FROM Role";
				$result = mysqli_query($link, $query);
				while($data = mysqli_fetch_array($result)){
					if ($data[0] !="Admin" && $data[0] !="Demo" ) {
						echo '<option value="'.$data[0].'">'.$data[0].'</option>';
					}
				}
			?>
				</select>
				<label>Demande de nouveau role :</label>
			</div>
			<br />
			<br />
			<label for="JutifAcces">Justification pour la demande d'habilitations :</label><br />
			<textarea  name="JutifAcces" id="JutifAcces" rows="4" cols="50" >
			</textarea><br />
			
			</p>
		</fieldset>
		<?php if ($_SESSION["Role"] != 4): ?><input type="submit" class="btn btn-success" value="Envoie une demande d'acces" name="submitaccess"/><?php endif; ?>
	</form>

</div>


<div class="container">

	<form method='post' action="<?php echo "$page?Cat=8"; ?>">
		<fieldset>
			<legend>Mot De Passe</legend>
			<p>
				<label for="OdlPwd">Mot de passe actuel :</label><input name="OdlPwd" type="password" id="OdlPwd" /><br />
				<label for="NewPwd">Nouveau Mot de passe :</label><input name="NewPwd" type="password" id="NewPwd" /><br />
				<label for="NewPwd2">Confirmer le nouveau Mot de passe :</label><input name="NewPwd2" type="password" id="NewPwd2" /><br />
			</p>
			<?php if ($_SESSION["Role"] != 4): ?><input type="submit" class="btn btn-success" value="Changer de mot de passe" name="submitPwd"/><?php endif; ?>
			<br />
			<br />
		</fieldset>
	</form>
</div>

<?php

### Change Password

	if (isset($_POST['submitPwd'])){
		$query = "SELECT password FROM User WHERE login='$Pseudo'";
		$result = mysqli_query($link, $query);
		$row = mysqli_fetch_array($result, MYSQLI_NUM);

		$OldPasswd=$_POST['OdlPwd'];
		if (password_verify($OldPasswd, $row[0])) // Acces OK !
		{
			if ($OldPasswd != $_POST['NewPwd2']) {
				if ($_POST['NewPwd'] == $_POST['NewPwd2']) {
					$hashpassword=password_hash($_POST['NewPwd'], PASSWORD_DEFAULT);
					$query = "UPDATE User SET password = '$hashpassword' WHERE login='$Pseudo'";
					$result = mysqli_query($link, $query);
					$row1 = mysqli_fetch_array($result, MYSQLI_NUM);
					$message = 'Le Mot de passe a été mise à jour';
				}
				else {
					$message = 'Une erreur s\'est produite. Le nouveau mot de passe ne correspond pas à sa confirmation';
				}
			}else {
				$message = 'Une erreur s\'est produite. Le nouveau mot de passe ne peux etre le même que l\'ancien';
			}
		}
		else // Acces pas OK !
		{
			$message = 'Une erreur s\'est produite. Le mot de passe actuel n\'est pas correcte';
		}
		if(!empty($message)){
			echo '<script type="text/javascript">window.alert("'.$message.'");</script>';
			header('Refresh: 0; url=./index.php?Cat=8');
		}
	}

### Ask Access

	if (isset($_POST['submitaccess'])){

		$Role_Message = "Ci-dessous la justification d'habiliation : ".$_POST['Role']."\n\n";
		$Justif_Message = $_POST['JutifAcces'];
		//$Post_Message
		require 'libs/PHPMailer/PHPMailerAutoload.php';

		$mail = new PHPMailer;

		//$mail->SMTPDebug = 3;                               // Enable verbose debug output

		$mail->isSMTP();                                      // Set mailer to use SMTP
		$mail->Host = 'smtp-mail.outlook.com';  // Specify main and backup SMTP servers
		$mail->SMTPAuth = true;                               // Enable SMTP authentication
		$mail->Username = 'trinixium@outlook.fr';                 // SMTP username
		$mail->Password = 'Mu1Xin|rt';                           // SMTP password
		$mail->SMTPSecure = 'tls';                            // Enable TLS encryption, `ssl` also accepted
		$mail->Port = 587;                                    // TCP port to connect to
		
		$mail->setFrom('trinixium@outlook.fr', 'Mailer');
		$mail->addAddress('trinixium@outlook.fr', 'Trixi User');     // Add a recipient

		$mail->Subject = 'Demande d\'habilitation : '.$Pseudo;
		$mail->Body    = $Role_Message.$Justif_Message;
/*
		if(!$mail->send()) {
			echo '<script type="text/javascript">window.alert("Une erreur c\'est produite, merci de ré-essayer ultérieurement");</script>';
			header('Refresh: 0; url='.$page.'?Cat=8');
		} else {
			echo '<script type="text/javascript">window.alert("Votre demande a été prise en compte");</script>';
			header('Refresh: 0; url='.$page.'?Cat=8');
		}
*/
	}

?>
