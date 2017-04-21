<?php
include('./include/utility/connect_database.php');

$DayArray=array(
	1=>"Lundi",
	2=>"Mardi",
	3=>"Mercredi",
	4=>"Jeudi",
	5=>"Vendredi",
	6=>"Samedi",
	7=>"Dimanche"
);

?>

<div class="section center z-depth-3">
	<h5>Etats des Sauvegardes</h5>
</div><br/>

<div class="container">

	<div class="z-depth-1" name="table">
		<table>
			<thead class="z-depth-2">
				<tr>
					<?php

					for ($i=6; $i>=0; $i--) {
						$NewDay=exec('date -d "-'.$i.' days" +"%d"');
						$NumDay=exec('date -d "-'.$i.' days" +"%u"');
						echo "<td>".$DayArray[$NumDay]." ".$NewDay."</td>";
					}

					?>
				</tr>
			</thead>

			<tbody>
				<tr>

<?php

for ($i=6; $i>=0; $i--) {

	$Month=exec('date -d "-'.$i.' days" +"%m"');
	$NewDay=exec('date -d "-'.$i.' days" +"%d"');

	if ($NewDay < 10 ) {
		$NewDay = substr($NewDay,1);
	}

	$query = "SELECT DisplayState FROM State INNER JOIN Save ON State.id = Save.state WHERE month=$Month and day=$NewDay";
	$result = mysqli_query($link, $query);
	$row = mysqli_fetch_array($result, MYSQLI_NUM);

	$Etat = $row[0];

	switch ($Etat) {
		case 'OK-NE':
			$State="light-blue darken-4"; // OK mais erreur export
		break;

		case 'PS':
			$State="cyan"; // OK pas de svg
		break;

		case 'KT':
			$State="orange"; // KO erreur lors de la svg
		break;

		case 'EC':
			$State="white black-text"; // svg en cours
			$Etat="EC";
		break;
						
		case 'DP':
			$State="orange"; // Etat "anormale"
		break;

		default:
			if (strpos($Etat, 'OK') !== false) {
				$State="green"; // OK
			}
			else {
				$State="red"; // KO
			}
		break;
	}
	$drop=$Etat;
	include('./include/others/dropdown-state.php');
	if (empty($Etat)) {
		$Etat="Entrée vide";
		$drop="Entree";
		$State="info"; // Etat "anormale"
	}

?>
					<td>
						<a class='dropdown-button btn <?php echo $State;?> z-depth-1' href='#' data-activates='<?php echo $drop;?>'><?php echo $Etat;?></a>
					</td>
<?php
}
?>
				</tr>
			</tbody>
		</table>
	</div>
</div>

<?php

$db = $_SESSION["db"];
if ($db == "AthenaDEV") {
	include('./include/categories/states_Bis.php');
}

?>