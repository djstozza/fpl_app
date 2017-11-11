class RoundsDecorator < SimpleDelegator
  def all_data
    order(:id).pluck_to_hash(
      :id,
      :name,
      :finished,
      :deadline_time_epoch,
      :deadline_time_game_offset,
      :is_current,
      :deadline_time,
      :is_previous,
      :is_next
    )
  end
end
