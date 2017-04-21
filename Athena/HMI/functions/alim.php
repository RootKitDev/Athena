<?php

	$host = 'localhost';
	$username = 'UserBackup';
	$password = 'UserBackupPassword';
	$dbScr = 'Athena';
	$dbDst = $_SESSION["db"];
	$rep = '/var/www/html/Outils/IHM/webacces/alimentation/'; //Répertoire où sauvegarder le dump de la base de données
	$table = 'Save';
	$now = date("d-m-Y");

	$cmdDumps = "sudo -u athena mysqldump -h ".$host." -u ".$username." -p'".$password."' ".$dbScr." ".$table."  > ".$rep.$dbScr."-".$now.".sql";
	exec ($cmdDumps.' 2>&1', $out);
	if (is_file($rep.$dbScr."-".$now.".sql")) {
		$cmdAlim = "sudo -u athena mysql -h ".$host." -u ".$username." -p'".$password."' ".$dbDst." < ".$rep.$dbScr."-".$now.".sql";
		exec ($cmdAlim.' 2>&1', $out);
		rename($rep.$dbScr."-".$now.".sql", $rep.$dbScr."-".$now.".sql.old");
		if (is_file($rep.$dbScr."-".$now.".sql.old")) {
			$cmdPostAlim = "rm ".$rep.$dbScr."-".$now.".sql.old";
			exec ($cmdPostAlim.' 2>&1', $out);
			echo '<script type="text/javascript">window.alert("Alimentation terminée");</script>';
		}
		
	}


?>
