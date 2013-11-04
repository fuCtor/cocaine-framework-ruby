require 'connection'

$log = Logger.new(STDOUT)
$log.level = Logger::DEBUG


class Cocaine::Worker
  def initialize(options={})
    options = {endpoint: ''}.merge(options)

    @endpoint = options[:endpoint]
  end

  def run
    $log.debug 'starting worker'
    $log.debug "connecting to the #{@endpoint}"
    EM.connect @endpoint, nil, Cocaine::Connection do |conn|
      @conn ||= conn
      # Activate health manager
      @conn.send_data [0, 0, [].to_msgpack].to_msgpack
      ## Send handshake
      ## Send heartbeat
    end
  end
end