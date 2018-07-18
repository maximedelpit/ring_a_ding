require 'pry-byebug'
module RingADing
  class Request

    ATTR_ACCS = [
      :api_key, :api_secret, :oauth2_token, :base_api_url, :api_endpoint,
      :timeout, :open_timeout, :proxy, :faraday_adapter,
      :symbolize_keys, :debug, :logger
    ]
    DEFAULT_TIMEOUT = 60
    DEFAULT_OPEN_TIMEOUT = 60
    BASE_API_URL = 'https://ssl.keyyo.com/' # TEST TO DO => must provide a BASE API URL

    ATTR_ACCS.each {|_attr| attr_accessor _attr}
    # Hash[ATTR_ACCS.map {|v| [v, nil]}]

    # Refacto: change initialize params make it an options at list
    # Refacto : link this to client => module ?
    # Remove and put in client :api_key, :api_secret, :oauth2_token, OPTIONS=> :timeout, :open_timeout, :proxy, :faraday_adapter, symbolize_keys: false, debug: false, :logger
    def initialize(api_key: nil, api_secret: nil, oauth2_token: nil, base_api_url: nil, api_endpoint: nil, timeout: nil, open_timeout: nil, proxy: nil, faraday_adapter: nil, symbolize_keys: false, debug: false, logger: nil)
      @path_parts = []
      @api_key = (api_key || ENV['KEYYO_API_KEY'])&.strip
      @api_secret = (api_secret || ENV['KEYYO_API_SECRET'])&.strip
      @oauth2_token = oauth2_token
      @base_api_url = base_api_url || BASE_API_URL
      @api_endpoint = api_endpoint
      @timeout = timeout || DEFAULT_TIMEOUT
      @open_timeout = open_timeout || DEFAULT_OPEN_TIMEOUT
      @proxy = proxy || ENV['KEYYO_PROXY'] # useful ?
      @faraday_adapter = faraday_adapter || Faraday.default_adapter
      @symbolize_keys = symbolize_keys || false
      @debug = debug || false
      @logger = logger || ::Logger.new(STDOUT)
    end

    def manager_api
      @base_api_url = RingADing::ManagerRequest::BASE_API_URL
      return self
    end

    def cti_api
      @base_api_url = RingADing::CTIRequest::BASE_API_URL
      return self
    end

    def method_missing(method, *args) # keep here
      # To support underscores, we replace them with hyphens when calling the API
      @path_parts << method.to_s.gsub("_", "-").downcase
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

    def path # keep here and remove .html REFACTO
      "#{@path_parts.join('/')}.html"
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

    # # This one is used to find the relevant Request API class so that client
    # # can use request automatically, without requiring the user to specify which API he wants to use
    # # PB Base API URL is always nil...
    # def find_relavant_api
    #   Dir.foreach('lib/ring_a_ding/request') do |item|
    #     begin
    #       klass_name =
    #       klass_name = "RingADing::#{klass_name}"
    #       klass = Object.const_get(klass_name)
    #       Object.const_get("#{klass}::BASE_API_URL") == self.base_api_url ? break : next
    #     rescue NameError
    #       error_params = { title: "UKNOWN API CLASS", status_code: 500 }
    #       error = KeyyoError.new("UKNOWN API CLASS: #{response.body}", error_params)
    #       raise error
    #     end
    #   end
    #   return klass
    # end

    protected

    def reset
      @path_parts = []
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


