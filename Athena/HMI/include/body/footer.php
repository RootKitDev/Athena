<!-- Footer ATHENA -->
<?php
	if ($_SESSION["db"] == "AthenaDEV") {
		echo "<footer class=\"page-footer red darken-2 \">";
	}
	elseif ($_SESSION["db"] == "AthenaPREPROD") {
		echo "<footer class=\"page-footer green darken-2 \">";
	}
	else {
		echo "<footer class=\"page-footer blue darken-3 \">";
	}
?>

	<div class="container">
		 <div class="row">
			<div class="col 7 offset-6 s6">
				<h5 class="white-text">Liens</h5>
				<ul>
					<li><a class="grey-text text-lighten-3" href="mailto:rootkit.dev@gmail.com">rootkit.dev@gmail.com</a></li>
					<li><a class="grey-text text-lighten-3" href="https://github.com/RootKitDev/">GitHub/RootKitDev</a></li>
				</ul>
			</div>
		</div>
	</div>
<?php
	if ($_SESSION["db"] == "AthenaDEV") {
		echo "<div class=\"footer-copyright red darken-2\">";
	}
	elseif ($_SESSION["db"] == "AthenaPREPROD") {
		echo "<div class=\"footer-copyright green darken-2\">";
	}
	else {
		echo "<div class=\"footer-copyright indigo darken-1\">";
	}
?>
		<div class="container">
			© MIT RootKit 2016-2017
		</div>
		<div class="container">
<?php
	if ($_SESSION["db"] == "AthenaDEV") {
		$env="DEV";
	}
	elseif ($_SESSION["db"] == "AthenaPREPROD") {
		$env="PREPROD";
	}
	else {
		$env="PROD";
	}
	echo $env." V";
	echo exec("/var/www/html/Outils/IHM/Conf/Version $env");
?>
		</div>
	</div>
</footer>