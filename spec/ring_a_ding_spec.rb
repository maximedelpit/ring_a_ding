# @api_key = '5b0ec5859a780'
# @api_secret = 'bce706308b4160f1e86d1a85'
RSpec.describe RingADing do
  it "has a version number" do
    expect(RingADing::VERSION).not_to be nil
  end
end

# Test attributes default value & affectation
RSpec.describe "Request attributes" do
  let(:ring_a_ding) { RingADing::Request.new }
  let(:fake_attr) {'fake_attr'}
  attrs = [:api_key, :api_secret, :api_endpoint, :timeout, :open_timeout, :proxy, :faraday_adapter, :symbolize_keys, :debug, :logger]

  [:api_key, :api_secret, :proxy, :api_endpoint, :logger].each do |_attr|
    it "has not #{_attr} by default" do
      expect(ring_a_ding.send(_attr)).to be_nil
    end

    break if _attr == :api_endpoint

    it "sets #{_attr} from the 'KEYYO_#{_attr.upcase}' ENV variable" do
      ENV["KEYYO_#{_attr.upcase}"] = fake_attr
      expect(ring_a_ding.send(_attr)).to eq fake_attr
    end
  end

  attrs.each do |_attr|
    it "sets #{_attr} in the constructor" do
      rgadg = RingADing::Request.new({:"#{_attr}" => fake_attr})
      expect rgadg.send(fake_attr).to eq fake_attr
    end
    it "sets #{_attr} via setter" do
      ring_a_ding.send("#{_attr}=", fake_attr)
      expect(ring_a_ding.send(_attr)).to eq fake_attr
    end
  end

  [:symbolize_keys, :debug].each do |_attr|
    it "#{_attr} false by default" do
      expect(ring_a_ding.send(_attr)).to be false
    end
  end

  it "is a Logger instance by default" do
    logger = double(:logger)
    expect(ring_a_ding.logger).to be_a Logger
  end

  it 'is shit' do
    RingADing::Client.new(auth_type: 2)
    ring_a_ding.api_key = '33180898930'
    ring_a_ding.api_secret = 'UHYGo359zb'
    # ring_a_ding.end_point_ext = '.html'
    ring_a_ding.proxy = 'keyyo.net'
    csi = "33180898930"
    binding.pry
    ring_a_ding.sendsms.create(params: {ACCOUNT: csi, CALLEE: '0762683337', MSG: 'Test'})
  end

  # when 'User has authorization token' do
  #   let(:token_raw_infos) {
  #     {"token"=>
  #       "TY5dS4RAGIX/isxtwjruqGPQhdW6uFkk20KWMUw6ui+5MzLjRxH994YI6u7hHM7HJ2r4yNE5eq5Q8OqJOqBBzCPqVci1SkTDMPjBdup7xutaGOP8Y6YFb5iS/YczKxjYoFULvTCMNyeQTj3CLxmhZ6gFG7gxi9LNX9DW42CN6ZqGPnEJpp7n+naxnsyoTkJbX9rBF+QiA53k46SFPXy7OVxllyHEvDTwGMaZzu9pNhfX7THoD09xKnEH5GxK96Ra7WiKE9gkQMCHclHvzcP27pgX+X7Q2JfzdrmpVplPy7euhGg3KpIUF+jrGw==",
  #      "refresh_token"=>"e09f3588773a51c16ad517959080b4228c681a51",
  #      "expires_at"=>1531838624,
  #      "expires_in"=>3600}
  #   }
  #   let(:token) {token_raw_infos['token']}
  #   let(:refresh_token) {token_raw_infos['refresh_token']}
  #   it "generate a csi token" do
  #     # ring_a_ding.api_key = '5b0ec5859a780'
  #     # ring_a_ding.api_secret = 'bce706308b4160f1e86d1a85'
  #     # csi = "33180898930"
  #     # ring_a_ding.base_api_url = "https://api.keyyo.com/manager/1.0/"

  #     binding.pry
  #     # ring_a_ding#.services(csi)
  #     #  ring_a_ding.sendsms(params: {ACCOUNT: csi, CALLEE: '0762683337', MSG: 'Test'}).create
  #   end
  # end
end





