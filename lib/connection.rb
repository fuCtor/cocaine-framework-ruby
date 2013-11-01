require 'logger'
require 'eventmachine'

require_relative 'channel'
require_relative 'namespace'
require_relative 'protocol'
require_relative 'decoder'


$log = Logger.new(STDOUT)
$log.level = Logger::DEBUG


class Cocaine::Connection < EventMachine::Connection
  attr_reader :state

  def initialize(decoder=nil)
    @decoder = decoder || Cocaine::Decoder.new
    @state = :connecting

    @counter = 0
    @channels = {}
  end

  def post_init
    @state = :connected
  end

  def receive_data(data)
    @decoder.feed(data) do |id, session, message|
      msg = Cocaine::ProtocolFactory.create(id, message)
      $log.debug "received: #{msg}"
      channel = @channels[session]
      case msg.id
        when RPC::CHUNK
          channel.trigger msg.data
        when RPC::ERROR
          channel.error [msg.errno, msg.reason]
        when RPC::CHOKE
          channel.error msg
          channel.close
        else
          raise "unexpected message id: #{id}"
      end
    end
  end

  def invoke(method_id, *data)
    $log.debug("invoking #{method_id} with #{data}")
    @counter += 1
    channel = Cocaine::Channel.new
    message = MessagePack::pack([method_id, @counter, data])
    send_data message
    @channels[@counter] = channel
  end
end
