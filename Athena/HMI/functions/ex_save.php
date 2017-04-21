<?php

$cmd="sudo -u athena mv /home/athena/Core/Flags/Block/EX-000 /home/athena/Core/Flags/";
$date=exec('date +"%d/%m/%Y"');
exec ($cmd.' 2>&1', $out);

if (empty($out)) {
	$message="Une sauvegarde exceptionnel a été programmé pour ce soir (".$date.")";
	$log="Sauvegarde exceptionnel programmé le ".exec("date +\"%F\"");
	file_put_contents($file, $log.chr(13), FILE_APPEND | LOCK_EX);
}
else{

	$message="Une sauvegarde exceptionnel est déjà programmé pour ce soir (".$date."), merci d'attentre son execution.";

}
	echo '<script type="text/javascript">window.alert("'.$message.'");</script>';
	header('Refresh: 0; url=../index.php?Cat=2');
?>