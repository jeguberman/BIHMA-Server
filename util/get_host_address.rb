def get_host_address
  Socket.ip_address_list.detect do |addrinfo|
    addrinfo.ipv4? &&
    addrinfo.ip_address != "127.0.0.1"
  end.ip_address
end
