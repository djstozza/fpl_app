# == Schema Information
#
# Table name: player_past_histories
#
#  id               :integer          not null, primary key
#  season_name      :string
#  player_code      :integer
#  start_cost       :integer
#  end_cost         :integer
#  total_points     :integer
#  minutes          :integer
#  goals_scored     :integer
#  assists          :integer
#  clean_sheets     :integer
#  goals_conceded   :integer
#  own_goals        :integer
#  penalties_saved  :integer
#  penalties_missed :integer
#  yellow_cards     :integer
#  red_cards        :integer
#  saves            :integer
#  bonus            :integer
#  bps              :integer
#  influence        :decimal(, )
#  creativity       :decimal(, )
#  threat           :decimal(, )
#  ict_index        :decimal(, )
#  ea_index         :integer
#  season           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class PlayerPastHistory < ActiveRecord::Base
  belongs_to :player
end
