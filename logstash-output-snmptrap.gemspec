Gem::Specification.new do |s|
  s.name          = 'logstash-output-snmptrap-v2'
  s.version       = '0.9.3'
  s.licenses      = ['Apache-2.0']
  s.summary       = 'SNMP Output for Logstash'
  s.description   = 'This gem is a logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/plugin install gemname. This gem is not a stand-alone program'
  s.homepage      = 'https://github.com/sjaek/logstash-output-snmptrap'
  s.authors       = ['Marcel Vingerling']
  s.email         = 'marcel.vingerling@gmail.com'
  s.require_paths = ['lib']

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "output" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 2.0"
  s.add_runtime_dependency "logstash-codec-plain"
  s.add_development_dependency "logstash-devutils"
end
