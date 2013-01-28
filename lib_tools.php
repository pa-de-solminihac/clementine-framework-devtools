<?php
/**
 * Recursively delete a directory
 *
 * @param string $dir Directory name
 * @param boolean $delete_root_too Delete specified top-level directory as well
 */
function unlink_recursive ($dir, $delete_root_too = true)
{
    if (!$dh = @opendir($dir)) {
        return false;
    }
    while (false !== ($obj = readdir($dh))) {
        if ($obj == '.' || $obj == '..') {
            continue;
        }
        if (!@unlink($dir . '/' . $obj)) {
            unlink_recursive($dir . '/' . $obj, true);
        }
    }
    closedir($dh);
    if ($delete_root_too) {
        @rmdir($dir);
    }
    return true;
}

/**
 * Recursively copies a directory
 *
 * @param string $src Source directory
 * @param boolean $dst Destination directory
 */
function copy_recursive ($src, $dst) {
    $dir = opendir($src);
    @mkdir($dst, 0755);
    @chmod($dst, 0755);
    while (false !== ($file = readdir($dir))) {
        if (($file != '.') && ($file != '..') && ($file != '.svn')) {
            if (is_dir($src . '/' . $file)) {
                copy_recursive($src . '/' . $file, $dst . '/' . $file);
            } else {
                copy($src . '/' . $file,$dst . '/' . $file);
            }
        }
    }
    closedir($dir);
}
?>