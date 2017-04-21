<?php

session_start();

session_destroy();

echo '<script type="text/javascript">window.alert("Vous êtes à présent déconnecté");</script>';
header('Refresh: 0; url=../../index.php');

?>