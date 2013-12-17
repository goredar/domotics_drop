require 'mongo'

module Domotics
  class DataMongo
    def initialize(args = {})
      @mongo = Mongo::MongoClient.new(args[:host] || "127.0.0.1", args[:port] || 27017).db("domotics")
    end

    def [](obj)
      case obj
      when Element
        DataMongoOperator.new @mongo.collection(obj.room.name.to_s), obj.name.to_s
      end
    end
  end

  class DataMongoOperator
    def initialize(coll, element)
      @coll = coll
      @element = element
    end

    def method_missing(symbol, *args)
      # Setter method [*=(value)]
      if symbol.to_s =~ /.*=\Z/ and args.size == 1
        if el = @coll.find_one("element" => @element)
          @coll.update({ "_id" => el["_id"] }, { "element" => @element, symbol.to_s[0..-2] => args[0] })
        else
          @coll.insert("element" => @element, symbol.to_s[0..-2] => args[0])
        end
        # Getter method (no arguments allowed)
      elsif args.size == 0
        result = @coll.find_one("element" => @element)
        result && result[symbol.to_s]
      else
        nil
      end
    end
  end
end