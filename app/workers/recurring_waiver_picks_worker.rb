require 'sidekiq'

class RecurringWaiverPicksWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
    round = Round.current_round
    return if WaiverPick.pending.where(round_id: round.id).empty?
    waiver_cutoff = round.deadline_time - 1.day
    return if Time.now.to_date != (waiver_cutoff).to_date
    ::ProcessWaiverPicksWorker.perform_at(waiver_cutoff)
  end
end
