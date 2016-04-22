#this sample shows how to use the restapi of shopware with ruby
require_relative 'shopware_api'
username = ARGV[0]
puts "username:#{username}"
apikey = ARGV[1]
puts "apikey:#{apikey}"
husername = ARGV[2]
puts "husername:#{husername}"
hapikey = ARGV[3]
puts "hapikey:#{hapikey}"
urlname = ARGV[4]
puts "urlname:#{urlname}"

shopware_user1 = ShopwareApi.new()#husername, hapikey)
shopware_user1.setBasic(husername, hapikey, urlname)
#shopware_user1.connectHtaccess()
shopware_user1.setDigest(username, apikey, urlname)
#puts shopware_user1.deleteCustomer(63)
shopware_user1.getCustomer(83)
#shopware_user1.getCustomers()
#shopware_user1.deleteCustomerByKey("email", "robert.hoermann@emmos.de")
#shopware_user1.deleteCustomerByKey("email", "johannes.launer@emmos.de")


