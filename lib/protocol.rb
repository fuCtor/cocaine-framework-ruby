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
end

class Chunk < Protocol
  attr_reader :data

  def initialize(data)
    super(RPC::CHUNK)
    if data.kind_of?(Array)
      data = data.join(',')
    end

    @data = MessagePack.unpack(data)
  end

  def to_s
    "Chunk(#{@data})"
  end
end

class Error < Protocol
  attr_reader :errno
  attr_reader :reason

  def initialize(data)
    super(RPC::ERROR)
    @errno, @reason = data
  end
end

class Choke < Protocol
  def initialize
    super(RPC::CHOKE)
  end

  def to_s
    'Choke()'
  end
end

class Cocaine::ProtocolFactory
  def self.create(id, data)
    case id
      when RPC::CHUNK
        Chunk.new(data)
      when RPC::ERROR
        Error.new(data)
      when RPC::CHOKE
        Choke.new
      else
        raise "unexpected message id: #{id}"
    end
  end
end