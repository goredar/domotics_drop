require 'socket'

class Domo
  RUBY_HASH_REGEXP = /\A([a-z]\w*: (\d+|:\w+|'(\/\w+)+')(, )?)+\Z/
  RUBY_CLASS_REGEXP = /\A[A-Z]+\w*(::)?[A-Z]+\w*\Z/
  RUBY_NAME_REGEXP = /\A[a-z]\w*\Z/
  WORDS_REGEXP = /\A[\w ]+\Z/
  VIEW_FIELDS = [:name, :class_name, :element_type_id, :room_id, :device_id,
                 :room_type_id, :device_type_id, :options, :description]
  GDS_ADDR = 'localhost'
  GDS_PORT = '50002'
  cattr_accessor :gds_node
  def gds_req(request)
    @@gds_node = TCPSocket.open(GDS_ADDR, GDS_PORT) if !@@gds_node
    socket.puts request
    socket.gets
  end
end