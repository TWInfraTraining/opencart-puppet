class database::server {
  package { "mysql-server":
    ensure => installed,
  }

  file {
    '/etc/mysql/conf.d/allow_external.cnf':
      content => template("database/etc/mysql/conf.d/allow_external.cnf"),
      require => Package["mysql-server"],
      notify => Service["mysql"],
      mode => 0644, group   => mysql, owner   => mysql,
  }

  service { "mysql":
    enable => true,
    ensure => running,
    hasstatus => true,
    require => Package["mysql-server"],
  }
}
