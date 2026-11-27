<?php
date_default_timezone_set('Asia/Ho_Chi_Minh');
session_start();
ob_start();
// echo date ('Y:m:d H:i:s');
include './includes/config.php';
require_once'./modules/auth/login.php'
?>