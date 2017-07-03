class Leagues::JoinLeagueForm
  include ActiveModel::Model
  include ::Virtus.model

  attr_accessor :league, :current_user, :fpl_team

  def initialize(current_user:, fpl_team:)
    @current_user = current_user
    @fpl_team = fpl_team
    super
  end

  attribute :league_name, String
  attribute :code, String

  attribute :fpl_team_name, String
  attribute :user_id, Integer

  validate :league_presence
  validates :current_user, presence: true
  validates :fpl_team, presence: true
  validates :code, :league_name, :fpl_team_name, presence: true
  validate :already_joined
  validate :fpl_team_name_uniqueness
  validate :fpl_team_quota

  MAX_FPL_TEAM_QUOTA = 11

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      @fpl_team.attributes = { name: fpl_team_name, user: @current_user, league: @league }
      @fpl_team.save!
    end
  end

  private

  def already_joined
    errors.add(:base, 'You have already joined this league') if @league&.users&.include?(@current_user)
  end

  def league_presence
    @league = League.where('lower(name) = :name AND code = :code', name: league_name&.downcase, code: code).first
    errors.add(:base, 'The league name and/or code you have entered is incorrect') if @league.nil?
  end

  def fpl_team_name_uniqueness
    return if fpl_team_name.blank?
    return if fpl_team_name.downcase == @fpl_team&.name&.downcase
    if FplTeam.where('lower(name) = ?', fpl_team_name.downcase).count.positive?
      errors.add(:base, 'Fpl team name has already been taken')
    end
  end

  def fpl_team_quota
    if @league.present? && @league.fpl_teams.count >= MAX_FPL_TEAM_QUOTA
      errors.add(:base, 'Limit on fpl teams for this league has already been reached')
    end
  end
end
