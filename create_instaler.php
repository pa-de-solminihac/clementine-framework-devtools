<?php
/**
 * Cree un fichier zip pour la derniere version de l'installeur (ie. à partir du dossier /clementine/www/install)
 * Le résultat sera /clementine/modules/install.zip
 * Le script met aussi à jour le numéro de version de l'installeur dans /clementine/modules/install_latest.txt
 */
require('lib_tools.php');
require('pclzip.lib.php');
$current_dir = dirname($_SERVER["PHP_SELF"]);
//echo $current_dir;

$filename = '../modules/install_latest.txt';
if (!$handle = fopen($filename, 'w')) {
    echo 'Impossible d\'ouvrir le fichier (' . $filename . ')';
    exit;
}

// Ecrivons quelque chose dans notre fichier.
if (fwrite($handle, date('YmdHis')) === FALSE) {
    echo 'Impossible d\'écrire dans le fichier (' . $filename . ')';
    exit;
}
fclose($handle);

copy('../modules/install_latest.txt', '../install/install_version.txt');
copy_recursive('../install/', 'install/');
@unlink('install/config.php');
@unlink_recursive('install/tmp');

$o_zip = new PclZip('install.zip');
$o_zip->create('install');

unlink_recursive('install');
copy('install.zip', '../modules/install.zip');
unlink('install.zip');

echo 'end';
?>