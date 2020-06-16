
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "malloc_trim/version"

Gem::Specification.new do |spec|
  spec.name          = "malloc_trim"
  spec.version       = MallocTrim::VERSION
  spec.authors       = ["Philipp Tessenow"]
  spec.email         = ["philipp@tessenow.org"]

  spec.summary       = %q{Gives some memory held by a ruby process back to the OS}
  spec.description   = %q{There is currently a proposal for the ruby language to call malloc_trim(0) on GC runs to more efficiently give memory back to the operating system. This is a gem giving access to malloc_trim to ruby land to ease testing.}
  spec.homepage      = "https://github.com/tessi/malloc_trim"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/malloc_trim/extconf.rb"]

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rake-compiler"
  spec.add_development_dependency "rspec", "~> 3.0"
end
