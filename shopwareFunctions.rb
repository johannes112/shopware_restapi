module ShopwareFunctions
    #customers
  def getWholeData(data_of) #get all customers
    p connectAndGetData(data_of)
  end

  def getData(data_of, id) #get one customer with id
    url_data = stringGetUrlPath(data_of)
    url_request = "#{url_data}/#{id}"
    p "URL: #{url_request}"
    response_data = readData(url_request)
    p response_data
    return response_data
  end
  
  def connectAndGetData(url_of)
    # connect to url of given param and return its value
    url_data = stringGetUrlPath(url_of)
    url_request = url_data
    p "URL: #{url_request}"
    response_data = readData(url_request)
    return response_data
  end

  def deleteDataId(data_of, id) #delete customer by id
    url_data=  stringGetUrlPath(data_of)
    url_request = "#{url_data}/#{id}"
    p "Delete URL: #{url_request}"
    deleteData(url)
  end
  
  def deleteDataByKey(data_of, key, value) #delete customer with key by value
    url_data = stringGetUrlPath(data_of)
    url_request = "#{url_data}/"
    p "URL: #{url_request}"
    response_data = readData(url_request)
    data = response_data
    data_to_remove = getDataByKey(data, key, value)
    deleteCustomer("Customers", data_to_remove)
    p data_to_remove
  end
  
  #get all Data
  def getDataAll(given_response_httpParty, data_of)
    #get whole data of api
    response_whole = given_response_httpParty.parsed_response
    #get all keys
    #keys_whole = customer.keys
    #save part of keys and unique entities
    data = response_whole.fetch("data")
    total = response_whole.fetch("total")
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
      received_data = data[key]
    return received_data
  end  
  
  def getOrderByKey(given_response_httpParty, given_key)
    #one entity of ordertable
    one_order = given_response_httpParty
    data = one_order.fetch("data")
    data_key = given_key
    data_value = intSearchForKey(data, data_key)
    return data_value
  end
  
  def setOrderByKey(given_response_httpParty, given_key)
    #one entity of ordertable
    one_order = given_response_httpParty
    data = one_order.fetch("data")
    data_key = given_key
    data_value = intSearchForKey(data, data_key)
    return data_value
  end
  
  def setValue(data_of, id, key, value) #update entity of id and set key to value
    options = { 
      :digest_auth => @auth_digest ,
      :body => { :orderStatusId => 4}
    }
    url_data = stringGetUrlPath(data_of)
    #url_request = "#{url_data}/#{id}/#{key}/#{value}":query => { :email => "alan+thinkvitamin@carsonified.com" })
    url_request = "#{url_data}/#{id}"
    p "PUT: #{url_request}"
    updateData(url_request, options)
  end
  
  def updateDataBy(key, value) #update statusOrderId to 4 of order with order_id 
    #get order_id of order with customer_id with key and value 
    #1. get customer_id of customer with mailaddress
    #2. get order_id of order with customer_id
    #3. get orderStatusId of order
    #4. set orderStatusId of order
    # looking for id of user which belongs to mailaddress
    data_customers = connectAndGetData('Customers')
    data_orders = connectAndGetData('Orders')
    #1. get customer_id by key
    customer_id = getDataByKey(data_customers, key, value)
    p "UPDATE:customer_id:#{customer_id}"
    #2. get order_id by key
    order_id = getDataByKey(data_orders, "customerId", customer_id)
    #3. get orderStatusId
    order_orderStatus = getData("Orders", order_id)
    order_orderStatus_Id = getOrderByKey(order_orderStatus, "orderStatusId")
    #set orderStatus_Id to 4 (Stoniert / Abgelehnt)
    p "key:#{key}, value:#{value}"
    setValue("Orders", 399, "orderStatusId", 4)
    #to avoid an export of this data i have to set "orderStatusId" of the order to 4
  end
  

  def stringGetUrlPath(data_of)
    #decide which url have to be set
    data_of = data_of.downcase
    case (data_of)
      when 'customers'
        url = "/api/customers"
      when 'orders'
        url = "/api/orders"
    end
  end
end