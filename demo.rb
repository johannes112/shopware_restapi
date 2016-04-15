require_relative 'shopware_api'
username = ARGV[0]
apikey = ARGV[1]
customer_para = ARGV[2]
shopware_user1 = ShopwareApi.new(username, apikey)
puts shopware_user1.getCustomer(customer_para)
