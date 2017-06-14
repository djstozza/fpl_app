class Leagues::ProcessLeagueForm
  include ActiveModel::Model
  include ::Virtus.model

  attr_accessor :league, :current_user, :fpl_team

  def initialize(league:, current_user:, fpl_team:)
    @league = league
    @current_user = current_user
    @fpl_team = fpl_team
    super
  end

  attribute :league_name, String
  attribute :code, String
  attribute :commissioner_id, Integer

  attribute :fpl_team_name, String
  attribute :user_id, Integer
  attribute :league_id, Integer

  validates :current_user, presence: true
  validates :league, presence: true
  validates :fpl_team, presence: true

  validates :code, :league_name, :fpl_team_name, presence: true
  validate :league_name_uniqueness
  validate :fpl_team_name_uniqueness
  validate :user_is_commissioner

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      @league.attributes = { name: league_name, code: code, commissioner: @current_user }
      @league.save!
      @fpl_team.attributes = { name: fpl_team_name, user: @current_user, league: @league }
      @fpl_team.save!
    end
  end

  def update
    return false unless valid?
    ActiveRecord::Base.transaction do
      @league.update!(name: league_name, code: code)
      @fpl_team.update!(name: fpl_team_name, user: @current_user, league: @league)
    end
  end

  private

  def user_is_commissioner
    if @league&.commissioner && @league.commissioner != @current_user
      errors.add(:base, 'You are not authorised to make changes to this league')
    end
  end

  def league_name_uniqueness
    return if league_name.blank?
    return if league_name.downcase == @league&.name&.downcase
    if League.where('lower(name) = ?', league_name.downcase).count.positive?
      errors.add(:base, 'League name has already been taken')
    end
  end

  def fpl_team_name_uniqueness
    return if fpl_team_name.blank?
    return if fpl_team_name.downcase == @fpl_team&.name&.downcase
    if FplTeam.where('lower(name) = ?', fpl_team_name.downcase).count.positive?
      errors.add(:base, 'Fpl team name has already been taken')
    end
  end
end
