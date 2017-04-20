# == Schema Information
#
# Table name: rounds
#
#  id                        :integer          not null, primary key
#  name                      :string
#  finished                  :boolean
#  data_checked              :boolean
#  deadline_time_epoch       :integer
#  deadline_time_game_offset :integer
#  is_previous               :boolean
#  is_current                :boolean
#  is_next                   :boolean
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  deadline_time             :datetime
#

class Round < ApplicationRecord
  has_many :fixtures
  has_many :player_fixture_histories

  scope :current, -> { find_by(is_current: true) }
end
