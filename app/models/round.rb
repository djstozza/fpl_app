# == Schema Information
#
# Table name: rounds
#
#  id                        :integer          not null, primary key
#  name                      :string
#  deadline_time             :datetime
#  finished                  :boolean
#  data_checked              :boolean
#  deadline_time_epoch       :integer
#  deadline_time_game_offset :integer
#  is_previous               :boolean
#  is_current                :boolean
#  is_next                   :boolean
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  mini_draft                :boolean
#

class Round < ApplicationRecord
  has_many :fixtures

  SUMMER_MINI_DRAFT_DEADLINE = Time.parse("01/09/#{Time.now.year}")
  WINTER_MINI_DRAFT_DEALINE = Time.parse("01/02/#{1.year.from_now.year}")

  class << self
    def current_round
      round =
        if where(is_current: true).empty?
          find_by(is_next: true)
        elsif find_by(is_current: true).data_checked
          find_by(is_next: true) || find_by(is_current: true)
        else
          find_by(is_current: true)
        end
      RoundDecorator.new(round)
    end

    def round_status(round: Round.current_round)
      if round.mini_draft && Time.now < round.deadline_time - 1.day
        'mini_draft'
      elsif Time.now < round.deadline_time - 1.day && round.id != Round.first.id
        'waiver'
      elsif Time.now < round.deadline_time
        'trade'
      end
    end

    def deadline
      round = current_round
      status = round_status(round: round)
      if status == 'mini_draft' || status == 'waiver'
        round.deadline_time - 1.day
      elsif status == 'trade'
        round.deadline_time
      end
    end
  end
end
