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
    if response_data.success?
      response_data
    else
      raise response_data.response_data
    end
    
    customers = response_data
    getCustomersAll(customers)
  end

  
  def getCustomer(id) #get one customer with id
    options = { :digest_auth => @auth_digest }
    response_data = self.class.get("/api/customers/#{id}", options)
    if response_data.success?
      response_data
    else
      raise response_data.response_data
    end
    
    customer = response_data
    p customer
  end
  
  def deleteCustomer(id) #delete customer by id
    options = { :digest_auth => @auth_digest }
    self.class.delete("/api/customers/#{id}", options)
  end
  
  def deleteCustomerByKey(key, value) #delete customer with key by value
    options = { :digest_auth => @auth_digest }
    response_data = self.class.get("/api/customers", options)
    if response_data.success?
      response_data
    else
      raise response_data.response_data
    end
    
    customers = response_data
    p "delete user with id: #{getCustomerByKey(customers, key, value)}"
    #self.class.delete("/api/customers/#{getCustomerByKey(customers, key, value)}", options)
  end
  
  #get all customers
  def getCustomersAll(given_response_httpParty)
    #get whole data of api
    response_whole = given_response_httpParty.parsed_response
    customer = response_whole
    #get all keys
    keys_whole = customer.keys
    #save part of keys and unique entities
    customer_data = customer.fetch("data")
    customer_data_keys = customer_data[0].keys
    customer_total = customer.fetch("total")
    customer_last_entity = customer_total-1
    customer_data_key = "email"
    printAll(customer_data, customer_data_key, customer_total)
  end

  def printAll(data, key, last_element)  
  counter = 0
    while counter < last_element do
      p "ID:#{data[counter]["id"]}"
      p "#{key}:#{data[counter][key]}"
      counter += 1
    end
  end
  

  #get customer of id
  def getCustomerByKey(given_response_httpParty, given_key, given_value)
    #get whole data of api
    whole_response = given_response_httpParty
    customer = whole_response
    #save part of keys and unique entities
    customer_data = customer.fetch("data")
    customer_total = customer.fetch("total")
    customer_data_key = given_key
    customer_data_value = given_value
    
    searchForValue(customer_data, customer_data_key, customer_data_value, customer_total)
  end

  def searchForValue(data, key, value, last_element)  
    counter = 0
    #loop over all elements
    while counter < last_element do
      #save each customer into overwritten variable received_data
      received_data = data[counter][key]
      #check var for value and then print the id of the received_data
      if received_data==(value)
        #p data[counter]["id"]
        customer_id_determined = data[counter]["id"]
        p "customer_id:#{customer_id_determined}"
        if customer_id_determined
          return customer_id_determined
        else
          return "No user with #{key}:#{value} exists!"
        end
      end
      counter += 1
    end
  end

end

