# ----------
# Failover Configuration
# ----------
class dhcp::failover (
  $role                = 'primary',
  $address             = $ipaddress,
  $peer_address,
  $port                = '519',
  $max_response_delay  = '30',
  $max_unacked_updates = '10',
  $mclt                = '300',
  $load_split          = '128',
  $load_balance        = '3',
  $omapi_key           = '',
  $interface           = 'eth0',
) {

  include dhcp::params
  $dhcp_dir = $dhcp::params::dhcp_dir

  concat::fragment { 'dhcp-conf-failover':
    target  => "${dhcp_dir}/dhcpd.conf",
    content => template('dhcp/dhcpd.conf.failover.erb'),
  }

  @firewall { '301 accept DHCP Failover Port 519 UDP connections':
    port    => $port,
    proto   => udp,
    action  => accept,
    source  => $peer_address,
    iniface => $interface,
  }

  @firewall { '302 accept DHCP Failover Port 519 TCP connections':
    port    => $port,
    proto   => tcp,
    action  => accept,
    source  => $peer_address,
    iniface => $interface,
  }
}
