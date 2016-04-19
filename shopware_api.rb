require 'httparty'
# Use the class methods to get down to business quickly

class ShopwareApi
  include HTTParty
  #for int use htaccess-data too
  puts self
  puts
  
  def initialize()#username, password) 
  end

  def setDigest(username, password, url_base)
    class_httparty = self.class
    class_httparty.base_uri url_base
    class_httparty.default_options.delete(:basic_auth)
    @auth_digest = {:username => username, :password => password}
    class_httparty.digest_auth username, password
    puts "auth_digest:#{@auth_digest}"
  end
  
  def setBasic(username, password, url_base)
    class_httparty = self.class
    class_httparty.base_uri url_base
    class_httparty.default_options.delete(:digest_auth)
    @auth_basic = {:username => username, :password => password}
    class_httparty.digest_auth username, password
    puts "auth_basic:#{@auth_basic}"
  end

  
  #customers
  def getCustomers()
    options = { :digest_auth => @auth_digest } #:basic_auth => @auth_ht,
    self.class.get("/customers", options)
  end
  
  def getCustomer(id)
    options = { :digest_auth => @auth_digest }
    self.class.get("/customers/#{id}", options)
  end
  
  def deleteCustomer(id)
    options = { :digest_auth => @auth_digest }
    self.class.delete("/customers/#{id}", options)
  end
  
end

