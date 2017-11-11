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
end
