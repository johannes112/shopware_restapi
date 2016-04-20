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
    response_data = self.class.get("/api/customers", options)
    #p response_data
    #to get json:
    #response_json = response_data.parsed_response
    #p "\n\n#{response_json}"
    processHash(response_data)
    if response_data.success?
      response_data
    else
      raise response_data.response_data
    end
  end

  
  def getCustomer(id) #get one customer with id
    options = { :digest_auth => @auth_digest }
    self.class.get("/api/customers/#{id}", options)
    
  end
  
  def deleteCustomer(id) #delete customer with id
    options = { :digest_auth => @auth_digest }
    self.class.delete("/api/customers/#{id}", options)
    
  end
  
  def processHash(given_response_httpParty)
    #get whole data of api
    whole_response = given_response_httpParty.parsed_response
    #get all keys
    whole_keys = whole_response.keys
    #save part of keys
    data = whole_response.fetch("data")
    data_id = data.fetch("id")
    total = whole_response.fetch("total")
    last_entity = total-1
    #printAll(data, total)
    p data[1]
    #save entities of data
    #p data[last_entity]

    # p totaljson_response = JSON.parse(given_response_httpParty.body)
    # p "json_response: #{json_response.class}"
    # #json_response_customer_id= hash_response_httpParty["data"][1]
    # json_response_customer = json_response.fetch("data")
    # json_response_customer_id = json_response_customer.find { |h| h['id'] == '1' }
    # json_response_customer_mail = json_response_customer.find { |h| h['mail'] == 'nils.wolfram@em-group.de' }
    #p json_response_customer_id
    #p json_response_customer_mail
    #cu = json_response["data"].find{ |customer| customer['id']=='1'}['email']
    #puts cu
    
    #puts "\ncustomers:#{hash_customers["groupKey"]}"
    #puts "\nid:#{given_hash["data"].select {|customer| customer["id"] = 1}}"
    #given_hash.each_pair {|key,value| puts "#{key} = #{value}"}
    
    # given_hash.each do |key, value|
    #   case (key)
    #   when 'data'
    #     handle_some_key(value)
    #   when 'total'
    #     handle_other_key(value)
    #   end
    #end
    #filtered_hash = 
    #given_hash.each_pair {|key,value| puts key if value == 1} 
    #puts filtered_hash
    #converted_hash = JSON.parse(given_hash)
    #puts converted_hash
    
    # json_response = JSON.parse(given_response_httpParty.body)
    # p "json_response: #{json_response.class}"
    # #json_response_customer_id= hash_response_httpParty["data"][1]
    # json_response_customer = json_response.fetch("data")
    # json_response_customer_id = json_response_customer.find { |h| h['id'] == '1' }
    # json_response_customer_mail = json_response_customer.find { |h| h['mail'] == 'nils.wolfram@em-group.de' }
    #p json_response_customer_id
    #p json_response_customer_mail
    #cu = json_response["data"].find{ |customer| customer['id']=='1'}['email']
    #puts cu
    
    #puts "\ncustomers:#{hash_customers["groupKey"]}"
    #puts "\nid:#{given_hash["data"].select {|customer| customer["id"] = 1}}"
    #given_hash.each_pair {|key,value| puts "#{key} = #{value}"}
    
    # given_hash.each do |key, value|
    #   case (key)
    #   when 'data'
    #     handle_some_key(value)
    #   when 'total'
    #     handle_other_key(value)
    #   end
    #end
    #filtered_hash = 
    #given_hash.each_pair {|key,value| puts key if value == 1} 
    #puts filtered_hash
    #converted_hash = JSON.parse(given_hash)
    #puts converted_hash
  end

  def printAll(data, last_element)  
  counter = 0
    while counter < last_element do
      p ""
      p data[counter]
      counter += 1
    end
  end
  
end

