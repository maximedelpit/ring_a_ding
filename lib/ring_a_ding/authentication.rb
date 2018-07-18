module RingADing
  module Authentication
     # Indicates if the client was supplied  Basic Auth
     # username and password
     def basic_authenticated?
       !!(@login && @password)
     end

     # Indicates if the client was supplied an OAuth
     # access token
     def token_authenticated?
       !!@access_token
     end

     # Indicates if the client was supplied a bearer token
     def bearer_authenticated?
       !!@bearer_token
     end

     # Indicates if the client was supplied an OAuth
     # access token or Basic Auth username and password
     def user_authenticated?
       basic_authenticated? || token_authenticated?
     end

     # Indicates if the client has OAuth Application
     # client_id and secret credentials to make anonymous
     # requests at a higher rate limit
     def application_authenticated?
       !!application_authentication
     end

     def set_creds_given_auth_type
      if @auth_type == 'basic'
        @login = @api_key
        @password = @api_secret
      elsif @auth_type == 'token'
        @token = @api_secret
      elsif @auth_type == 'Bearer'
        @bearer_token = @api_secret
      else
        error_params = { title: "UKNOWN Authentication Type", status_code: 500 }
        raise  KeyyoError.new("UKNOWN Authentication Type", error_params)
      end
     end

     private

     # def application_authentication
     #   if @api_key && @api_secret
     #     {
     #       :client_id     => @api_key,
     #       :client_secret => @api_secret
     #     }
     #   end
     # end
   end
end
