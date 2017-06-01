class RoundsDecorator < SimpleDelegator
  def all_data
    pluck_to_hash(:id, :name, :finished, :deadline_time_epoch, :deadline_time_game_offset, :is_current, :deadline_time)
  end
end
