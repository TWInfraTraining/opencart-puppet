class web::php5 {
  include web::apache2

  package { "php5":
    ensure => installed,
    require => Package["apache2"],
    notify  => Service["apache2"],
  }
  
  # file {
  #   "/etc/apache2/mods-available/php5.conf":
  #     content => template("web/etc/apache2/mods-available/php5.conf"),
  #     mode => 440, owner => root, group => www-data;

  file { "/etc/php5/apache2/php.ini":
    content => template("web/etc/php5/apache2/php.ini"),
    mode => 0644, owner => root, group => root,
    notify  => Exec["reload-apache2"],
    require => Package["php5"],
  }
}
