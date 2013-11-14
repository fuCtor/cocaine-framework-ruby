require 'cocaine/future'

class Cocaine::ChannelZipper
  def initialize(channel)
    channel = channel
    channel.callback { |result|
      @callback.call Cocaine::Future.value result if @callback
    }
    channel.errback { |err|
      @callback.call Cocaine::Future.error err if @callback
    }
  end

  def callback(&block)
    @callback = block
  end
end