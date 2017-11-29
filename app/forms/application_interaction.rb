class ApplicationInteraction < ActiveInteraction::Base
  def run_in_transaction!
    result = nil
    ActiveRecord::Base.transaction do
      result = yield
      raise ActiveRecord::Rollback if errors.any?
    end
    result
  end

  def self.run_in_transaction!
    set_callback :execute, :around, :run_in_transaction!, prepend: true
  end

  def populate_filters(inputs)
    object_filters = self.class.filters.select do |_name, filter|
      filter.is_a?(ActiveInteraction::ObjectFilter)
    end

    object_filters.each do |field, filter|
      id_field = :"#{field}_id"

      if inputs[id_field]
        if inputs.key? field
          raise ActiveInteraction::InvalidValueError, field.inspect
        else
          id = inputs.delete id_field
          inputs[field] = filter.options[:class].find id
        end
      end
    end

    super inputs
  end
end
