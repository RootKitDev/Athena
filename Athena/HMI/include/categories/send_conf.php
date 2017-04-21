<div class="section center z-depth-3">
	<h5>Import de Configuration</h5>
</div>


<div class="container">
	<div class="row">
		<div class="card">
			<div class="card-panel black-text">
				<form <?php if (($_SESSION["Role"] == 1) || ($_SESSION["Role"] == 2)) : ?>method="post" action="<?php echo "$page?Cat=8"; ?>" enctype="multipart/form-data"<?php endif; ?> >
					<div class="file-field input-field">
						<div class="btn indigo accent-3">
							<span>Parcourir ... </span>
							<input type="file" name="AthenaConf" id="AthenaConf" >
						</div>

						<div class="file-path-wrapper">
							<input placeholder=": Fichier de conf Athena (max. 1 Mo)" class="file-path validate black-text" type="text"><br />
							<label for="AthenaConf"></label><br />
						</div>
					</div>
					<button class="offset-s6 btn waves-effect waves-light green" type="submit" name="action">Envoyer
						<i class="small material-icons right">send</i>
					</button>
				</form>
			</div>
		</div>
	</div>
</div>
<?php

if ($_SESSION["Role"] != 4) {

	include ("/var/www/html/Outils/IHM/functions/uncrypt.php");

	$tmp_name=$_FILES['AthenaConf']['tmp_name'];
	$name=$_FILES['AthenaConf']['name'];
	$size=$_FILES['AthenaConf']['size'];
	$type=$_FILES['AthenaConf']['type'];
	$erreur=$_FILES['AthenaConf']['error'];
	$uploadpath="/var/www/html/Outils/IHM/webacces/upload/";

	if(!empty($_FILES['AthenaConf'])) {

		if($erreur > 0) {
			exit('Erreur n°'.$erreur);
		}

		if(is_uploaded_file($tmp_name)) {

			$extensions_valides = array('conf','cnf');
			$extension_upload = strtolower(substr(strrchr($name, '.'),1));
			if (in_array($extension_upload,$extensions_valides)){
				if(move_uploaded_file($tmp_name, $uploadpath.$name)) {

					UncryptConf($uploadpath.$name);
					exec ('chmod 777 '.$uploadpath.$name.' 2>&1', $out);
					$cmd = "sudo -u athena /var/www/html/Outils/IHM/scripts_sh/./update_conf.sh";
					exec ($cmd.' 2>&1', $out);
					echo '<script type="text/javascript">window.alert("Configuration mise à jour");</script>';
					header('Refresh: 0; url=./index.php?Cat=2');
				}
				else {
					exit('Erreur lors de l\'enregistrement');
				}
			}
			else {
				echo "Extension Incorrecte";
			}
		}
		else {
			exit('Fichier non uploadé');
		}
	}
}
else {
	echo '<script type="text/javascript">window.alert("En Demo cette fonction c\'est pas disponible");</script>';
}

if ( !(($_SESSION["Role"] == 1) || ($_SESSION["Role"] == 2)) ) {
	echo '<script type="text/javascript">window.alert("L\'import de configuration Athena ne peux être modifiée que par un techicien ou un admin");</script>';

}
?>
