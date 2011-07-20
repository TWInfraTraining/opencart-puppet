define opencart::install( $version = $name, $db_host = "localhost", $db_database = "opencart", $db_username = "opencart", $db_password, $hostname="localhost" ) {
  $destdir = "/var/opencart"
  
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

  package { "opencart":
    ensure => latest,
    provider => dpkg,
    # this file should be uploaded by your CI/deploy process
    source => "/home/ubuntu/opencart.deb",
    require => [ Package["php5-mysql"], Package["php5-gd"], Package["php5-curl"] ],
  }

  file { "$destdir/config.php":
    content => template("web/opencart/config.php"),
    owner => "www-data",
    require => Package["opencart"],
  }

  file { "$destdir/admin/config.php":
    content => template("web/opencart/admin/config.php"),
    owner => "www-data",
    require => Package["opencart"],
  }

  apache2::site {
    "default": ensure => 'absent';
    "default-ssl": ensure => 'absent';
  }

  apache2::site { "opencart":
      ensure => 'present',
      require => Package["opencart"],
  }

}
