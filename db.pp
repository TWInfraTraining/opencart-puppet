import "database"

include database::server

database::opencart { 'opencart':
  password => "openpass",
}
