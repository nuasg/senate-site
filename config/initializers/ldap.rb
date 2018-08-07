require 'net/ldap'

module NetID
  class Auth
    HOST = "registry.northwestern.edu"
    PORT = 636
    PASSWORD = ENV['LDAP_PWD']
    USER = "cn=asgnulink,ou=pwcheck,dc=northwestern,dc=edu"
  end
end