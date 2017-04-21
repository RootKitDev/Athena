<?php

// Header ATHENA

	$page = $_SERVER['PHP_SELF'];
	$Cat = $_GET['Cat'];

	$MAXCAT = ($_SESSION["db"] != 'Athena') ? 12 : 10;
	if (empty($Cat) or $Cat > $MAXCAT) {
		$Cat = 1;
	}

?>

<!-- Dropdown Structure -->
<?php include('./include/others/dropdown-header.php'); ?>

<!-- Dropdown Trigger -->
<nav>
<?php
	if ($_SESSION["db"] == "AthenaDEV") {
		echo "<div class=\"nav-wrapper red darken-2 z-depth-5\">";
	}
	elseif ($_SESSION["db"] == "AthenaPREPROD") {
		echo "<div class=\"nav-wrapper green darken-2 z-depth-5\">";
	}
	else {
		echo "<div class=\"nav-wrapper blue darken-3 z-depth-5\">";
	}
?>
		<ul id="nav-mobile" class="hide-on-med-and-down">
			<li><a class='dropdown-button btn indigo darken-1 z-depth-2' href='#' data-activates='Save'>Sauvegardes</a></li>
			<li><a class='dropdown-button btn indigo darken-1 z-depth-2' href='#' data-activates='Param'>Paramètrage</a></li>
			<li><a class='dropdown-button btn indigo darken-1 z-depth-2' href='#' data-activates='Conf'>Configuration</a></li>
			<li><a class='dropdown-button btn indigo darken-1 z-depth-2' href='./index.php?Cat=7' data-activates='resto'>Restauration</a></li>
			<li><a class='dropdown-button btn indigo darken-1 z-depth-2' href='./index.php?Cat=10' data-activates='account'>Compte</a></li>
			<?php if (($_SESSION["db"] != "Athena") && ($_SESSION['Role'] != 4)): ?><li><a class='dropdown-button btn indigo darken-1 z-depth-2' href='./index.php?Cat=11'>Alimentation</a></li><?php endif; ?>
			<?php if ($_SESSION["db"] == "AthenaDEV"): ?><li><a class='dropdown-button btn indigo darken-1 z-depth-2' href='./index.php?Cat=12'>Monter en PREPROD</a></li><?php endif; ?>
			<?php if (($_SESSION["db"] == "AthenaPREPROD") && ($_SESSION['Role'] == 5)): ?><li><a class='dropdown-button btn indigo darken-1 z-depth-2' href='./index.php?Cat=12'>Monter en PROD</a></li><?php endif; ?>
		</ul>
		<ul id="nav-mobile" class="right hide-on-med-and-down">
			<li><a href="./include/utility/disconnect.php">Déconnexion</a></li>
			<li><a href="../Dashboard/">DashBoard</a></li>
		</ul>
    </div>
</nav>


<?php
	$FlagM=exec('ls /home/athena/Core/Flags | grep "PS-001"');
	$FlagHi=exec('ls /home/athena/Core/Flags | grep "PS-003"');
	$FlagHf=exec('ls /home/athena/Core/Flags | grep "PS-002"');
	$FlagJ=exec('ls /home/athena/Core/Flags | grep "PS-004"');
	$FlagEx=exec('ls /home/athena/Core/Flags | grep "EX-000"');
	$FlagDP=exec('ls /home/athena/Core/Flags | grep "PS-000"');
?>