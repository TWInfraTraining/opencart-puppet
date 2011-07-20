import "database"
import "opencart"

include mysql

mysqldb { 'opencart':
  user => "opencart",
  password => "openpass",
}

opencart::load_schema { "opencart":
  password => "openpass",
  require => Mysqldb['opencart'],
}
