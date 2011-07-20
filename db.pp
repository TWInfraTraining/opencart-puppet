import "database"
import "opencart"

include mysql

# provide db password with facter

mysqldb { 'opencart':
  password => $database_password,
}

opencart::load_schema { "opencart":
  $password = $database_password,
  require => Mysqldb['opencart'],
}
