import "web"
import "opencart"

include apache2
include php5

# provide with facter
opencart::install { "opencart",
  $db_host = $database_host,
  $db_password = $database_password,
}
