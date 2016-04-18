require_relative 'shopware_api'
username = ARGV[0]
apikey = ARGV[1]
#customer_para = ARGV[2]
husername = ARGV[2]
hapikey = ARGV[3]
shopware_user1 = ShopwareApi.new(username, apikey)
#shopware_user1.setHtaccess(husername, hapikey)
#shopware_user1.connectHtaccess(husername, hapikey)
puts shopware_user1.getCustomers()
