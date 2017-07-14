class TeamsDecorator < SimpleDelegator
  def all_data
    order(:id).pluck_to_hash(
      :id,
      :name,
      :short_name,
      :position,
      :played,
      :goals_for,
      :goals_against,
      :goal_difference,
      :wins,
      :losses,
      :draws,
      :clean_sheets,
      :points,
      :form
    )
  end
end
