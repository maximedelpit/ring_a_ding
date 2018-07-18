

require 'pry-byebug'
require 'faraday'
# require 'faraday/digestauth'
require 'multi_json'
require 'cgi'
require 'logger'

require 'ring_a_ding/authentication'
require 'ring_a_ding/api_request'
require 'ring_a_ding/client'
require 'ring_a_ding/internal_error'
require 'ring_a_ding/keyyo_error'
require 'ring_a_ding/request'
require 'ring_a_ding/request/cti_request'
require 'ring_a_ding/request/manager_request'
require 'ring_a_ding/response'
require "ring_a_ding/version"
# require 'ring_a_ding/response'
# require 'ring_a_ding/export'
module RingADing
  # Your code goes here...
  # body = {"ACCOUNT" => '33180898931', "CALLEE" => '0762683337'}
  # ring = RingADing::Request.new(end_point_ext: '.html?')
  # binding.pry
  # ring.makecall.retrieve(params: body)
  # binding.pry
end
