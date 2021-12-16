module Jsonapi
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

          results.push({
            action: op.fetch(:op).to_sym,
            model: op.fetch(:ref).fetch(:type).to_sym,
            lid: data[:lid],
            attributes: data.fetch(:attributes),
            refs: refs
          })
        end
      end
    end
  end
end
