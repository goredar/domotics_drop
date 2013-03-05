require 'socket'

class Domo
  RUBY_HASH_REGEXP = /\A([a-z]\w*: (\d+|:\w+|'(\/\w+)+')(, )?)+\Z/
  RUBY_CLASS_REGEXP = /\A[A-Z]+\w*(::)?[A-Z]+\w*\Z/
  RUBY_NAME_REGEXP = /\A[a-z]\w*\Z/
  WORDS_REGEXP = /\A[\w ]+\Z/
  VIEW_FIELDS = [:name, :class_name, :element_type_id, :room_id, :device_id,
                 :room_type_id, :device_type_id, :options, :description]
  GDS_ADDR = '127.0.0.1'
  GDS_PORT = '50002'
  @@gds_node = nil
  def self.gds_req(request)
    @@gds_node = TCPSocket.open(GDS_ADDR, GDS_PORT) if !@@gds_node
    gds_node.puts request
    raise ArgumentError if !reply = gds_node.gets
    reply
  rescue ArgumentError, Errno::EPIPE
    @@gds_node.close
    @@gds_node = nil
    retry
  rescue Errno::ECONNREFUSED
    return { status: :fail }
  end
end