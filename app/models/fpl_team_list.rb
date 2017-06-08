# == Schema Information
#
# Table name: fpl_team_lists
#
#  id          :integer          not null, primary key
#  fpl_team_id :integer
#  round_id    :integer
#  formation   :string           default([]), is an Array
#  total_score :integer
#  rank        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class FplTeamList < ApplicationRecord
  belongs_to :round
  belongs_to :fpl_team
  has_and_belongs_to_many :players
end
