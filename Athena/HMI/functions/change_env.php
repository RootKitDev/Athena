<?php

if ($_SESSION["db"] == 'AthenaDEV') {
	exec('sudo change-env -e PREPROD -f 2>&1', $out);
	$message="Le passage en PREPROD c'est terminé";
	$Env="PREPROD";
} else if ($_SESSION["db"] == 'AthenaPREPROD') {
	echo '<script type="text/javascript">window.alert("Attention les retour arrière ne sont aps possible depuis IHM");</script>';
	exec('sudo change-env -e PROD -f 2>&1', $out);
	$message="Le passage en PROD c'est terminé";
	$Env="PROD";
}

if (!file_exists("/var/www/html/$Env/Appli/Maintenance/maintenance.enable")) {
	echo '<script type="text/javascript">window.alert("'.$message.'");</script>';
	header('Refresh: 0; url=./index.php?Cat=1');
}

?>
