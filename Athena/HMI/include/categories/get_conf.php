<div class="section center z-depth-3">
	<h5>Export de Configuration</h5>
</div>


<div class="container">
<?php
	if ($_SESSION["Role"] != 4) {
		$Athena = fopen("/var/www/html/Outils/IHM/webacces/download/Athena.conf", 'w+');
		fputs($Athena, "[Flag]".chr(13).chr(13));

		if (empty(exec('ls /home/athena/Core/Flags/ | grep -v -E "Block"'))){
			fputs($Athena, "	[Block]".chr(13).chr(13));
			fputs($Athena, "		All".chr(13).chr(13));
			fputs($Athena, "	[/Block]".chr(13).chr(13));
		}
		else{
		fputs($Athena, "	[Block]".chr(13));

		$List_Block = scandir('/home/athena/Core/Flags/Block');
		foreach ($List_Block as $Flag) {
			if ($Flag != "." && $Flag != "..")
			{
				fputs($Athena, "		$Flag".chr(13));
			}
		}
		fputs($Athena, "	[/Block]".chr(13).chr(13));

		$List_NoBlock = scandir('/home/athena/Core/Flags');
		foreach ($List_NoBlock as $Flag) {
			if ($Flag != "." && $Flag != ".." && $Flag != "Block")
				{
					fputs($Athena, "	$Flag".chr(13));
				}
			}
		}
		fputs($Athena, chr(13)."[/Flag]");
		fclose($Athena);
?>

	<div class="col s12 m4 l6">
		<div class="card">
			<div class="card-content black-text">

				<form class="center"<?php if ($_SESSION["Role"] < 4) : ?>method="post" action="./functions/download.php"<?php endif; ?>>
					<p class="center">Voulez-vous télécharger votre fichier de configuration Athena ?</p>
			</div>

			<div class="center card-action">
					<button class="btn waves-effect waves-light green" type="submit" name="action">Oui
						<i class="small material-icons right">send</i>
					</button>
					<a class="waves-effect waves-light btn red" href="<?php echo "$page?Cat=1"; ?>">Non</a>
				</form>
			</div>
		</div>
	</div>

<?php
	}
	else {
		echo '<script type="text/javascript">window.alert("En Demo cette fonction c\'est pas disponible");</script>';
	}
?>
</div>

<?php
if ($_SESSION["Role"] > 4) {
	echo '<script type="text/javascript">window.alert("L\'export de configuration Athena ne peux être modifiée que par un technicien, un admin ou un consultant");</script>';

}
?>
