<?php
	if ($_SESSION["Role"] != 4) {

		if (!empty($_GET['ExMen'])){
			$ExMen=$_GET['ExMen'];
			$ArrayExMen=explode("\n", $ExMen);
			$ExMenFile = fopen("/home/athena/Core/ExcludeSave.d/ListExcludeMen", 'w+');

			foreach ($ArrayExMen as $line) {
				fputs($ExMenFile, $line);
			}
		}

		if (!empty($_GET['ExHebF'])){
			$ExHeb=$_GET['ExHebF'];
			$ArrayExHeb=explode("\n", $ExHeb);
			$ExHebFile = fopen("/home/athena/Core/ExcludeSave.d/ListExcludeHeb", 'w+');
			
			foreach ($ArrayExHeb as $line) {
				fputs($ExHebFile, $line);
			}
		}

	echo '<script type="text/javascript">window.alert("Les listes d\'exclusions ont été mise à jour");</script>';
	header('Refresh: 0; url=../index.php?Cat=1');

	}
?>