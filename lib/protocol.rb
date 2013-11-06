require 'msgpack'

require_relative 'namespace'

module RPC
  HANDSHAKE = 0
  HEARTBEAT = 1
  TERMINATE = 2
  INVOKE = 3
  CHUNK = 4
  ERROR = 5
  CHOKE = 6
end


class Protocol
  attr_reader :id

  :protected
  def initialize(id)
    @id = id
  end

  def pack(session)
    [@id, session, data.to_msgpack].to_msgpack
  end

  :protected
  def data
    []
  end
end


class Handshake < Protocol
  def initialize(uuid)
    super RPC::HANDSHAKE
    @uuid = uuid
  end

  def data
    [@uuid]
  end

  def to_s
    "Handshake(#{@uuid})"
  end
end


class Heartbeat < Protocol
  def initialize
    super RPC::HEARTBEAT
  end

  def to_s
    'Heartbeat()'
  end
end


class Terminate < Protocol
  def initialize(errno, reason)
    super RPC::TERMINATE
    @errno = errno
    @reason = reason
  end

  :protected
  def data
    [@errno, @reason]
  end

  def to_s
    "Terminate(#{@errno}, #{@reason})"
  end
end


class Invoke < Protocol
  def initialize(event)
    super RPC::INVOKE
    @event = event
  end

  :protected
  def data
    [@event]
  end

  def to_s
    "Invoke(#{@event})"
  end
end


class Chunk < Protocol
  attr_reader :data

  def initialize(*data)
    super RPC::CHUNK
    @data = data
  end

  :protected
  def data
    @data
  end

  def to_s
    "Chunk(#{@data})"
  end
end


class Error < Protocol
  attr_reader :errno
  attr_reader :reason

  def initialize(errno, reason)
    super RPC::ERROR
    @errno = errno
    @reason = reason
  end

  :protected
  def data
    [@errno, @reason]
  end

  def to_s
    "Error(#{@errno}, #{reason})"
  end
end


class Choke < Protocol
  def initialize
    super RPC::CHOKE
  end

  def to_s
    'Choke()'
  end
end


class Cocaine::ProtocolFactory
  def self.create(id, data)
    case id
      when RPC::HEARTBEAT
        Heartbeat.new
      when RPC::CHUNK
        Chunk.new(*data)
      when RPC::ERROR
        Error.new(*data)
      when RPC::CHOKE
        Choke.new
      else
        raise "unexpected message id: #{id}"
    end
  end
end