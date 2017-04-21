<div class="section center  z-depth-3">
	<h5>Restauration</h5>
</div>

<div class="container">
	<div class="row">
		<div class="card-panel">

			<p>Le Dossier Athena ne peux etre restauré.</p>
			<form <?php if ($_SESSION["db"] == "Athena") : ?>method="post" action="<?php echo "$page?Cat=7"; ?>"<?php endif; ?>>
				<p>Quelle sauvegarde voulez vous restaurer ?</p>
				<input placeholder="Sélectionner la date de la sauvegarde"type="date" class="datepicker" name ="TargetDate">
				<script>
					$('.datepicker').pickadate({
						selectMonths: true, // Creates a dropdown to control month
						selectYears: 15 // Creates a dropdown of 15 years to control year
					});
				</script>
				<button class="btn waves-effect waves-light green" type="submit" name="action">Go
					<i class="small material-icons right">send</i>
				</button>
			</form>
		</div>
</div>
</div>
<?php
	if ($_SESSION["Role"] != 4) {
		if($_SERVER['REQUEST_METHOD'] == 'POST'){
			if (!empty($_POST["TargetDate"])) {
				date_default_timezone_set('Europe/Paris');

				$Target = $_POST["TargetDate"];
				$Target = date("Y-m-d", strtotime($Target));

				$Now = date("Y-m-d");
				if ($Target > $Now) {
					$message = "Une erreur c'est produite : la sauvegarde choisie n'est pas encore passée";
				}else {
					
					include('./include/utility/connect_database.php');

					$date = explode("-", $Target);
					$query = "SELECT DisplayState as '' FROM State INNER JOIN Save ON State.id = Save.state WHERE month=".$date[1]." and day=".$date[2];
					$result = mysqli_query($link, $query);
					$row = mysqli_fetch_array($result, MYSQLI_NUM);
					$Etat = $row[0];

					if($Etat != "OK"){
						$message = "La sauvegarde cible n'est pas exploitable, car à l'état $Etat. Merci d'en choisir une autre";
					}else{

						$cmd = "sudo -u athena /var/www/html/Outils/IHM/scripts_sh/./ask_backup.sh $Target";
						exec ($cmd.' 2>&1', $out);
?>

<div>
	<div>Sauvegarde du <?php echo $date[2]."/".$date[1] ?></div>
	<div>
		<form method="post" action="./functions/restauration.php">
<?php
			$File="/var/www/html/Outils/IHM/file/resto/content_save.txt";
			$lines = file($File);
			$Open_File = fopen($File, 'r+');
			$line = fgets($Open_File);
			fclose($Open_File);
			$pattern = '/^[.]/';
			$i=0;

			if (!empty($lines)) {
				foreach ($lines as $line) {
					$Valid = array();
					$Path = explode("/", $line);
					$lvl = count($Path);
					if ( $lvl <= 4 ) {
						foreach ($Path as $dir) {
							preg_match($pattern, $dir, $matches);
							if ((!$matches[0] == ".") && ($dir != "athena") ) {
								array_push($Valid, true);
							}
							else {
								array_push($Valid, false);
							}
						}
						if (!in_array(false, $Valid)) {
							if(pathinfo("/".$line, PATHINFO_EXTENSION) == "") {
?>
								<input type="checkbox" id="<?php echo $line; ?>" name="<?php echo $line; ?>" /><label for="<?php echo $line; ?>"><?php echo "/".htmlspecialchars($line); ?></label>				<input type="text" size="30" value="<?php echo "/".htmlspecialchars($line); ?>"/><br />
<?php
							}
						}
					}
					$i++;
				}
			}
?>
			<input type="submit" value="Submit">
		</form>
	</div>
</div>
<?php
					}
				}
			}
			else{
				$message = "Merci de choisir une date";
			}
			if(!empty($message)) {
				echo '<script type="text/javascript">window.alert("'.$message.'");</script>';
			}
		}
	}
	else {
?>
		<input type="checkbox" name="1" value="/path/to/Folder1">			<input type="text" size="30" value="/path/to/remote/Folder1"/><br />
		<input type="checkbox" name="2" value="/path/to/Folder2">			<input type="text" size="30" value="/path/to/remote/Folder2"/><br />
		<input type="checkbox" name="3" value="/path/to/Folder3">			<input type="text" size="30" value="/path/to/remote/Folder3"/><br />
		<input type="checkbox" name="4" value="/path/to/Folder4">			<input type="text" size="30" value="/path/to/remote/Folder4"/><br />
		<input type="checkbox" name="5" value="/path/to/Folder5">			<input type="text" size="30" value="/path/to/remote/Folder5"/><br />
		<input type="checkbox" name="6" value="/path/to/Folder6">			<input type="text" size="30" value="/path/to/remote/Folder6"/><br />
<?php
	}

if ($_SESSION["db"] != "Athena") {
	echo '<script type="text/javascript">window.alert("Les Restaurations ne sont disponiblent que en prod");</script>';

}
?>
