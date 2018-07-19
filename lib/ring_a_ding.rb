

require 'pry-byebug'
require 'faraday'
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
require 'ring_a_ding/request/oauth_request'
require 'ring_a_ding/response'
require "ring_a_ding/version"

module RingADing
end
