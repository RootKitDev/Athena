<?php

if (isset($_GET['SaveM'])){
	$cmdM="sudo -u athena mv /home/athena/Core/Flags/PS-001 /home/athena/Core/Flags/Block/";
}
else{
	$cmdM="sudo -u athena mv /home/athena/Core/Flags/Block/PS-001 /home/athena/Core/Flags/";
}

if (isset($_GET['SaveHi'])){
	$cmdHi="sudo -u athena mv /home/athena/Core/Flags/PS-003 /home/athena/Core/Flags/Block/";
}
else{
	$cmdHi="sudo -u athena mv /home/athena/Core/Flags/Block/PS-003 /home/athena/Core/Flags/";
}

if (isset($_GET['SaveHf'])){
	$cmdHf="sudo -u athena mv /home/athena/Core/Flags/PS-002 /home/athena/Core/Flags/Block/";
}
else{
	$cmdHf="sudo -u athena mv /home/athena/Core/Flags/Block/PS-002 /home/athena/Core/Flags/";
}

if (isset($_GET['SaveJ'])){
	$cmdJ="sudo -u athena mv /home/athena/Core/Flags/PS-004 /home/athena/Core/Flags/Block/";
}
else{
	$cmdJ="sudo -u athena mv /home/athena/Core/Flags/Block/PS-004 /home/athena/Core/Flags/";
}

exec ($cmdM.' 2>&1', $outM);
exec ($cmdHi.' 2>&1', $outHi);
exec ($cmdHf.' 2>&1', $outHf);
exec ($cmdJ.' 2>&1', $outJ);

if (empty($outM) || empty($outHi) || empty($outHf) || empty($outJ)) {

	
	$message="Les Politiques : ";
	if (empty($outM)){
		$message=$message."Mensuelle, ";
	}
	
	if (empty($outHi)){
		$message=$message."Hebdomadaire (incrétencielle), ";
	}
	
	if (empty($outHf)){
		$message=$message."Hebdomadaire (full), ";
	}
	
	if (empty($outJ)){
		$message=$message."Jounalière, ";
	}

	$message=$message."ont été modifiées";
	echo '<script type="text/javascript">window.alert("'.$message.'");</script>';
	header('Refresh: 0; url=../index.php?Cat=2');
}

?>