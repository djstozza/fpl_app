require 'rails_helper'

RSpec.describe Round, type: :model do
  context '#current_round' do
    it 'when first round is current but not data checked' do
      FactoryGirl.create(:round, is_current: true)
      FactoryGirl.create(:round, is_current: false, is_next: true)
      FactoryGirl.create(:round, is_current: false)
      expect(Round.current_round).to eq(Round.first)
    end

    it 'when first round is current but is data checked' do
      FactoryGirl.create(:round, is_current: true, data_checked: true)
      FactoryGirl.create(:round, is_next: true)
      FactoryGirl.create(:round)
      expect(Round.current_round).to eq(Round.second)
    end

    it 'when last round is current and data checked with no next round' do
      FactoryGirl.create(:round, is_current: false)
      FactoryGirl.create(:round, is_current: false, is_previous: true, data_checked: true)
      FactoryGirl.create(:round, is_current: true, data_checked: true)
      expect(Round.current_round).to eq(Round.last)
    end

    it 'when there is no current round and only a next round' do
      FactoryGirl.create(:round, is_current: false, is_next: true)
      FactoryGirl.create(:round, is_current: false)
      expect(Round.current_round).to eq(Round.first)
    end
  end

  context '#current_round_status' do
    it 'when current round is the first and it is > 1 day before the deadline time' do
      FactoryGirl.create(:round, is_current: true, deadline_time: 2.days.from_now)
      expect(Round.current_round_status).to eq('trade')
    end

    it 'when current round is the first and the is < 1 day before the deadline time' do
      FactoryGirl.create(:round, is_current: true, deadline_time: 23.hours.from_now)
      expect(Round.current_round_status).to eq('trade')
    end

    it 'when current round is the first and it is after deadline time' do
      FactoryGirl.create(:round, is_current: true, deadline_time: 1.second.ago)
      expect(Round.current_round_status).to be_blank
    end

    it 'when current round is not the first round and it is > 1.day before the deadline time' do
      FactoryGirl.create(:round, is_current: false, is_previous: true)
      FactoryGirl.create(:round, is_current: true, deadline_time: 2.days.from_now)
      expect(Round.current_round_status).to eq('waiver')
    end

    it 'when current round is not the first round and it is > 1.day before the deadline time' do
      FactoryGirl.create(:round, is_current: false, is_previous: true)
      FactoryGirl.create(:round, is_current: true, deadline_time: 23.hours.from_now)
      expect(Round.current_round_status).to eq('trade')
    end

    it 'when current round is not the first round and it is > 1.day before the deadline time' do
      FactoryGirl.create(:round, is_current: false, is_previous: true)
      FactoryGirl.create(:round, is_current: true, deadline_time: 1.second.ago)
      expect(Round.current_round_status).to be_blank
    end

    it 'when current round is a mini draft round and it is before the deadline time' do
      FactoryGirl.create(:round, is_current: true, mini_draft: true, deadline_time: 1.minute.from_now)
      expect(Round.current_round_status).to eq('mini_draft')
    end

    it 'when current round is a mini draft round and it is after the deadline time' do
      FactoryGirl.create(:round, is_current: true, mini_draft: true, deadline_time: 1.second.ago)
      expect(Round.current_round_status).to be_blank
    end
  end
end
