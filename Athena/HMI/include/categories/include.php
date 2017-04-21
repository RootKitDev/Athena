<div class="section center  z-depth-3">
	<h5>Dossier à inclure</h5>
</div><br />


<?php
$InMen = "/home/athena/Core/ListSave.d/ListSaveMen";
?>
<div class="container">
	<div class="row">
		<div class="col s12 m6 l6 z-depth-1">
			<form <?php if (($_SESSION["Role"] == 1) || ($_SESSION["Role"] == 2)) : ?> metod="post" action="./functions/update_include.php" <?php endif; ?>> 
				<div class="input-field">
					<textarea name="InMen" class="materialize-textarea"><?php echo file_get_contents($InMen); ?></textarea>
					<label for="textarea1">Sauvegarde Mensuelle (Hebdomadaire Incrementielle)</label>
					<div class="center card-action">
					<a class="waves-effect waves-light btn"><input type="submit" value="Inclure" /></a>
					</div><br />
				</div>
			</form>
		</div>
<?php
$InHebF = "/home/athena/Core/ListSave.d/ListSaveHeb";
?>
		<div class="col s12  m6 l6 z-depth-1">
			<form<?php if (($_SESSION["Role"] == 1) || ($_SESSION["Role"] == 2)) : ?> metod="post" action="./functions/update_include.php" <?php endif; ?>> 
				<div class="input-field">
					<textarea name="InHebF" class="materialize-textarea"><?php echo file_get_contents($InHebF); ?></textarea>
					<label for="textarea1">Sauvegarde Hebdomadaire (Journalière Incrementielle)</label>
					<div class="center card-action">
					<a class="waves-effect waves-light btn"><input type="submit" value="Inclure" /></a>
					</div><br />
				</div>
			</form>
		</div>
	</div>
</div>

<?php
if ( !(($_SESSION["Role"] == 1) || ($_SESSION["Role"] == 2)) ) {
	echo '<script type="text/javascript">window.alert("Les inclusions ne peux être modifiée que par un techicien ou un admin");</script>';

}
?>