module RingADing
  class OauthRequest < Request

    # https://ssl.keyyo.com/oauth2/authorize.php
    # https://api.keyyo.com/oauth2/token.php
    #  CAREFUL 2 different API URL for authorize & token!
    BASE_API_URL = nil #'https://ssl.keyyo.com/oauth2/'
    OAUTH_URLS = {
      authorize_url: 'https://ssl.keyyo.com/oauth2/',
      token_url: 'https://api.keyyo.com/oauth2/token.php',
      refresh_url: 'https://api.keyyo.com/oauth2/token.php'
    }

    def path
      super + ".php"
    end

    def authorize(redirect_uri)
      @base_api_url = OAUTH_URLS[:authorize_url]
      @path_parts << 'authorize'
      params = {
        redirect_uri: redirect_uri,
        response_type: "code",
        state: generate_state,
        client_id: @client.api_key
      }
      result = retrieve(params: params)
      # NB / REFACTO: should handle refesh there ?
      return result
    end

    def get_token(code, state)
      body = prepare_token_request(OAUTH_URLS[:token_url], 'token', 'authorization_code')
      body.merge!({code: code, state: state})
      result = create(body: body)
      return result
    end

    def refresh_token(refresh_token, redirect_uri)
      body = prepare_token_request(OAUTH_URLS[:refresh_url], 'token', 'refresh_token')
      body.merge!({refresh_token: refresh_token, redirect_uri: redirect_uri})
      result = create(body: body)
      return result
    end

    private

    def generate_state
      return '123'
    end

    def prepare_token_query(base_url, part_method_name, grant_type)
      @base_api_url = base_url
      @path_parts << part_method_name
      return {
        client_id: @client.api_key,
        client_secret: @client.api_secret,
        grant_type: grant_type
      }
    end
  end
end
