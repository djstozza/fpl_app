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

  def current_round
    round = if Round.where(is_current: true).empty?
              Round.find_by(is_next: true)
            elsif Round.find_by(is_current: true).data_checked
              Round.find_by(is_next: true) || Round.find_by(is_current: true)
            else
              Round.find_by(is_current: true)
            end
    RoundDecorator.new(round)
  end

  def current_round_status
    round = current_round
    if Time.now < round.deadline_time - 2.days && round.id != 1
      'waiver'
    elsif Time.now < round.deadline_time
      'trade'
    end
  end
end
