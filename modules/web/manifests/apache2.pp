class web::apache2 {
  package{ "apache2":
    ensure => installed
  }

  service{ "apache2" :
    enable     => true,
    ensure     => running,
    require  => Package["apache2"],
    hasrestart => true,
    hasstatus  => true
  }

  exec { "reload-apache2":
    command => "/etc/init.d/apache2 reload",
    onlyif => "/usr/sbin/apache2ctl -t",
    require => Service["apache2"],
    refreshonly => true,
  }
}

