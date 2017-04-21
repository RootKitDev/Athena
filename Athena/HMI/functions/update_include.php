<?php
	if ($_SESSION["Role"] != 4) {

		if (!empty($_GET['InMen'])){
			$IncMen=$_GET['InMen'];
			$ArrayIncMen=explode("\n", $IncMen);
			$IncMenFile = fopen("/home/athena/Core/ListSave.d/ListSaveMen", 'w+');

			foreach ($ArrayIncMen as $line) {
				fputs($IncMenFile, $line);
			}
		}

		if (!empty($_GET['InHebF'])){
			$IncHeb=$_GET['InHebF'];
			$ArrayIncHeb=explode("\n", $IncHeb);
			$IncHebFile = fopen("/home/athena/Core/ListSave.d/ListSaveHeb", 'w+');
			
			foreach ($ArrayIncHeb as $line) {
				fputs($IncHebFile, $line);
			}
		}

	echo '<script type="text/javascript">window.alert("Les listes d\'inclusions ont été mise à jour");</script>';
	header('Refresh: 0; url=../index.php?Cat=1');

	}
?>