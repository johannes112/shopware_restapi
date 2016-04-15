require 'httparty'
# Use the class methods to get down to business quickly

# Or wrap things up in your own class
class ShopwareApi
  include HTTParty
  base_uri 'https://www.chefworks.de/api'

  def initialize(u, p)
    @auth = {:username => u, :password => p}
  end

  def getCustomer
    options = { :digest_auth => @auth }
    self.class.get("/customers", options)
  end
  
  def getCustomer(id)
    options = { :digest_auth => @auth }
    self.class.get("/customers/#{id}", options)
  end

end

