$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "magento_client/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name          = "magento_client"
  spec.version       = MagentoClient::VERSION
  spec.authors       = ["Nicholas Fetchak"]
  spec.email         = ["gitcommits@fetchak.com"]
  spec.summary       = "A Ruby interface to Magento's REST API"
  spec.description   = "A Ruby interface to Magento's REST API with automatic OAuth handshaking"
  spec.homepage      = "https://github.com/fetchak/magento_client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "oauth", "~> 0"
  spec.add_dependency "httparty", "~> 0"
  spec.add_dependency "http-cookie", "~> 1.0"
  spec.add_dependency "nokogiri", "~> 1.6"
  spec.add_dependency "multi_json", "~> 1"
end
