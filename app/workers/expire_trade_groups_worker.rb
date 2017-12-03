require 'sidekiq'

class ExpireTradeGroupsWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
    InterTeamTradeGroup.where.not(status: ['approved', 'declined']).update_all(status: 'expired')
  end
end
