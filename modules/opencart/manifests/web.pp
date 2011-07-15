define opencart::install( $version = "1.4.9.4", $db_host = "localhost", $db_database = "opencart", $db_username = "opencart", $db_password, $hostname="localhost" ) {
  $location = "/var/www"
  
  $staging_dir = "/root/opencart-$version"
  $download_location = "/opt/opencart_v$version.zip"
  
  package { "wget":
    ensure => installed,
    notify  => Service["apache2"],
  }

  package { "unzip":
    ensure => installed,
  }

  package { "php5-mysql":
    ensure => installed,
    require => Package["php5"],
    notify  => Service["apache2"],
  }

  package { "php5-gd":
    ensure => installed,
    require => Package["php5"],
    notify  => Service["apache2"],
  }

  package { "php5-curl":
    ensure => installed,
    require => Package["php5"], 
    notify  => Service["apache2"],
  }

  file { "$location":
    ensure => directory,
  }

  file { "$location/index.html":
    ensure => absent,
    require => Service["apache2"],
  }

  file { "$staging_dir":
    ensure => directory,
    recurse => true,
  }
  
  exec { "fetch-opencart":
    command => "wget http://opencart.googlecode.com/files/opencart_v1.4.9.4.zip -O $download_location",
    creates => "$download_location",
    path => "/usr/bin",
    require => [ File["$staging_dir"], Package["wget"], Package["php5-mysql"], Package["php5-curl"], Package["php5-gd"] ],
  }

  exec { "extract-opencart":
    command => "unzip $download_location",
    cwd => "$staging_dir",
    path => "/usr/bin",
    require => [ Exec["fetch-opencart"], Package["unzip"] ],
    creates => "$staging_dir/upload",
  }

  exec { "install-opencart":
    command => "cp -r $staging_dir/upload/* $location",
    creates => "$location/index.php",
    path => "/bin",
    require => Exec["extract-opencart"],
  }

  file { "$location/install":
    ensure => absent,
    force => true,
    require => Exec["install-opencart"],
  }

  file { "$location/config.php":
    content => template("web/opencart/config.php"),
    owner => "www-data",
    require => Exec["install-opencart"],
  }

  file { "$location/admin/config.php":
    content => template("web/opencart/admin/config.php"),
    owner => "www-data",
    require => Exec["install-opencart"],
  }

  file { "$location/image":
    owner => "www-data",
    require => Exec["install-opencart"],
    recurse => true,
  }

  file { "$location/image/cache":
    owner => "www-data",
    require => Exec["install-opencart"],
    recurse => true,
  }

  file { "$location/cache":
    owner => "www-data",
    require => Exec["install-opencart"],
    recurse => true,
  }
    
  file { "$location/download":
    owner => "www-data",
    require => Exec["install-opencart"],
    recurse => true,
  }

  file { "$location/system":
    owner => "www-data",
    require => Exec["install-opencart"],
    recurse => true,
  }

}

