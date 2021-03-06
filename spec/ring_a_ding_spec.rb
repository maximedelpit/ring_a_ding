RSpec.describe RingADing do
  it "has a version number" do
    expect(RingADing::VERSION).not_to be nil
  end
end

# Test attributes default value & affectation
RSpec.describe "Request attributes" do
  # let(:ring_a_ding) { RingADing::Request.new }
  # let(:fake_attr) {'fake_attr'}
  # attrs = [:api_key, :api_secret, :api_endpoint, :timeout, :open_timeout, :proxy, :faraday_adapter, :symbolize_keys, :debug, :logger]

  # [:api_key, :api_secret, :proxy, :api_endpoint, :logger].each do |_attr|
  #   it "has not #{_attr} by default" do
  #     expect(ring_a_ding.send(_attr)).to be_nil
  #   end

  #   break if _attr == :api_endpoint

  #   it "sets #{_attr} from the 'KEYYO_#{_attr.upcase}' ENV variable" do
  #     ENV["KEYYO_#{_attr.upcase}"] = fake_attr
  #     expect(ring_a_ding.send(_attr)).to eq fake_attr
  #   end
  # end

  # attrs.each do |_attr|
  #   it "sets #{_attr} in the constructor" do
  #     rgadg = RingADing::Request.new({:"#{_attr}" => fake_attr})
  #     expect rgadg.send(fake_attr).to eq fake_attr
  #   end
  #   it "sets #{_attr} via setter" do
  #     ring_a_ding.send("#{_attr}=", fake_attr)
  #     expect(ring_a_ding.send(_attr)).to eq fake_attr
  #   end
  # end

  # [:symbolize_keys, :debug].each do |_attr|
  #   it "#{_attr} false by default" do
  #     expect(ring_a_ding.send(_attr)).to be false
  #   end
  # end

  # it "is a Logger instance by default" do
  #   logger = double(:logger)
  #   expect(ring_a_ding.logger).to be_a Logger
  # end

  # it 'is a quick & dirty test' do
  #   api_key = 'xxx'
  #   api_secret = 'xxx'
  #   proxy = 'xxx'
  #   client = RingADing::Client.new(auth_type: 'digest', api_key: api_key, api_secret: api_secret)
  #   ring_a_ding = RingADing::CtiRequest.new(client)
  #   csi = "xxx"
  #   binding.pry
  #   ring_a_ding.sendsms.retrieve(params: {ACCOUNT: csi, CALLEE: 'xxx', MSG: 'Test ok man?'})
  # end
end
