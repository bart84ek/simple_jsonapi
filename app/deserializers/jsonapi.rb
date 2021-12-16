module Jsonapi
  class Operation
    attr_accessor :action, :model, :refs, :lid, :attributes

    def initialize(params = {})
      @lid = nil
      @refs = {}
      params.each { |key, value| send "#{key}=", value }
    end
  end

  module Deserializer
    def operations_deserializer(params)
      [].tap do |results|
        params.fetch(:operations).each do |op|
          data = op.fetch(:data)
          refs = {}
          data.fetch(:relationships, {}).each_key do |rel_name|
            rel_id = data[:relationships][rel_name].fetch(:data).fetch(:lid)
            refs[rel_name] = rel_id
          end

          o = Operation.new
          o.action = op.fetch(:op).to_sym
          o.model = op.fetch(:ref).fetch(:type).to_sym
          o.lid = data[:lid]
          o.attributes = data.fetch(:attributes)
          o.refs = refs
          results.push(o)
        end
      end
    end
  end
end
