<?php

if (isset($_GET['UpSave'])){
	$cmd="sudo -u athena mv /home/athena/Core/Flags/PS-000 /home/athena/Core/Flags/Block/";

}
elseif (isset($_GET['DownSave'])){
	$cmd="sudo -u athena mv /home/athena/Core/Flags/Block/PS-000 /home/athena/Core/Flags/";
	$cmd2="sudo -u athena mv /home/athena/Core/Flags/* /home/athena/Core/Flags/Block/";
}

exec ($cmd2.' 2>&1', $out);
$message="Les Sauvegardes ont été ";
exec ($cmd.' 2>&1', $out);

$FlagDP=exec('ls /home/athena/Core/Flags | grep "PS-000"');

if (empty($FlagDP)){
	$message=$message."Réactivées. Tout les types de sauvegardes sont désormais actifs";
}
else{
	$message=$message."Désactivées";
}
file_put_contents($file, chr(13), FILE_APPEND | LOCK_EX);
echo '<script type="text/javascript">window.alert("'.$message.'");</script>';

header('Refresh: 0; url=../index.php?Cat=2');

?>