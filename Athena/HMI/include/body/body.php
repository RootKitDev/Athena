<?php

// Body ATHENA

	switch ($Cat) {
		case 1:
			include('./include/categories/states.php');
		break;
		case 2:
			include('./include/categories/frequency.php');
		break;
		case 3:
			include('./include/categories/get_ex_save.php');
		break;
		case 4:
			include('./include/categories/include.php');
		break;
		case 5:
			include('./include/categories/exclude.php');
		break;
		case 6:
			include('./include/categories/policy.php');
		break;
		case 7:
			include('./include/categories/resto.php');
		break;
		case 8:
			include('./include/categories/send_conf.php');
		break;
		case 9:
			include('./include/categories/get_conf.php');
		break;
		case 10:
			include('./include/categories/pref.php');
		break;
		case 11:
			include('./functions/alim.php');
		break;
		case 12:
			include('./functions/change_env.php');
		break;
		default:
			echo "<br /><centre>Une erreur est survenu, redirection vers la page d'accueil</centre>";
			header("Refresh: 5; url=$page");
		break;
	}
?>