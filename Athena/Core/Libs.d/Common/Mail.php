<?php


$Month = date("M");
$Day = date("d");

$res = substr($Day, 0, 1);

if ($res == 0) {
	$Day = substr($Day, 1, 1);
}

$Message = '';

exec("sed -n /\"".$Day." ".$Month."\"/,/\"Fin du script\"/p /path/to/athena/Core/Logs.d/Save.log > /path/to/athena/Core/Logs.d/WebLog.log");

$File = "/path/to/athena/Core/Logs.d/WebLog.log";

$lines = file($File);
$Open_File = fopen($File, 'r+');
$line = fgets($Open_File);
fclose($Open_File);

if (empty($line)) {
	$Message .= "Pas de Logs pour cette sauvegarde";
}
else {
	foreach ($lines as $line) {
		if (strpos($line, 'Save_SQL.log') !== false){
			exec("sed -n /\"".$Day." ".$Month."\"/,/\"Fin du script\"/p /path/to/athena/Core/Logs.d/Save_SQL.log > /path/to/athena/Core/Logs.d/WebLog.log");

			$FileSQL = "/path/to/athena/Core/Logs.d/WebLog.log";

			$linesSQL = file($FileSQL);
			$Open_File = fopen($FileSQL, 'r+');
			$lineSQL = fgets($Open_File);
			fclose($Open_File);

			foreach ($linesSQL as $lineSQL) {
				$Message .= $lineSQL."\n";
			}
		}
		else{
			$Message .= $line."\n";
		}
	}
}

date_default_timezone_set('Europe/Paris');

$Pre_Message = "Log de la sauvegarde du ".date("F j, Y, g:i a");
$Message = "\n\n".$Message."\n\n";
$Post_Message = '';
require '/path/to/athena/Core/Libs.d/Special/PHPMailer/PHPMailerAutoload.php';

$mail = new PHPMailer;

//$mail->SMTPDebug = 3;                               // Enable verbose debug output

$mail->isSMTP();                                      // Set mailer to use SMTP
$mail->Host = '';                                     // Specify main and backup SMTP servers
$mail->SMTPAuth = true;                               // Enable SMTP authentication
$mail->Username = '';                                 // SMTP username
$mail->Password = '     ';                           // SMTP password
$mail->SMTPSecure = '   ';                            // Enable TLS encryption, `ssl` also accepted
$mail->Port = 000;                                    // TCP port to connect to
		
$mail->setFrom('Username', '');
$mail->addAddress('Username', '');     // Add a recipient

$mail->Subject = 'Log de la sauvegarde du '.date("F j, Y, g:i a");
$mail->Body    = $Pre_Message.$Message.$Post_Message;

$mail->send();

?>