<?php

	function UncryptConf($filename)
	{
		if (file_exists($filename)) {
			
			$AthenaKey = fopen("/var/www/html/Outils/IHM/file/secure/Athena.key", 'r');
			$key = fgets($AthenaKey);
			fclose($AthenaKey);
			
			$AthenaIvSize = fopen("/var/www/html/Outils/IHM/file/secure/Athena.size", 'r');
			$iv_size = fgets($AthenaIvSize);
			fclose($AthenaIvSize);
			
			# --- DECHIFFREMENT ---
			
			$AthenaConf = fopen($filename, 'r');
			$ciphertext_dec = base64_decode(fgets($AthenaConf));  
			fclose($AthenaConf);
			
			$iv_dec = substr($ciphertext_dec, 0, $iv_size);
	
			$ciphertext_dec = substr($ciphertext_dec, $iv_size);
		
			$plaintext_dec = mcrypt_decrypt(MCRYPT_RIJNDAEL_128, $key, $ciphertext_dec, MCRYPT_MODE_CBC, $iv_dec);
			
			$AthenaConf = fopen($filename, 'w+');
			fputs($AthenaConf, $plaintext_dec);
			fclose($AthenaConf);
		}
	}

?>
