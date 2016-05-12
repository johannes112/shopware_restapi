#Use ruby to control the restapi of Shopware
This is a simple sample which shows how to use ruby to execute api of shopware.

To execute this demo:
_ruby demo.rb <user_api> <pw_api> <user> <pw> <url>_

##Methods:
There are functions for managing the connection setting and functions to speak with the restapi of Shopware

###Connection:
* setBasic(htaccess_username, htaccess_password, urlname) : to set an username and password for htaccess-authentication (for server)
* setDigest(username, apikey, urlname) : to set an username and apikey for digest-authentication (for shopware)

###Shopware:
* getWholeData('<attribut>') : to get whole data of given attribut | possible attributes: orders, customers
* getData('<attribut>', <ID>) : to get data of specific customer or order with the given ID
* deleteDataId("<attribut>", <ID>) : to delete specific customer or order with the given ID
* deleteDataByKey("Customers", "email", "test.test@test.de") : to delete specific customer or order with the given value ot the given property
* updateDataBy("<identifier>", "<value>") : it was designed to set the orderStatusId of the customer with the identifier and its related value to canceled (4) = cancel an order

######more info: http://community.shopware.com/_detail_861_487.html