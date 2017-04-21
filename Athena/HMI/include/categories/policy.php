<?php
	if (empty($FlagM)) {
		$checkM="checked";
	}
	else {
		$checkM="";
	}

	if (empty($FlagHi)) {
		$checkHi="checked";
	}
	else {
		$checkHi="";
	}

	if (empty($FlagHf)) {
		$checkHf="checked";
	}
	else {
		$checkHf="";
	}

	if (empty($FlagJ)) {
		$checkJ="checked";
	}
	else {
		$checkJ="";
	}

?>



<div class="section center z-depth-3">
	<h5>Politique de Sauvegardes</h5>
</div>
<?php
	if ($_SESSION["Role"] != 4) {
		if(empty($FlagDP))
		{
	?>
<div class="container">
	<div class="col s12 m4 l6">
		<div class="card">
			<div class="card-content black-text">
				<form <?php if (($_SESSION["Role"] == 1) || ($_SESSION["Role"] == 2)) : ?> metod="post" action="./functions/update_save_state.php" <?php endif; ?>> 
					<input type="checkbox" id="SaveM" name="SaveM" <?php echo $checkM; ?> /><label for="SaveM">Activée les sauvergardes Mensuelles (Full)</label>
					<br />
					<input type="checkbox" id="SaveHi" name="SaveHi" <?php echo $checkHi; ?> /><label for="SaveHi">Activée les sauvergardes Hebdomadaire (Incrémentiel)</label>
					<br />
					<input type="checkbox" id="SaveHf" name="SaveHf" <?php echo $checkHf; ?> /><label for="SaveHf">Activée les sauvergardes Hebdomadaire (Full)</label>
					<br />
					<input type="checkbox" id="SaveJ" name="SaveJ" <?php echo $checkJ; ?> /><label for="SaveJ">Activée les sauvergardes Journamière (Incrémentiel)</label>
					<br />
			</div>
					<div class="center card-action">
						<button class="btn waves-effect waves-light green" type="submit" name="action">Valider le changement
							<i class="small material-icons right">send</i>
						</button>
						<a class="waves-effect waves-light btn red" href="<?php echo "$page?Cat=1"; ?>">Annuler l'action</a>
					</div>
				</form>
		</div>
	</div>
			<?php
					}
					else
					{
			?>
	<div class="col s12 m4 l6">
		<div class="card">
			<div class="card-content black-text">
				<input type="checkbox" disabled readonly name="SaveM" ><label for="SaveM">Activée les sauvergardes Mensuelles (Full)</label>
				<br />
				<input type="checkbox" disabled readonly name="SaveHi" ><label for="SaveHi">Activée les sauvergardes Hebdomadaire (Incrémentiel)</label>
				<br />
				<input type="checkbox" disabled readonly name="SaveHf" ><label for="SaveHf">Activée les sauvergardes Hebdomadaire (Full)</label>
				<input type="checkbox" disabled readonly name="SaveJ" ><label for="SaveJ">Activée les sauvergardes Journamière (Incrémentiel)</label>
				<br />
			</div>
				<div class="center card-action">
					<a class="waves-effect waves-light btn red" href="<?php echo "$page?Cat=1"; ?>">Retour à l'index</a>
				</div>
		</div>
	</div>
			<?php
					}
			?>
	<div class="col s12 m4 l6">
		<div class="card">
			<div class="card-content black-text">
				<form <?php if (($_SESSION["Role"] == 1) || ($_SESSION["Role"] == 2)) : ?> metod="post" action="./functions/up-down_save.php" <?php endif; ?>> 
			<?php
					if(!empty($FlagDP))
					{
			?>
						<input type="checkbox" id="UpSave" name="UpSave" /><label for="UpSave">Réactiver les Sauvegardes</label>
			<?php
					}
					else
					{
			?>
						<input type="checkbox" id="DownSave" name="DownSave" /><label for="DownSave">Désactiver les Sauvegardes</label>
			<?php
					}
			?>
					<br />
					<br />
			</div>

						<div class="center card-action">
							<button class="btn waves-effect waves-light green" type="submit" name="action">Valider le changement
								<i class="small material-icons right">send</i>
							</button>
							<a class="waves-effect waves-light btn red" href="<?php echo "$page?Cat=1"; ?>">Annuler l'action</a>
						</div>
					</form>
		</div>
	</div>
			<?php
				}
				else {
			?>
	<div class="col s12 m4 l6">
		<div class="card">
			<div class="card-content black-text">
				<form>
					<input type="checkbox" name="SaveM" disabled readonly> Activée les sauvergardes Mensuelles (Full)
					<br />
					<input type="checkbox" name="SaveHi" disabled readonly> Activée les sauvergardes Hebdomadaire (Incrémentiel)
					<br />
					<input type="checkbox" name="SaveHf" disabled readonly> Activée les sauvergardes Hebdomadaire (Full)
					<br />
					<input type="checkbox" name="SaveJ" disabled readonly> Activée les sauvergardes Journamière (Incrémentiel)
					<br />
				</form>
			</div>

			<div class="center card-action">
				<form>
					<input type="checkbox" name="UpSave"> Réactiver les Sauvegardes
					<input type="checkbox" name="DownSave"> Désactiver les Sauvegardes
					<br />
					<br />
				</form>
			</div>
		</div>
	</div>
</div>
			<?php
				}

if ( !(($_SESSION["Role"] == 1) || ($_SESSION["Role"] == 2)) ) {
	echo '<script type="text/javascript">window.alert("La politique de sauvegarde ne peux être modifiée que par un techicien ou un admin");</script>';

}
?>
