class BulkAddOperations
  attr_accessor :allowed_models, :errors

  def initialize(allowed_models = {})
    @allowed_models = allowed_models
    @errors = []
    # lids map
    @lids = {}
  end

  def execute(operations)
    ActiveRecord::Base.transaction do
      operations.each do |op|
        obj_class = allowed_models[op.model]
        if obj_class.nil?
          @errors.push "operation 'add' on model '#{op.model}' not allowed"
          break
        end

        obj = create_obj(obj_class, op.attributes, op.refs)
        obj.save
        if obj.errors.any?
          obj.errors.map { |err| @errors.push "'#{err.attribute}' #{err.message}" }
          break
        end

        @lids[op.lid] = obj if op.lid
      end
    end
  end

  def errors?
    @errors.any?
  end

  private

  def create_obj(obj_class, attr, refs)
    obj_class.new(attr).tap do |obj|
      refs.each_key do |ref_name|
        lid = @lids[refs[ref_name]]
        if lid.nil?
          @errors.push "lid #{ref_name} not found"
          break
        end

        obj["#{ref_name}_id"] = lid.id
      end
    end
  end
end
