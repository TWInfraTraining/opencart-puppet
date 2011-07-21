define opencart::install( $db_host = "localhost", $db_database = "opencart",  $db_username = "opencart", $db_password ) {

  $install_location = "/var/opencart"
  
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

  file { "config.php":
    path => "${install_location}/config.php",
    content => template("opencart/config.php"),
    owner => "www-data",
    require => Package["opencart"],
  }

  file { "admin/config.php":
    path => "${install_location}/admin/config.php",
    content => template("opencart/admin/config.php"),
    owner => "www-data",
    require => Package["opencart"],
  }

  file { "${install_location}/install":
    ensure => absent,
    force => true,
    require => Package["opencart"],
  }

  file { "${install_location}/image":
    owner => "www-data",
    require => Package["opencart"],
    recurse => true,
  }

  file { "${install_location}/image/cache":
    owner => "www-data",
    require => Package["opencart"],
    recurse => true,
  }

  file { "${install_location}/cache":
    owner => "www-data",
    require => Package["opencart"],
    recurse => true,
  }
    
  file { "${install_location}/download":
    owner => "www-data",
    require => Package["opencart"],
    recurse => true,
  }

  file { "${install_location}/system":
    owner => "www-data",
    require => Package["opencart"],
    recurse => true,
  }

  apache2::site {
    "000-default": ensure => 'absent';
  }

  apache2::site { "opencart":
    ensure => 'present',
    require => Package["opencart"],
  }

}
