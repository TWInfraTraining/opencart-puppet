<?php
// HTTP
define('HTTP_SERVER', '/');
define('HTTP_IMAGE', '/image/');
define('HTTP_ADMIN', '/admin/');

// HTTPS
define('HTTPS_SERVER', '/');
define('HTTPS_IMAGE', '/image/');

// DIR
define('DIR_APPLICATION', '/var/opencart/catalog/');
define('DIR_SYSTEM', '/var/opencart/system/');
define('DIR_DATABASE', '/var/opencart/system/database/');
define('DIR_LANGUAGE', '/var/opencart/catalog/language/');
define('DIR_TEMPLATE', '/var/opencart/catalog/view/theme/');
define('DIR_CONFIG', '/var/opencart/system/config/');
define('DIR_IMAGE', '/var/opencart/image/');
define('DIR_CACHE', '/var/opencart/system/cache/');
define('DIR_DOWNLOAD', '/var/opencart/download/');
define('DIR_LOGS', '/var/opencart/system/logs/');


// DB
define('DB_DRIVER', 'mysql');
define('DB_HOSTNAME', '<%= db_host %>');
define('DB_USERNAME', '<%= db_username %>');
define('DB_PASSWORD', '<%= db_password %>');
define('DB_DATABASE', '<%= db_database %>');
define('DB_PREFIX', '');
?>