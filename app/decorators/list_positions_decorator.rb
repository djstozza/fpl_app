class ListPositionsDecorator < SimpleDelegator
  def list_position_arr
    order(role: :asc, position_id: :desc)
      .joins(:player)
      .joins(:position)
      .joins(:fpl_team_list)
      .joins('JOIN rounds ON rounds.id = fpl_team_lists.round_id')
      .joins('JOIN fixtures ON fixtures.round_id = rounds.id')
      .joins('JOIN teams ON teams.id = players.team_id')
      .joins(
        'JOIN teams AS opponents ON ' \
        '(fixtures.team_h_id = opponents.id AND fixtures.team_a_id = teams.id) OR ' \
        '(fixtures.team_a_id = opponents.id AND fixtures.team_h_id = teams.id)'
      ).pluck_to_hash(
        :id,
        :player_id,
        :role,
        :last_name,
        :position_id,
        :singular_name_short,
        :team_id,
        'teams.short_name AS team_short_name',
        :status,
        :total_points,
        :player_fixture_histories,
        :event_points,
        :fpl_team_list_id,
        :team_h_id,
        :team_a_id,
        'fpl_team_lists.round_id AS fpl_team_list_round_id',
        'opponents.short_name AS opponent_short_name',
        '(team_h_difficulty - team_a_difficulty) AS difficulty'
      ).map do |hash|
        difficulty = hash['team_h_id'] == hash['team_id'] ? hash['difficulty'] * -1 : hash['difficulty']
        difficulty_type =
          if difficulty < 0
            'o'
          elsif difficulty == 0
            'e'
          else
            't'
          end
        hash[:difficulty_class] = "difficulty-#{difficulty_type}#{difficulty.abs unless difficulty == 0}"
        hash
      end
  end
end
