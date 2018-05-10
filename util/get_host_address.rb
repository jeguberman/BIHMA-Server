def get_host_address_ipv4 #returns first listed ipv4 address for current host which isn't localhost
  Socket.ip_address_list.detect do |addrinfo|
    addrinfo.ipv4? &&
    addrinfo.ip_address != "127.0.0.1"
  end.ip_address
end
