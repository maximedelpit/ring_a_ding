module RingADing
  class Client
    attr_accessor :conn
    def initialize(conn_opts)
      @conn_opts = conn_opts
      @conn = setup_rest_client
    end

    def authenticate
      @client.basic_auth('apikey', self.api_key)
    end

    private

    def setup_rest_client
      return Faraday.new(@conn_opts) do |faraday|
        faraday.response :raise_error
        # faraday.adapter faraday_adapter
        faraday.response :logger, @conn_opts[:logger], bodies: true if @conn_opts[:debug]
      end
    end
  end
end
