import "database"
import "web"
import "opencart"

include mysql

mysqldb { 'opencart':
  password => "openpass",
}

opencart::load_schema { "opencart":
  password = "openpass",
  require => Mysqldb['opencart'],
}

include apache2
include php5

opencart::install { "opencart",
  db_password = "openpass",
}
