<?php

$array = array_keys($_POST);

$Tar=exec('ls -ltr /var/www/html/Outils/IHM/file/resto/tarball | tail -n1 | head -n1 | rev | cut -d' ' -f1 | rev ');

foreach ($array as $line) {
	$line=$file = str_replace("\r", "", $line);
	$cmd = "sudo /var/www/html/Outils/IHM/scripts_sh/./restauration.sh \"$Tar\" \"$line\"";
	exec ($cmd.' 2>&1', $out);
}
exec('rm /var/www/html/Outils/IHM/file/resto/tarball/'.$Tar, $out);
echo '<script type="text/javascript">window.alert("La restauration est terminée, merci de vérifier les données");</script>';
header('Refresh: 0; url=../index.php?Cat=1');

?>
