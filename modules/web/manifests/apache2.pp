class apache2 {
  define site ( $ensure = 'present' ) {
    case $ensure {
      'present' : {
        exec { "/usr/sbin/a2ensite $name":
          unless => "/bin/readlink -e /etc/apache2/sites-enabled/$name",
          notify => Exec["reload-apache2"],
          require => Package[$require],
        }
      }
      'absent' : {
        exec { "/usr/sbin/a2dissite $name":
          onlyif => "/bin/readlink -e /etc/apache2/sites-enabled/$name",
          notify => Exec["reload-apache2"],
          require => Package["apache2"],
        }
      }
      default: { err ( "Unknown ensure value: '$ensure'" ) }
    }
  }
  
  define module ( $ensure = 'present', $require = 'apache2' ) {
    case $ensure {
      'present' : {
        exec { "/usr/sbin/a2enmod $name":
          unless => "/bin/readlink -e ${apache2_mods}-enabled/${name}.load",
          notify => Exec["force-reload-apache2"],
          require => Package[$require],
        }
      }
      'absent': {
        exec { "/usr/sbin/a2dismod $name":
          onlyif => "/bin/readlink -e ${apache2_mods}-enabled/${name}.load",
          notify => Exec["force-reload-apache2"],
          require => Package["apache2"],
        }
      }
      default: { err ( "Unknown ensure value: '$ensure'" ) }
    }
  }
  
  package{ "apache2":
    ensure => installed
  }
  
  exec { "reload-apache2":
    command => "/etc/init.d/apache2 reload",
    refreshonly => true,
  }
  
  exec { "force-reload-apache2":
    command => "/etc/init.d/apache2 force-reload",
    refreshonly => true,
  }
  
  # We want to make sure that Apache2 is running.
  service { "apache2":
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    require => Package["apache2"],
  }
}

