class FplTeams::ProcessInitialLineUp < ActiveInteraction::Base
  object :fpl_team, class: FplTeam

  def execute
    ActiveRecord::Base.transaction do
      fpl_team_list = FplTeamList.create(fpl_team: fpl_team, round: Round.current_round)
      fpl_team_decorator = FplTeamDecorator.new(fpl_team)
      starting = []
      starting += fpl_team_decorator.players_by_position(position: 'forwards')
      starting += fpl_team_decorator.players_by_position(position: 'midfielders', order: 'ict_index').first(4)
      starting += fpl_team_decorator.players_by_position(position: 'defenders', order: 'ict_index').first(3)
      starting << fpl_team_decorator.players_by_position(position: 'goalkeepers', order: 'ict_index').first
      starting.each do |player|
        ListPosition.create(player: player, position: player.position, fpl_team_list: fpl_team_list, role: 'starting')
      end

      left_over_players = fpl_team_decorator.players - starting
      i = 0
      left_over_players.each do |player|
        if player.position.singular_name == 'Goalkeeper'
          ListPosition.create(
            player: player,
            position: player.position,
            fpl_team_list: fpl_team_list,
            role: 'substitute_gkp'
          )
        else
          i += 1
          ListPosition.create(
            player: player,
            position: player.position,
            fpl_team_list: fpl_team_list,
            role: "substitute_#{i}"
          )
        end
      end

      fpl_team_list.update!(active: true)
    end
  end
end
