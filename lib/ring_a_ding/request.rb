module RingADing
  class Request

    BASE_API_URL = nil
    ATTR_ACCS = %i(client base_api_url options path_parts)#api_endpoint
    SUB_SYM = '_' # used to fit method_missing undersocre with endpoint format (xxx_yyy / xxx-yyy)
    ATTR_ACCS.each {|_attr| attr_accessor _attr}
    # Hash[ATTR_ACCS.map {|v| [v, nil]}]

    # Refacto : link this to client => module ?
    def initialize(client, options={})
      @client = instantiate_client(client, options)
      @path_parts = []
      @base_api_url = options[:base_api_url] || self.class::BASE_API_URL
      @options = options
      unless @base_api_url
        raise InternalError, "Missing API Endpoint through @base_api_url"
      end
    end

    def method_missing(method, *args)
      # To support underscores, we replace them with hyphens when calling the API
      @path_parts << method.to_s.gsub("_", SUB_SYM).downcase # it seems Keyyo uses underscores
      @path_parts << args if args.length > 0
      @path_parts.flatten!
      self
    end

    def respond_to_missing?(method_name, include_private = false) #keep it here
      true
    end

    def send(*args)
      args.length == 0 ? method_missing(:send, args) : __send__(*args)
    end

    def path
      "#{@base_api_url}#{@path_parts.join('/')}"
    end

    def create(params: nil, headers: nil, body: nil)
      APIRequest.new(builder: self).post(params: params, headers: headers, body: body)
    ensure
      reset
    end

    def update(params: nil, headers: nil, body: nil)
      APIRequest.new(builder: self).patch(params: params, headers: headers, body: body)
    ensure
      reset
    end

    def upsert(params: nil, headers: nil, body: nil)
      APIRequest.new(builder: self).put(params: params, headers: headers, body: body)
    ensure
      reset
    end

    def retrieve(params: nil, headers: nil)
      APIRequest.new(builder: self).get(params: params, headers: headers)
    ensure
      reset
    end

    def delete(params: nil, headers: nil)
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
        raise InternalError, "client must be a Client or a Hash"
      end
    end
  end
end


