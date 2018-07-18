module RingADing
  class APIRequest

    def initialize(builder: nil)
      @request_builder = builder
    end

    def post(params: nil, headers: nil, body: nil)
      build_http_request(__method__, get_args(binding))
    end

    def patch(params: nil, headers: nil, body: nil)
      build_http_request(__method__, get_args(binding))
    end

    def put(params: nil, headers: nil, body: nil)
      build_http_request(__method__, get_args(binding))
    end

    def get(params: nil, headers: nil)
      build_http_request(__method__, get_args(binding))
    end

    def delete(params: nil, headers: nil)
      build_http_request(__method__, get_args(binding))
    end

    protected

    # Convenience accessors => Refacto => try not to list but instead use @request_builder directly (class method ? / intialize ?)
    # REFACTO => To be reviewed
    %i(api_key api_secret base_api_url api_endpoint timeout open_timeout proxy faraday_adapter symbolize_keys).each do |meth|
      define_method(meth) { @request_builder.send(meth) }
    end

    # Helpers
    def handle_error(error)
      error_params = {}
      begin
        if error.is_a?(Faraday::Error::ClientError) && error.response
          error_params[:status_code] = error.response[:status]
          error_params[:raw_body] = error.response[:body]

          parsed_response = MultiJson.load(error.response[:body], symbolize_keys: symbolize_keys)

          if parsed_response
            error_params[:body] = parsed_response

            title_key = symbolize_keys ? :title : "title"
            detail_key = symbolize_keys ? :detail : "detail"

            error_params[:title] = parsed_response[title_key] if parsed_response[title_key]
            error_params[:detail] = parsed_response[detail_key] if parsed_response[detail_key]
          end

        end
      rescue MultiJson::ParseError
      end

      error_to_raise = KeyyoError.new(error.message, error_params)
      raise error_to_raise
    end

    def configure_request(opts)
      request = opts[:request]
      if request
        request.params.merge!(opts[:params]) if opts[:params]
        request.headers['Content-Type'] = 'application/json'
        request.headers.merge!(opts[:headers]) if opts[:headers]
        request.body = opts[:body] if opts[:body]
        request.options.timeout = self.timeout
        request.options.open_timeout = self.open_timeout
      end
    end

    def rest_client
      # client = Faraday.new(self.api_url, proxy: self.proxy) do |faraday| #, ssl: { version: "TLSv1_2" }
      #   # faraday.request :digest, self.api_key, self.api_secret
      #   faraday.response :raise_error
      #   faraday.adapter faraday_adapter
      #   if @request_builder.debug
      #     faraday.response :logger, @request_builder.logger, bodies: true
      #   end
      # end
      # client.basic_auth(self.api_key, self.api_secret)
      # client
      # # puts "===========================<>>>>#{@request_builder.oauth2_token}"

      # # return Client.new(api_url: self.api_url, proxy: self.proxy, token: @request_builder.oauth2_token, faraday_adapter: faraday_adapter, logger: @request_builder.logger, ssl: { version: "TLSv1_2"}).authenticate

      @request_builder.client.options[:url] = @request_builder.api_url
      return @request_builder.client.connect
    end

    def parse_response(response)
      parsed_response = nil

      if response.body && !response.body.empty?
        begin
          headers = response.headers
          body = MultiJson.load(response.body, symbolize_keys: symbolize_keys)
          binding.pry
          parsed_response = Response.new(headers: headers, body: body)
        rescue MultiJson::ParseError
          error_params = { title: "UNPARSEABLE_RESPONSE", status_code: 500 }
          error = KeyyoError.new("Unparseable response: #{response.body}", error_params)
          raise error
        end
      end

      parsed_response
    end

    def validate_api_key
      unless self.api_key #&& (api_key["-"] || self.api_endpoint)
        raise KeyyoError, "You must set an api_key prior to making a call"
      end
    end

    # def api_url
    #   "#{@request_builder.base_api_url}#{@request_builder.path}"
    # end

    def build_http_request(http_verb, http_options)
      # validate_api_key # useless since no api_key
      begin
        response = self.rest_client.send(http_verb) do |request|
          configure_request(http_options.merge(request: request))
        end
        parse_response(response)
      rescue => e
        handle_error(e)
      end
    end

    # def get_args(method_name, method_args)
    #   method(__method__).parameters.inject({}) do |m, arg|
    #     m[arg[1].to_sym] = binding.local_variable_get(arg[1])
    #     m
    #   end
    # end

    def get_args(ext_binding)
      raise ArgumentError, "Binding expected, #{ext_binding.class.name} given" unless ext_binding.is_a?(Binding)
      method_name = ext_binding.eval("__method__")
      ext_binding.receiver.method(method_name).parameters.map do |_, name|
        [name, ext_binding.local_variable_get(name)]
      end.to_h
    end
  end
end
