require 'httparty'

class FixturesService
  def initialize
    @fixtures_hash = HTTParty.get('https://fantasy.premierleague.com/drf/fixtures/')
  end

  def update_fixtures
    @fixtures_hash.each do |fixture_hash|
      fixture_service =  FixtureService.new(fixture_hash: fixture_hash)
      fixture_service.update_fixture
      fixture_service.update_fixture_stats
    end
  end
end
