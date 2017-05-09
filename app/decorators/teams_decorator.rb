class TeamsDecorator < SimpleDelegator
  def ladder
    all.order(:position)
  end
end
