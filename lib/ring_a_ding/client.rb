module RingADing
  class Client

    include RingADing::Authentication
    # We use the same syntax for all authorization type id / token
    # API KEY / SECRET
    # Client.new(auth_type: 'api-key', login: your_api_key, token: your_api_secret)
    #
    # LOGIN / PASSWORD
    # Client.new(auth_type: 'xxx', login: your_login, token: your_password)
    #
    # TOKEN_BASED (Bearer, token...) / token
    # Client.new(auth_type: your_token_methodo, login: nil, token: your_token)
    #
    # Check Faraday doc for more infos

    # Methodo TBD
    def initialize(auth_type: nil, login: nil, token: nil, conn_opts: {})
      init_instance_variables
      # @conn_opts[:ssl] ||= { version: "TLSv1_2" }
    end

    def authenticate
      @conn = Faraday.new(@conn_opts[:api_url], proxy: @conn_opts[:proxy], ssl: @conn_opts[:ssl]) do |faraday|
        faraday.response :raise_error
        faraday.authorization :Bearer, @conn_opts[:token]
        faraday.adapter @conn_opts[:faraday_adapter]
        faraday.response :logger, @conn_opts[:logger], bodies: true if @conn_opts[:debug]
      end
      # @conn_opts[:token] ? @conn.token_auth(@conn_opts[:token]) : @conn.basic_auth('apikey', @conn_opts[:api_key]
      # @conn.token_auth(@conn_opts[:token])
      return @conn
    end

    private

    # Refacto: should I keep the unless ?
    # Refacto: how to set attr_access ?
    # Refacto: How to ensure no SLQ injection... => OCktokit ConfigurableKeys ?
    def init_instance_variables
      method(__method__).parameters.each do |arg|
        ivar = "@#{arg[1]}".to_sym
        ival = binding.local_variable_get(arg[1])
        instance_variable_set(ivar, ival) unless ival
      end
    end
  end
end
