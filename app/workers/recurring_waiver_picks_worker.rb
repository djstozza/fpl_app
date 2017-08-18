require 'sidekiq'

class RecurringWaiverPicksWorker
  def perform
    round = RoundsDecorator.new(Round.all).current_round
    return if WaiverPick.pending.where(round_id: round.id).empty?
    waiver_cutoff = round.deadline_time - 2.days
    return if Time.now.to_date != (waiver_cutoff).to_date
    ::ProcessWaiverPicksWorker.perform_at(waiver_cutoff)
  end
end