# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ahoy_dashboard/version'

Gem::Specification.new do |spec|
  spec.name          = "ahoy_dashboard"
  spec.version       = AhoyDashboard::VERSION
  spec.authors       = ["Kyle Schmolze"]
  spec.email         = ["kyletns@gmail.com"]

  spec.summary       = %q{Simple dashboard interface for Ahoy a la Mixpanel, for PostgreSQL.}
  spec.homepage      = "https://www.github.com/kyleschmolze/ahoy_dashboard."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ahoy_matey"
  spec.add_dependency "activerecord"
  spec.add_dependency "haml"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
