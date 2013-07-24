define mysqldb( $user, $password ) {
  exec { "create-${name}-db":
    unless => "/usr/bin/mysql -uroot ${name}",
    command => "/usr/bin/mysql -uroot -e \"create database ${name};\"",
    require => Service["mysql"],
  }

  exec { "grant-${name}-db":
    unless => "/usr/bin/mysql -u${user} -p${password} ${name}",
    command => "/usr/bin/mysql -uroot -e \"grant all on ${name}.* to ${user}@'%' identified by '$password';grant all on ${name}.* to ${user}@'localhost' identified by '$password';\"",
    require => [Service["mysql"], Exec["create-${name}-db"]]
  }
}
