
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ring_a_ding/version"

Gem::Specification.new do |spec|
  spec.name          = "ring_a_ding"
  spec.version       = RingADing::VERSION
  spec.authors       = ["Maxime Delpit"]
  spec.email         = ["maximedelpit@gmail.com"]

  spec.summary       = %q{Ring A Ding is an API wrapper for Keyyo's API: https://www.keyyo.com/fr/telephonie-api}
  spec.description   = spec.summary
  spec.homepage      = "http://github.com/maximedelpit/ring_a_ding"
  spec.license       = "MIT"

  spec.rubyforge_project = "ring_a_ding"

  # # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.3.0'

  spec.add_dependency('faraday', '>= 0.11')
  # spec.add_dependency('faraday-digestauth', '>= 0.3')
  spec.add_dependency('multi_json', '>= 1.11.0')
  # spec.add_dependency 'oauth2', '~> 1.4'
  # spec.add_dependency 'omniauth-keyyo', '>= 0.1.0'


  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry-byebug"
end
