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

          parsed_response = MultiJson.load(error.response[:body], symbolize_keys: @request_builder.options[:symbolize_keys])

          if parsed_response
            error_params[:body] = parsed_response

            title_key = @request_builder.options[:symbolize_keys] ? :title : "title"
            detail_key = @request_builder.options[:symbolize_keys] ? :detail : "detail"

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
        request.options.timeout = @request_builder.client.options[:timeout]
        request.options.open_timeout = @request_builder.client.options[:open_timeout]
      end
    end

    def rest_client
      @request_builder.client.options[:url] = @request_builder.path
      return @request_builder.client.connect
    end

    def parse_json_response(response)
      parsed_response = nil
      if response.body && !response.body.empty?
        begin
          headers = response.headers
          body = MultiJson.load(response.body, symbolize_keys: @request_builder.options[:symbolize_keys])
          parsed_response = Response.new(headers: headers, body: body)
        rescue MultiJson::ParseError
          parsed_response = Response.new(headers: headers, body: response.body)
          error_params = { title: "UNPARSEABLE_JSON_RESPONSE", status_code: response.status, response_error_status_code: 500, parsed_response: parsed_response}
          error = KeyyoError.new("Unparseable JSON response: #{response.body}", error_params)
          raise error
        end
      end
      parsed_response
    end

    def parse_response(response)
      # REFACTO => To improve to correctly handle HTML errors
      if response.headers["content-type"].include?('html') && response.body == 'OK'
        return Response.new(headers: response.headers, body: response.body)
      else
        parse_json_response(response)
      end
    end

    # Refacto => needs to be reviewed
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
          http_options[:body] = MultiJson.dump(http_options[:body]) if http_options[:body]
          configure_request(http_options.merge(request: request))
        end
        parse_response(response)
      rescue => e
        handle_error(e)
      end
    end

    def get_args(ext_binding)
      raise ArgumentError, "Binding expected, #{ext_binding.class.name} given" unless ext_binding.is_a?(Binding)
      method_name = ext_binding.eval("__method__")
      ext_binding.receiver.method(method_name).parameters.map do |_, name|
        [name, ext_binding.local_variable_get(name)]
      end.to_h
    end
  end
end
