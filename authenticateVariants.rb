module AuthenticateVariants
  #use for connection with htaccess but it does not work as expected
  def setBasic(username, password, url_base)
    class_httparty = self.class
    #set url
    class_httparty.base_uri url_base
    class_httparty.default_options.delete(:digest_auth)
    @auth_basic = {:username => username, :password => password}
    class_httparty.digest_auth username, password
    #puts "auth_basic:#{@auth_basic}"
  end
  def getBasic()
    return @auth_basic
  end

  #use for connection with shopware api
  def setDigest(username, password, url_base)
    class_httparty = self.class
    #set url
    class_httparty.base_uri url_base
    class_httparty.default_options.delete(:basic_auth)
    @auth_digest = {:username => username, :password => password}
    class_httparty.digest_auth username, password
    #puts "auth_digest:#{@auth_digest}"
  end
  def getDigest()
    return @auth_digest
  end 
end