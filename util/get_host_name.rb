def get_host_name
  local addresses = Socket.ip_address_list
  host = addresses.detect do |addrinfo|
    addrinfo.ipv4?
  end
  return host
end
