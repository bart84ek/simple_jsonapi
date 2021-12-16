class BulkAddOperations
  attr_accessor :allowed_models, :errors

  def initialize(allowed_models = {})
    @allowed_models = allowed_models
    @errors = []
  end

  def execute(operations)
    ActiveRecord::Base.transaction do
      operations.each do |op|
        obj_class = allowed_models[op.model]
        if obj_class.nil?
          @errors.push "operation 'add' on model '#{op.model}' not allowed"
          break
        end

        obj = obj_class.new(op.attributes)
        obj.save
        if obj.errors.any?
          obj.errors.map { |err| @errors.push "'#{err.attribute}' #{err.message}" }
          break
        end
      end
    end
  end

  def errors?
    @errors.any?
  end
end
