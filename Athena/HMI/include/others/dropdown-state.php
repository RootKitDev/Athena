	<?php

	switch ($Etat) {
			case "OK":
	?>
			<ul id='OK' class='dropdown-content'>
				<li><a href="./include/options/logs.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>" onclick="window.open(this.href); return false;">Logs</a></li>
				<li><a href="./include/options/cksums.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>" onclick="window.open(this.href); return false;">CkSums</a></li>
				<li><a href="./include/options/size.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>" onclick="window.open(this.href); return false;">Volumétrie</a></li>
			</ul>
	<?php
			break;
			case "OK-NE":
	?>
			<ul id='OK-NE' class='dropdown-content'>
				<li><a href="./include/options/logs.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>" onclick="window.open(this.href); return false;">Logs</a></li>
				<li><a href="./include/options/cksums.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>" onclick="window.open(this.href); return false;">CkSums</a></li>
				<li><a href="./include/options/size.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>" onclick="window.open(this.href); return false;">Volumétrie</a></li>
				<li class="divider"></li>
				<li><a href="./include/options/restart_export.php<?php if (($_SESSION["Role"] != 4) || ($_SESSION["Role"] < 3)): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>">Relancer l'export</a></li>
			</ul>
	<?php
			break;
			case "PS":
	?>
			<ul id='PS' class='dropdown-content'>
				<li><a href="./include/options/logs.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>" onclick="window.open(this.href); return false;">Logs</a></li>
			</ul>
	<?php
			break;
			case "KT":
	?>
			<ul id='KT' class='dropdown-content'>
				<li><a href="./include/options/logs.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>" onclick="window.open(this.href); return false;">Logs</a></li>
				<li class="divider"></li>
				<li><a href="./include/options/restart_export.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>">Relancer l'export</a></li>
			</ul>
	<?php
			break;
			case "EC":
	?>
			<ul id='EC' class='dropdown-content'>
				<li><a href="./include/options/logs.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>" onclick="window.open(this.href); return false;">Logs</a></li>
			</ul>
	<?php
			break;
			case "DP":
	?>
			<ul id='DP' class='dropdown-content'>
				<li><a href="<?php echo "$page?Cat=4"; ?>" >Réactiver les Sauvegardes</a></li>
			</ul>
	<?php
			break;
			case "KO":
	?>
			<ul id='KO' class='dropdown-content'>
				<li><a href="./include/options/logs.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>" onclick="window.open(this.href); return false;">Logs</a></li>
				<li class="divider"></li>
				<li><a href="./include/options/restart_save.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>">Relancer la Sauvegarde</a></li>
			</ul>
	<?php
			break;
			case "SQL_OK":
	?>
			<ul id='SQL_OK' class='dropdown-content'>
				<li><a href="./include/options/logs.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>" onclick="window.open(this.href); return false;">Logs</a></li>
				<li><a href="./include/options/cksums.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>" onclick="window.open(this.href); return false;">CkSums</a></li>
				<li><a href="./include/options/size.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>" onclick="window.open(this.href); return false;">Volumétrie</a></li>
			</ul>
	<?php
			break;
			case "SQL_OK-NE":
	?>
			<ul id='SQL_OK-NE' class='dropdown-content'>
				<li><a href="./include/options/logs.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>" onclick="window.open(this.href); return false;">Logs</a></li>
				<li><a href="./include/options/cksums.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>" onclick="window.open(this.href); return false;">CkSums</a></li>
				<li><a href="./include/options/size.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>" onclick="window.open(this.href); return false;">Volumétrie</a></li>
				<li class="divider"></li>
				<li><a href="./include/options/restart_export.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>">Relancer l'export</a></li>
			</ul>
	<?php
			break;
			case "SQL_KT":
	?>
			<ul id='SQL_KT' class='dropdown-content'>
				<li><a href="./include/options/logs.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>" onclick="window.open(this.href); return false;">Logs</a></li>
				<li class="divider"></li>
				<li><a href="./include/options/restart_export.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>">Relancer l'export</a></li>
			</ul>
	<?php
			break;
			case "SQL_KO":
	?>
			<ul id='SQL_KO' class='dropdown-content'>
				<li><a href="./include/options/logs.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>" onclick="window.open(this.href); return false;">Logs</a></li>
				<li class="divider"></li>
				<li><a href="./include/options/restart_save.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>">Relancer la Sauvegarde</a></li>
			</ul>
	<?php
			break;
			case "Entree":
	?>
			<ul id='Entree' class='dropdown-content'>
				<li><a href="./include/options/logs.php<?php if ($_SESSION["Role"] != 4): ?>?month=<?php echo $Month.'&day='.$NewDay;?><?php endif; ?>" onclick="window.open(this.href); return false;">Logs</a></li>
			</ul>
	<?php
			break;
		}

	?>
