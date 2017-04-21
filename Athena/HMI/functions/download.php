<?php

include ("./crypt.php");

$file = "/var/www/html/Outils/IHM/webacces/download/Athena.conf";

CryptConf($file);


if(!$file){ // file does not exist
	die('Le fichier demandé est introuvable');
} else {
	header("Cache-Control: public");
	header("Content-Description: File Transfer");
	header("Content-Disposition: attachment; filename=".basename($file));
	header("Content-Type: application/octet-stream");
	header("Content-Transfer-Encoding: binary");

	// read the file from disk
	echo readfile($file);
	exec ('rm '.$file.' 2>&1', $out);
}

?>
