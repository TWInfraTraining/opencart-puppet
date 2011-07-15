define mysqldb( $user = $name , $password ) {
  exec { "create-${name}-db":
    unless => "/usr/bin/mysql -uroot ${name}",
    command => "/usr/bin/mysql -uroot -e \"create database ${name};\"",
    require => Service["mysql"],
  }

  exec { "grant-${name}-db":
    unless => "/usr/bin/mysql -u${user} -p${password} ${name}",
    command => "/usr/bin/mysql -uroot -e \"grant all on ${name}.* to ${user}@'%' identified by '$password';\"",
    require => [Service["mysql"], Exec["create-${name}-db"]]
  }
}
