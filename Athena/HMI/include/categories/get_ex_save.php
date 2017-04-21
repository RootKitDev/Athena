<div>
	<div>
		<div class="section center z-depth-3">
			<h5>Programmer une sauvegarde exceptionnelle</h5>
		</div>
		<div class="divider"></div>
	</div>
	<div>
		<div>
			<div>
			<?php
				if (empty($FlagDP)) {
					if (empty($FlagEx)) {
			?>

<div class="container">
	<div class="row">
		<div class="col s12 m12 l12">
			<div class="card">
				<div class="card-content black-text">
	
						<form class="center"method="post" action="./functions/ex_save.php">
							<p class="center">Voulez-vous programmer une sauvegarde exceptionnelle ce soir ? </p>
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
	</div>
</div>
			
			<?php
					}
					else {
			?>
						<form>
							<p>Une sauvegarde exceptionnelle est déja programmée ce soir </p>
							 <a href="<?php echo "$page?Cat=1"; ?>">Retour à l'index</a></p>
						</form>
			<?php
					}
				}
				else {
			?>
						<form>
							<p>Il n'est pas possible de prévoir une sauvegarde exceptionnelle si les sauvegardes sont désactivées </p>
							<a href="<?php echo "$page?Cat=1"; ?>">Retour à l'index</a></p>
						</form>
			<?php
					}
			?>
			</div>
		</div>
	</div>
</div>

<?php
if ( !(($_SESSION["Role"] == 1) || ($_SESSION["Role"] == 2)) ) {
	echo '<script type="text/javascript">window.alert("Une sauvegarde exceptionnelle ne peux être programmée que par un techicien ou un admin");</script>';
	header('Refresh: 0; url=./index.php?Cat=1');
}
?>