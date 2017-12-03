require 'sidekiq'

class RecurringExpireTradeGroupsWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
    deadline_time = Round.current_round.deadline_time
    return if Time.now.to_date != deadline_time.to_date
    ::ExpireTradeGroupsWorker.perform_at(deadline_time)
  end
end
