
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "remote_job_scraper/version"

Gem::Specification.new do |spec|
  spec.name          = "remote_job_scraper"
  spec.version       = RemoteJobScraper::VERSION
  spec.authors       = ["Rafał Trojanowski"]
  spec.email         = ["rt.trojanowski@gmail.com"]

  spec.summary       = %q{Ruby gem that collects job offers for remote positions with ease.}
  spec.description   = %q{Going through many job listings and finding the rigth one
                          may be time consuming process. That's why this tool has been built.
                          It allows to automate the process, retrieve necessary data
                          and store it in CSV file in just a few minutes.
                          The main focus is to inform an user about the location (time-zone) required.
                       }
  spec.homepage      = "https://github.com/rafaltrojanowski/remote_job_scraper"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end
