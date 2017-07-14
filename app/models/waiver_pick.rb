# == Schema Information
#
# Table name: waiver_picks
#
#  id               :integer          not null, primary key
#  pick_number      :integer
#  status           :integer          default("pending")
#  list_position_id :integer
#  player_id        :integer
#  round_id         :integer
#  fpl_team_id      :integer
#  league_id        :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class WaiverPick < ApplicationRecord
  belongs_to :league
  belongs_to :round
  belongs_to :player
  belongs_to :fpl_team
  belongs_to :list_position
  validates :list_position_id, :status, :fpl_team_id, :player_id, :league_id, presence: true
  validates_uniqueness_of :pick_number, scope: [:fpl_team_id, :round_id]
  enum status: %w[pending approved declined]
end

# round = Round.second
# League.active.each do |league|
#   league.waiver_picks
#         .where(round: round)
#         .group_by { |pick| pick.pick_number }
#         .order(pick_number: :asc)
#         .each do |pick_group|
#     pick_group.joins(:fpl_team).order(rank: :asc).each do |pick|
#       next if league.players.include?(pick.in)
#       next if pick.fpl_team.players.include?(pick.in)
#       next unless pick.fpl_team.players.include?(pick.out)
#       next if pick.in.position != pick.out.position
#       league.players.delete(pick.out)
#       league.players << pick.in
#       pick.fpl_team.players.delete(pick.out)
#       pick.fpl_team.players << pick.in
#       pick.fpl_team
#           .fpl_team_lists
#           .find_by(round: round)
#           .list_positions
#           .find_by(player: pick.out)
#           .update(player: pick.in)
#     end
#   end
# end
