module RingADing
  class Client

    include RingADing::Authentication
    # We use the same syntax for all authorization type id / token

    # API KEY / SECRET
    # Client.new(auth_type: 'api-key', api_key: your_api_key, api_secret: your_api_secret)
    #
    # LOGIN / PASSWORD
    # Client.new(auth_type: 'xxx', api_key: your_login, api_secret: your_password)
    #
    # TOKEN_BASED (Bearer, api_secret...) / api_secret
    # Client.new(auth_type: your_api_secret_methodo, api_key: nil, api_secret: your_token)
    #
    # Check Faraday doc for more infos
    MANDATORY_PARAMS = %i(auth_type api_key api_secret)
    MANDATORY_PARAMS.push(:options).each {|_attr| attr_accessor _attr}
    DEFAULT_TIMEOUT = 60
    DEFAULT_OPEN_TIMEOUT = 60

    # Methodo TBD
    def initialize(auth_type: nil, api_key: nil, api_secret: nil, options: {})
      @auth_type = auth_type
      @api_key = (api_key || ENV['KEYYO_API_KEY'])&.strip
      @api_secret = (api_secret || ENV['KEYYO_API_SECRET'])&.strip
      @options = options
      @options[:proxy] ||= ENV['KEYYO_PROXY']
      @options[:symbolize_keys] ||= false
      @options[:debug] ||= false
      @options[:logger] ||= ::Logger.new(STDOUT)
      @options[:ssl] ||= { version: "TLSv1_2" }
      @options[:timeout] ||= DEFAULT_TIMEOUT
      @options[:open_timeout] ||= DEFAULT_OPEN_TIMEOUT
      @options[:adapter] ||= Faraday.default_adapter
      handle_error
    end

    def handle_error
      if MANDATORY_PARAMS.all? {|_attr| self.send(_attr).nil? || self.send(_attr).empty? }
        raise InternalError, "Client must have following keys: #{MANDATORY_PARAMS.joins(', ')}"
      end
    end

    def connect
      set_creds_given_auth_type
      conn = Faraday.new(@options[:url], proxy: @options[:proxy], ssl: @options[:ssl]) do |http|
        http.response :raise_error
        http.response :logger, @options[:logger], bodies: true if @options[:debug]
        if basic_authenticated?
          http.basic_auth(@login, @password)
        elsif digest_authenticated?
          http.request :digest, @login, @password
        elsif token_authenticated?
          http.authorization :token, @token
        elsif bearer_authenticated?
          http.authorization :Bearer, @bearer_token
        end
        http.adapter @options[:adapter]
      end
      return conn
    end

    private

    # Refacto: should I keep the unless ?
    # Refacto: how to set attr_access ?
    # Refacto: How to ensure no SLQ injection... => OCktokit ConfigurableKeys ?
    # def init_instance_variables
    #   method(__method__).parameters.each do |arg|
    #     ivar = "@#{arg[1]}".to_sym
    #     ival = binding.local_variable_get(arg[1])
    #     instance_variable_set(ivar, ival) unless ival
    #   end
    # end
  end
end
