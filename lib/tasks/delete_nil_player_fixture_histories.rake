desc 'Remove player fixture histories for inactive players'

namespace :data_deletion do
  task remove_nil_player_fixture_histories: :environment do
    PlayerFixtureHistory.where(minutes: 0).delete_all
  end
end
