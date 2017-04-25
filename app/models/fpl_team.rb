# == Schema Information
#
# Table name: fpl_teams
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  users_id    :integer
#  leagues_id  :integer
#  total_score :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class FplTeam < ApplicationRecord
  has_and_belongs_to_many :players
end
