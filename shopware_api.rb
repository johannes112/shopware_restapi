require 'httparty'
require 'json'
# Use the class methods to get down to business quickly

class ShopwareApi
  include HTTParty
  #for int use htaccess-data too
  default_timeout 2
  
  def setDigest(username, password, url_base)
    class_httparty = self.class
    class_httparty.base_uri url_base
    class_httparty.default_options.delete(:basic_auth)
    @auth_digest = {:username => username, :password => password}
    class_httparty.digest_auth username, password
    #puts "auth_digest:#{@auth_digest}"
  end
  
  def setBasic(username, password, url_base)
    class_httparty = self.class
    class_httparty.base_uri url_base
    class_httparty.default_options.delete(:digest_auth)
    @auth_basic = {:username => username, :password => password}
    class_httparty.digest_auth username, password
    #puts "auth_basic:#{@auth_basic}"
  end

  
  #customers
  def getCustomers() #get all customers
    options = { :digest_auth => @auth_digest }
    response = self.class.get("/api/customers", options)
    hash = response.parsed_response
    if response.success?
      response
    else
      raise response.response
    end
    puts "Keys:#{hash.keys}"
    processHash(hash)
  end

  
  def getCustomer(id) #get one customer with id
    options = { :digest_auth => @auth_digest }
    self.class.get("/api/customers/#{id}", options)
    
  end
  
  def deleteCustomer(id) #delete customer with id
    options = { :digest_auth => @auth_digest }
    self.class.delete("/api/customers/#{id}", options)
    
  end
  
  def processHash(given_hash)
    #all
    #given_hash.each_pair {|key,value| puts "#{key} = #{value}"}
    #id
    #filtered_hash = 
    #given_hash.each_pair {|key,value| puts key if value == 1} 
    #puts filtered_hash
    converted_hash = JSON.parse(given_hash)
    puts converted_hash "id" => "nils.wolfram@em-group.de"
  end
  
end

