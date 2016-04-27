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
  def getWholeData(data_of) #get all customers
    p connectAndGetData(data_of)
    #getDataAll(response_data, data_of)
  end

  
  def getData(data_of, id) #get one customer with id
    options = { :digest_auth => @auth_digest }
    url_data = stringGetUrlPath(data_of)
    url_request = "#{url_data}/#{id}"
    p "URL: #{url_request}"
    response_data = self.class.get(url_request, options)
    if response_data.success?
      response_data
    else
      p "Can not connect"
    end
    response_data_json = response_data.parsed_response
    p response_data_json
  end
  
  def deleteData(data_of, id) #delete customer by id
    options = { :digest_auth => @auth_digest }
    url_data=  stringGetUrlPath(data_of)
    url_request = "#{url_data}/#{id}"
    p "Delete URL: #{url_request}"
    response_data = self.class.delete(url_request, options)
    if response_data.success?
      response_data
    else
      p "Can not connect"
    end
  end
  
  def deleteDataByKey(data_of, key, value) #delete customer with key by value
    options = { :digest_auth => @auth_digest }
    url_data = stringGetUrlPath(data_of)
    url_request = "#{url_data}/"
    p "URL: #{url_request}"
    response_data = self.class.get(url_request, options)
    if response_data.success?
      response_data
    else
      p "Can not connect"
    end
    
    data = response_data
    data_to_remove = getDataByKey(data, key, value)
    #deleteData("Customers", data_to_remove)
    p data_to_remove
  end
  
  #get all Data
  def getDataAll(given_response_httpParty, data_of)
    #get whole data of api
    response_whole = given_response_httpParty.parsed_response
    #customer = response_whole
    #get all keys
    #keys_whole = customer.keys
    #save part of keys and unique entities
    data = response_whole.fetch("data")
    data_keys = data[0].keys
    total = response_whole.fetch("total")
    last_entity = total-1
    # set attribute
    case (data_of) 
    when 'Customers'
      data_key = "email"
    when 'Orders'
      data_key = "customerId"
    end
    printAllElements(data, data_key, total)
  end

  def printAllElements(data, key, last_element)  
  counter = 0
    while counter < last_element do
      p "ID:#{data[counter]["id"]}"
      p "#{key}:#{data[counter][key]}"
      counter += 1
    end
  end
  

  #get customer of id
  def getDataByKey(given_response_httpParty, given_key, given_value)
    #get whole data of api
    whole_response = given_response_httpParty
    whole_response = whole_response
    #save part of keys and unique entities
    data = whole_response.fetch("data")
    total = whole_response.fetch("total")
    data_key = given_key
    data_value = given_value
    #check for existence of value
    occur_frequency = intCheckForValue(data, data_key, data_value, total)
    if(occur_frequency > 0)
      if(occur_frequency == 1)
        data_to_delete = intSearchForValue(data, data_key, data_value, total)
        return data_to_delete
      else
        p "!!!"
        p "several(#{occur_frequency}) with #{data_key}:#{data_value} exist"
        p "can not delete more than one ID"
      end
    else
      p ("no #{data_key} with this value (#{data_value}) exists")
      p 
      #p data
    end
  end

  def intCheckForValue(data, key, value, last_element)  
    #how often value exists
    counter_loop = 0
    value_counter_occurrence = 0
    #loop over all elements
    while counter_loop < last_element do
      #save each customer into overwritten variable received_data
      received_data = data[counter_loop][key]
      #check var for value and then print the id of the received_data
      if received_data == (value)
        value_counter_occurrence += 1
      end
      counter_loop += 1
    end
    return value_counter_occurrence
  end

  def intSearchForValue(data, key, value, last_element)  
    counter = 0
    #loop over all elements
    while counter < last_element do
      #save each customer into overwritten variable received_data
      received_data = data[counter][key]
      #check var for value and then print the id of the received_data
      if received_data == (value)
        customer_id_determined = data[counter]["id"]
        #p "customer_id:#{customer_id_determined}"
        return customer_id_determined
      end
      counter += 1
    end
  end  
  
  def intSearchForKey(data, key)  
      p "key:#{key}"
      received_data = data['orderStatusId']
      p "received_data:#{received_data}"
    return received_data
  end  
  
  def getOrderByKey(given_response_httpParty, given_key)
    #get whole data of api
    one_order = given_response_httpParty
    data = one_order.fetch("data")
    data_key = given_key
    data_value = intSearchForKey(data, data_key)
    return data_value
  end
  
  def updateData(key, value) 
    #get order_id of order with customer_id with key and value 
    #1. get customer_id of customer with mailaddress
    #2. get order_id of order with customer_id
    #3. get orderStatusId of order
    #4. get order
    # looking for id of user which belongs to mailaddress
    data_customers = connectAndGetData('Customers')
    data_orders = connectAndGetData('Orders')
    #1.
    customer_id = getDataByKey(data_customers, key, value)
    p "UPDATE:customer_id:#{customer_id}"
    #2.
    order_id = getDataByKey(data_orders, "customerId", customer_id)
    p "UPDATE:order_id:#{order_id}"
    #3.
    order_orderStatus = getData("Orders", order_id)
    #p "order_orderStatus: #{order_orderStatus}"
    order_orderStatus_Id = getOrderByKey(order_orderStatus, "orderStatusId")
    #order_orderStatus_Id = getDataByKey(order_orderStatus, "orderStatusId", order_id)
    p order_orderStatus_Id
    #determined_order_json = determined_order.parsed_response
    #p "search key (#{key}) value (#{customer_id})"
    p
    p "Determined_order:order_id:#{order_orderStatus_Id}"
    #determined_order = getData('Orders', determined_order_id)
    #determined_order_orderStatus = getData(determined_order, "orderStatus")
    #p determined_order_orderStatus
    #to avoid an export of this data i have to set "orderStatusId" of the order to 4
    
  end
  
  def connectAndGetData(url_of)
    # connect to url of given param and return its value
    options = { :digest_auth => @auth_digest }
    url_data = stringGetUrlPath(url_of)
    url_request = url_data
    p "URL: #{url_request}"
    response_data = self.class.get(url_request, options)
    if response_data.success?
      response_data
    else
      p "Can not connect"
    end
    response_data_json = response_data.parsed_response
    return response_data_json
  end

  def stringGetUrlPath(data_of)
    #decide which url have to be set
    case (data_of)
      when 'Customers'
        url = "/api/customers"
      when 'Orders'
        url = "/api/orders"
    end
  end
  
end

