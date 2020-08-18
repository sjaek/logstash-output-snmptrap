# Logstash Plugin

This is a plugin for [Logstash](https://github.com/elasticsearch/logstash).

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.

# Documentation #
## logstash-output-snmptrap ##

SNMP Trap v2c Output for Logstash

#Synopsis
```
input {
  http {
    port => 5000
  }
}

filter {
  mutate { 
    # Set defaults, % placeholders are evaluated as message fields.
    replace => {
      "AppDetectedTimeStamp" => "%{@timestamp}"
      "AppMsgTimeStamp" => "%{@timestamp}"
      "AppEventID" => "Grafana-%{dashboardId}-%{panelId}-%{ruleId}"
      "AppLabel" => "applabel"
      "AppEventDescription" => "%{title}\n%{ruleUrl}"
      "AppFriendlyEventDescription"=> "%{message}"
      "AppCustomerImpact" => "78"
      "AppServiceImpact" => "My Service"
      "AppEventRegion" => "My Region"
    }
  }
}

output {
  snmptrap {
    codec => "json"
    host => "snmpserver"
    port => "161"
    community => "public"
    oid => "1.3.6.1.4.1.48177.2.1.1.121"
    varbinds => {
      "1.3.6.1.4.1.48177.2.1.3.1" => "@AppEventID"
      "1.3.6.1.4.1.48177.2.1.3.2" => "@AppDetectedTimeStamp"
      "1.3.6.1.4.1.48177.2.1.3.3" => "@AppMsgTimeStamp"
      "1.3.6.1.4.1.48177.2.1.3.4" => "@AppLabel"
      "1.3.6.1.4.1.48177.2.1.3.5" => "@AppEventType"
      "1.3.6.1.4.1.48177.2.1.3.6" => "@AppEventSeverity"
      "1.3.6.1.4.1.48177.2.1.3.7" => "@AppEventDescription"
      "1.3.6.1.4.1.48177.2.1.3.8" => "@AppFriendlyEventDescription"
      "1.3.6.1.4.1.48177.2.1.3.9" => "@AppEventTag"
      "1.3.6.1.4.1.48177.2.1.3.10" => "@AppCustomerImpact"
      "1.3.6.1.4.1.48177.2.1.3.11" => "@AppServiceImpact"
      "1.3.6.1.4.1.48177.2.1.3.12" => "@AppEventRegion"
      "1.3.6.1.4.1.48177.2.1.3.13" => "!event.to_s"
      "1.3.6.1.4.1.48177.2.1.3.14" => "@AppTriggerIVR"
      "1.3.6.1.4.1.48177.2.1.3.15" => "@AppPlatformService"
    }
  }
}

```

Varbind values prefixed with `@` will retrieve the value from that field on the message, values prefixed with `!` will be evaluated as ruby in the a context of `event`, varbind `key`, varbind `value` and the `snmp` manager.

## Developing

### 1. Plugin Developement and Testing

#### Code
- To get started, you'll need JRuby with the Bundler gem installed.

- Create a new plugin or clone and existing from the GitHub [logstash-plugins](https://github.com/logstash-plugins) organization. We also provide [example plugins](https://github.com/logstash-plugins?query=example).

- Install dependencies
```sh
bundle install
```

#### Test

- Update your dependencies

```sh
bundle install
```

- Run tests

```sh
bundle exec rspec
```

### 2. Running your unpublished Plugin in Logstash

#### 2.1 Run in a local Logstash clone

- Edit Logstash `Gemfile` and add the local plugin path, for example:
```ruby
gem "logstash-output-snmptrap-v2", :path => "/your/local/logstash-output-snmptrap-v2"
```
- Install plugin
```sh
logstash-plugin install logstash-output-snmptrap-v2
```
- Run Logstash with your plugin
```sh
bin/logstash -e 'filter {awesome {}}'
```
At this point any modifications to the plugin code will be applied to this local Logstash setup. After modifying the plugin, simply rerun Logstash.

#### 2.2 Run in an installed Logstash

You can use the same **2.1** method to run your plugin in an installed Logstash by editing its `Gemfile` and pointing the `:path` to your local plugin development directory or you can build the gem and install it using:

- Build your plugin gem
```sh
gem build logstash-output-snmptrap.gemspec
```
- Install the plugin from the Logstash home
```sh
bin/plugin install /your/local/plugin/logstash-output-snmptrap.gem
```
- Start Logstash and proceed to test the plugin

## Contributing

All contributions are welcome: ideas, patches, documentation, bug reports, complaints, and even something you drew up on a napkin.

Programming is not a required skill. Whatever you've seen about open source and maintainers or community members  saying "send patches or die" - you will not see that here.

It is more important to the community that you are able to contribute.

For more information about contributing, see the [CONTRIBUTING](https://github.com/elasticsearch/logstash/blob/master/CONTRIBUTING.md) file.
