import "database"
import "web"
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

include apache2
include php5

opencart::install { "opencart":
  db_password => "openpass",
}

## Magic for forcing apt-get update to run before any package commands...
# This also where you'd configure the use of an apt cache
file { "/etc/apt/apt.conf.d/15update-stamp":
	ensure => present,
	content => "APT::Update::Post-Invoke-Success {\"touch /var/lib/apt/periodic/update-success-stamp 2>/dev/null || true\";};",
}

exec {"apt-get update":
	unless => "/usr/bin/test $(expr `date +%s` - `stat -c %Y /var/lib/apt/periodic/update-success-stamp`) -le 3600",
	command => "/usr/bin/apt-get update",
	require => File["/etc/apt/apt.conf.d/15update-stamp"]
}
Exec["apt-get update"] -> Package <||> 
## end of magic