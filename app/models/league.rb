# == Schema Information
#
# Table name: leagues
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  active          :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  commissioner_id :integer
#

class League < ApplicationRecord
  belongs_to :commissioner, class_name: 'User', foreign_key: 'commissioner_id'
  has_many :users, through: :fpl_teams
end
