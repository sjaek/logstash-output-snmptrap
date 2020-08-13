# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"

# An example output that does nothing.
class LogStash::Outputs::Snmptrap < LogStash::Outputs::Base
  config_name "snmptrap"

  default :codec, "line"

  #address of the host to send the trap/notification to
  config :host, :validate => :string, :default => "127.0.0.1"

  #the port to send the trap on
  config :port, :validate => :number, :default => 162

  #the community string to include
  config :community, :validate => :string, :default => "public"

  #the OID that specifies the event generating the trap message
  config :oid, :validate => :string, :required => true

  # varbind configuration
  config :varbinds, :default => {"@oid" => "!event.to_s"}

  def initialize(*args)
    super(*args)
  end

  public
  def register
    require "snmp"

    @codec.on_event do |event|

      #set some variables for the trap sender
      trapsender_opts = {:trap_port => @port, :host => @host, :community => @community }

      #prep and do the full send
      SNMP::Manager.open(trapsender_opts) do |snmp|
        #set it up and send the whole event using the user specified codec
        varbinds = []
        @varbinds.each do |key, value|
          if value.start_with?("!") 
            value.delete_prefix!("!")
            value = eval(value)
          elsif value.start_with?("@") 
            value.delete_prefix!("@")
            value = event.get(value)
          end
          unless value.nil?
            varbinds << SNMP::VarBind.new(key, SNMP::OctetString.new(value.force_encoding('ASCII-8BIT')))
          end
        end

        #we dont actually care about the sys_up_time...do we.
        snmp.trap_v2(0, @oid, varbinds)
        end
    end
  end

  public
  def receive(event)
    return unless output?(event)
    if event == LogStash::SHUTDOWN
      finished
      return
    end
    @oid = event.sprintf(@oid)
    @codec.encode(event)
  end
end