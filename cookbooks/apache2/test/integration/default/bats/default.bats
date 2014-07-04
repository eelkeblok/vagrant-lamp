#!/usr/bin/env bats

@test "ensure apache2 installed" {
  run dpkg -l apache2
  [ "$status" -eq 0 ]
  [ -f "/usr/lib/apache2/modules/httpd.exp" ]
  [ -f "/usr/share/apache2/build/envvars-std" ]
  [ -f "/etc/apache2/apache2.conf" ]
}

@test "ensure apache2 is runs" {
  run /usr/sbin/apache2
  [ "$status" -eq 0 ]
}

@test "apache is available on port 80" {
  run nc -z 0.0.0.0 80
  [ $status -eq 0 ]
}
