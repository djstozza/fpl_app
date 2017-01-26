# == Schema Information
#
# Table name: player_fixture_histories
#
#  id                             :integer          not null, primary key
#  kickoff_time                   :string
#  team_h_score                   :integer
#  team_a_score                   :integer
#  was_home                       :boolean
#  round_id                       :integer
#  total_points                   :integer
#  value                          :integer
#  minutes                        :integer
#  goals_scored                   :integer
#  assists                        :integer
#  clean_sheets                   :integer
#  goals_conceded                 :integer
#  own_goals                      :integer
#  penalties_saved                :integer
#  penalties_missed               :integer
#  yellow_cards                   :integer
#  red_cards                      :integer
#  saves                          :integer
#  bonus                          :integer
#  influence                      :integer
#  creativity                     :decimal(, )
#  threat                         :decimal(, )
#  ict_index                      :decimal(, )
#  ea_index                       :decimal(, )
#  open_play_crosses              :integer
#  big_chances_created            :integer
#  clearance_blocks_interceptions :integer
#  recoveries                     :integer
#  key_passes                     :integer
#  tackles                        :integer
#  winning_goals                  :integer
#  attempted_passes               :integer
#  penalties_conceded             :integer
#  big_chances_missed             :integer
#  errors_leading_to_goal         :integer
#  errors_leading_to_goal_attempt :integer
#  tackled                        :integer
#  offside                        :integer
#  target_missed                  :integer
#  fouls                          :integer
#  dribbles                       :integer
#  player_id                      :integer
#  fixture_id                     :integer
#  oponent_team_id                :integer
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#

class PlayerFixtureHistory < ActiveRecord::Base
  belongs_to :player
  belongs_to :round
  belongs_to :fixture
end
