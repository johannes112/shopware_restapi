require 'httparty'
# Use the class methods to get down to business quickly

# Or wrap things up in your own class
class ShopwareApi
  include HTTParty
  #for int use htaccess-data too
  base_uri 'chefworks.de/api'
  puts base_uri
  puts self
  #http://int.chefworks.de/api/customers

  def initialize(username, password) 
    @auth_digest = {:username => username, :password => password}
  end
  
  # def setHtaccess(huser, hpass)
  #   @auth_htacess = {:username => huser, :password => hpass}
  # end

  # def connectHtaccess(huser, hpass)
  #   @auth_htacess = {:username => huser, :password => hpass}
  #   options = { :basic_auth => @auth_htacess } #:basic_auth => @auth_ht,
  #   self.class.get(options)
  #   puts base_uri
  #   puts self.class
  # end
  
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

