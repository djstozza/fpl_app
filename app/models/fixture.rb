# == Schema Information
#
# Table name: fixtures
#
#  id                     :integer          not null, primary key
#  kickoff_time           :string
#  deadline_time          :string
#  team_h_difficulty      :integer
#  team_a_difficulty      :integer
#  code                   :integer
#  team_h_score           :integer
#  team_a_score           :integer
#  round_id               :integer
#  minutes                :integer
#  team_a_id              :integer
#  team_h_id              :integer
#  started                :boolean
#  finished               :boolean
#  provisional_start_time :boolean
#  finished_provisional   :boolean
#  round_day              :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Fixture < ActiveRecord::Base
  belongs_to :round
  belongs_to :team
  validates :round_id, presence: true

  scope :active, -> { where(started: true).where(finished: false) }
  scope :finished, -> { where(finished: true) }
end
