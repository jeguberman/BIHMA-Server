def get_host_address_ipv4 #returns last listed ipv4 address for current host which isn't the loopback address. If no address is found, returns loopback address

  # reserved_address = ["127"]#, "192"] #do research on reserved ip addresses
  hostAddr = nil
  localhost = ""

  Socket.ip_address_list.each do |addrinfo|
    if addrinfo.ipv4?
      if addrinfo.ip_address.slice(0..2) == "127"
        localhost = addrinfo.ip_address
      else
        hostAddr = addrinfo.ip_address #this assumes that there will only be one listed ipv4 address, or at least the last ipv4 addr is valid for what we want to do. I'm only just breaking into ip routing, so this might not be a problem, but assumptions break things so I'm making a note.
      end
    end
  end

  unless localhost
    raise StandardError "Unable to determine host IP, even at 127"
  end

  hostAddr ||= localhost
  return hostAddr
end
