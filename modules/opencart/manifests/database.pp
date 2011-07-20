define opencart::load_schema($host = "localhost", $user = $name, $database = $name, $password) {
  file { '/root/opencart.sql':
    content => template("opencart/schema.sql"),
  }

  exec { "load-opencart-schema":
    command => "/usr/bin/mysql -h ${host} -u${user} -p${password} ${database} < /root/opencart.sql",
    require => [ Mysqldb["opencart"], File["/root/opencart.sql"] ],
    subscribe => File['/root/opencart.sql'],
    refreshonly => true,
  }
}
