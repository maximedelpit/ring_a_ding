# TO DO : Replace KeyyoError with Internal Error
module RingADing
  class Request

    BASE_API_URL = nil
    ATTR_ACCS = %i(client base_api_url options path_parts)#api_endpoint
    SUB_SYM = '_' # used to fit method_missing undersocre with endpoint format (xxx_yyy / xxx-yyy)
    ATTR_ACCS.each {|_attr| attr_accessor _attr}
    # Hash[ATTR_ACCS.map {|v| [v, nil]}]

    # Refacto: change initialize params make it an options at list
    # Refacto : link this to client => module ?
    # Remove and put in client :api_key, :api_secret, :oauth2_token, OPTIONS=> :timeout, :open_timeout, :proxy, :faraday_adapter, symbolize_keys: false, debug: false, :logger
    def initialize(client, options={})
      @client = instantiate_client(client, options)
      @path_parts = []
      @base_api_url = options[:base_api_url] || self.class::BASE_API_URL
      @options = options
      # @api_endpoint = options[:api_endpoint]
      unless @base_api_url
        raise KeyyoError.new("Missing API Endpoint", {title: 'Missing API Endpoint', error: 500})
      end
    end

    def method_missing(method, *args) # keep here
      # To support underscores, we replace them with hyphens when calling the API
      @path_parts << method.to_s.gsub("_", SUB_SYM).downcase # it seems Keyyo use underscores
      @path_parts << args if args.length > 0
      @path_parts.flatten!
      self
    end

    def respond_to_missing?(method_name, include_private = false) #keep it here
      true
    end

    def send(*args) # keep here
      args.length == 0 ? method_missing(:send, args) : __send__(*args)
    end

    def path # keep here
      "#{@base_api_url}#{@path_parts.join('/')}"
    end

    def create(params: nil, headers: nil, body: nil) # keep here
      APIRequest.new(builder: self).post(params: params, headers: headers, body: body)
    ensure
      reset
    end

    def update(params: nil, headers: nil, body: nil) # keep here
      APIRequest.new(builder: self).patch(params: params, headers: headers, body: body)
    ensure
      reset
    end

    def upsert(params: nil, headers: nil, body: nil) # keep here
      APIRequest.new(builder: self).put(params: params, headers: headers, body: body)
    ensure
      reset
    end

    def retrieve(params: nil, headers: nil) # keep here
      APIRequest.new(builder: self).get(params: params, headers: headers)
    ensure
      reset
    end

    def delete(params: nil, headers: nil) # keep here
      APIRequest.new(builder: self).delete(params: params, headers: headers)
    ensure
      reset
    end

    protected

    def reset
      @path_parts = []
      @options[:url] = nil if @options[:url]
      @client.options[:url] = nil if @client.options[:url]
    end

    def instantiate_client(c, opts)
      if c.is_a?(Client)
        c
      elsif c.is_a?(Hash)
        Client.new(auth_type: c[:auth_type], api_key: c[:api_key], api_secret: c[:api_secret], options: opts)
      else
        raise KeyyoError.new("client must be a Client or a Hash", {title: "ClientError", error: 500})
      end
    end
    # class << self # Useless & remove from initialize & tests => we want to force use of an instance for client
    #   ATTR_ACCS.each {|_attr| attr_accessor _attr}

    #   def method_missing(sym, *args, &block)
    #     new(api_key: self.api_key, api_secret: self.api_secret, oauth2_token: self.oauth2_token, base_api_url: self.base_api_url, api_endpoint: self.api_endpoint, timeout: self.timeout, open_timeout: self.open_timeout, faraday_adapter: self.faraday_adapter, symbolize_keys: self.symbolize_keys, debug: self.debug, proxy: self.proxy, logger: self.logger).send(sym, *args, &block)
    #   end

    #   def respond_to_missing?(method_name, include_private = false)
    #     true
    #   end
    # end
  end
end


