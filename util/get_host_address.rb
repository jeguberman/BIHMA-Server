def get_host_address_ipv4 #returns first listed ipv4 address for current host which isn't localhost
  #if [no wifi]
  # return #local host
# end
  Socket.ip_address_list.detect do |addrinfo| #clean this up, make it clearer
    addrinfo.ipv4? &&
    addrinfo.ip_address != "127.0.0.1"
  end.ip_address
end
