class Leagues::UpdateDraftPickForm
  include ActiveModel::Model
  include ::Virtus.model

  attr_accessor :league, :current_user, :player, :draft_pick, :fpl_team

  def initialize(league:, current_user:, player:, draft_pick:)
    @league = league
    @fpl_team = current_user.fpl_teams.find_by(league_id: @league.id)
    @player = player
    @draft_pick = draft_pick
  end

  validates :player, :fpl_team, :draft_pick, :league, presence: true
  validate :pick_number_order
  validate :fpl_team_turn
  validate :maximum_number_of_players_from_team
  validate :maximum_number_of_players_by_position
  validate :player_draft_pick_uniqueness

  QUOTAS = {
    team: 3,
    goalkeepers: 2,
    midfielders: 5,
    defenders: 5,
    forwards: 3
  }.freeze

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      @draft_pick.update!(player: @player)
      @league.players << @player
      @fpl_team.players << @player

      picked_players = PlayersDecorator.new(@league.players).all_data
      ActionCable.server.broadcast("draft_picks_league #{@league.id}", {
        draft_picks: @league.draft_picks,
        current_draft_pick: @league.draft_picks.order(:pick_number).where(player: nil).first,
        unpicked_players: PlayersDecorator.new(Player.all).all_data - picked_players,
        picked_players: picked_players
      })
    end
    true
  end

  private

  def fpl_team_turn
    return if @draft_pick.fpl_team == @fpl_team
    errors.add(:base, 'You cannot pick out of turn.')
  end

  def maximum_number_of_players_from_team
    return if @fpl_team.teams.empty?
    return if @fpl_team.players.where(team: @player.team).count < QUOTAS[:team]
    errors.add(:base, "You can't have more than #{QUOTAS[:team]} players from the same team.")
  end

  def maximum_number_of_players_by_position
    position = @player.position
    position_player_number = @fpl_team.players.where(position: @player.position).count
    return if position_player_number.nil?
    plural_name = position.plural_name

    quota = QUOTAS[plural_name.downcase.to_sym]
    return if position_player_number < quota
    errors.add(:base, "You can't have more than #{quota} #{plural_name} in your team.")
  end

  def pick_number_order
    return if @league.draft_picks.where(player: nil).order(:pick_number).first == @draft_pick
    errors.add(:base, 'You cannot pick out of turn.')
  end

  def player_draft_pick_uniqueness
    errors.add(:base, 'This player has already been picked.') if @league.players.include?(@player)
  end
end
