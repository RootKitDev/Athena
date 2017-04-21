<?php
	function CryptConf($filename) {
		if (file_exists($filename)) {

			# --- CHIFFREMENT ---

			$AthenaKeyFile = "/var/www/html/Outils/IHM/file/secure/Athena.key";

			if (!file_exists($AthenaKeyFile)) {
				$rand1=rand(0, 100);
				$rand2=rand(0, 100);

				$characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
				$charactersLength = strlen($characters);
				$passphrase = '';
				for ($i = 0; $i < 10; $i++) {
					$passphrase .= $characters[rand(0, $charactersLength - 1)];
				}

				$key = substr(md5("$rand1".$passphrase, true).md5("$rand2".$passphrase, true), 0, 24);
				$AthenaKey = fopen($AthenaKeyFile, 'w+');
				fputs($AthenaKey, $key);
			} else {
				$AthenaKey = fopen($AthenaKeyFile, 'r');
				$key = fgets($AthenaKey);
			}

			fclose($AthenaKey);

			$AthenaIvFile = "/var/www/html/Outils/IHM/file/secure/Athena.size";

			if (!file_exists($AthenaIvFile)) {
				$iv_size = mcrypt_get_iv_size(MCRYPT_RIJNDAEL_128, MCRYPT_MODE_CBC);
				$AthenaIvSize = fopen("$AthenaIvFile", 'w+');
				fputs($AthenaIvSize, $iv_size);

			} else {
				$AthenaIvSize = fopen("$AthenaIvFile", 'r');
				$iv_size = fgets($AthenaIvSize);
			}
			
			$iv = mcrypt_create_iv($iv_size, MCRYPT_RAND);
			fclose($AthenaIvFile);

			$AthenaConf = fopen($filename, 'r');
			$plaintext = file_get_contents($filename);
			fclose($AthenaConf);

			$ciphertext = mcrypt_encrypt(MCRYPT_RIJNDAEL_128, $key, $plaintext, MCRYPT_MODE_CBC, $iv);
			$ciphertext = $iv . $ciphertext;
			$ciphertext_base64 = base64_encode($ciphertext);

			$AthenaConf = fopen($filename, 'w+');
			fputs($AthenaConf, $ciphertext_base64);
			fclose($AthenaConf);
		}
	}

?>
