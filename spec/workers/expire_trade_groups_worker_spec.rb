require 'rails_helper'

RSpec.describe ExpireTradeGroupsWorker do
  it 'sets the status of all unprocessed inter team trade groups to expired' do
    pending_trade_group = FactoryBot.create(:inter_team_trade_group, status: 'pending')
    submitted_trade_group = FactoryBot.create(:inter_team_trade_group, status: 'submitted')
    approved_trade_group =  FactoryBot.create(:inter_team_trade_group, status: 'approved')
    declined_trade_group = FactoryBot.create(:inter_team_trade_group, status: 'declined')

    described_class.new.perform

    expect(pending_trade_group.reload).to be_expired
    expect(submitted_trade_group.reload).to be_expired
    expect(approved_trade_group.reload).to be_approved
    expect(declined_trade_group.reload).to be_declined
  end
end
