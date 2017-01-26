# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170125231650) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fixtures", force: :cascade do |t|
    t.string   "kickoff_time"
    t.string   "deadline_time"
    t.integer  "team_h_difficulty"
    t.integer  "team_a_difficulty"
    t.integer  "code"
    t.integer  "team_h_score"
    t.integer  "team_a_score"
    t.integer  "round_id"
    t.integer  "minutes"
    t.integer  "team_a_id"
    t.integer  "team_h_id"
    t.boolean  "started"
    t.boolean  "finished"
    t.boolean  "provisional_start_time"
    t.boolean  "finished_provisional"
    t.integer  "round_day"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "player_fixture_histories", force: :cascade do |t|
    t.string   "kickoff_time"
    t.integer  "team_h_score"
    t.integer  "team_a_score"
    t.boolean  "was_home"
    t.integer  "round_id"
    t.integer  "total_points"
    t.integer  "value"
    t.integer  "minutes"
    t.integer  "goals_scored"
    t.integer  "assists"
    t.integer  "clean_sheets"
    t.integer  "goals_conceded"
    t.integer  "own_goals"
    t.integer  "penalties_saved"
    t.integer  "penalties_missed"
    t.integer  "yellow_cards"
    t.integer  "red_cards"
    t.integer  "saves"
    t.integer  "bonus"
    t.integer  "influence"
    t.decimal  "creativity"
    t.decimal  "threat"
    t.decimal  "ict_index"
    t.decimal  "ea_index"
    t.integer  "open_play_crosses"
    t.integer  "big_chances_created"
    t.integer  "clearances_blocks_interceptions"
    t.integer  "recoveries"
    t.integer  "key_passes"
    t.integer  "tackles"
    t.integer  "winning_goals"
    t.integer  "attempted_passes"
    t.integer  "penalties_conceded"
    t.integer  "big_chances_missed"
    t.integer  "errors_leading_to_goal"
    t.integer  "errors_leading_to_goal_attempt"
    t.integer  "tackled"
    t.integer  "offside"
    t.integer  "target_missed"
    t.integer  "fouls"
    t.integer  "dribbles"
    t.integer  "player_id"
    t.integer  "fixture_id"
    t.integer  "opponent_team_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "players", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "squad_number"
    t.integer  "team_code"
    t.string   "photo"
    t.string   "web_name"
    t.string   "status"
    t.integer  "code"
    t.string   "news"
    t.integer  "now_cost"
    t.integer  "chance_of_playing_this_round"
    t.integer  "chance_of_playing_next_round"
    t.decimal  "value_form"
    t.decimal  "value_season"
    t.integer  "cost_change_start"
    t.integer  "cost_change_event"
    t.integer  "cost_change_start_fall"
    t.integer  "cost_change_event_fall"
    t.boolean  "in_dreamteam"
    t.integer  "dreamteam_count"
    t.decimal  "selected_by_percent"
    t.decimal  "form"
    t.integer  "transfers_out"
    t.integer  "transfers_in"
    t.integer  "transfers_out_event"
    t.integer  "transfers_in_event"
    t.integer  "loans_in"
    t.integer  "loans_out"
    t.integer  "loaned_in"
    t.integer  "loaned_out"
    t.integer  "total_points"
    t.integer  "event_points"
    t.decimal  "points_per_game"
    t.decimal  "ep_this"
    t.decimal  "ep_next"
    t.boolean  "special"
    t.integer  "minutes"
    t.integer  "goals_scored"
    t.integer  "assists"
    t.integer  "clean_sheets"
    t.integer  "goals_conceded"
    t.integer  "own_goals"
    t.integer  "penalties_saved"
    t.integer  "penalties_missed"
    t.integer  "yellow_cards"
    t.integer  "red_cards"
    t.integer  "saves"
    t.integer  "bonus"
    t.integer  "bps"
    t.decimal  "influence"
    t.decimal  "creativity"
    t.decimal  "threat"
    t.decimal  "ict_index"
    t.integer  "ea_index"
    t.integer  "position_id"
    t.integer  "team_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "positions", force: :cascade do |t|
    t.string   "singular_name"
    t.string   "singular_name_short"
    t.string   "plural_name"
    t.string   "plural_name_short"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "rounds", force: :cascade do |t|
    t.string   "name"
    t.string   "deadline_time"
    t.boolean  "finished"
    t.boolean  "data_checked"
    t.integer  "deadline_time_epoch"
    t.integer  "deadline_time_game_offset"
    t.boolean  "is_previous"
    t.boolean  "is_current"
    t.boolean  "is_next"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.string   "short_name"
    t.integer  "strength"
    t.integer  "position"
    t.integer  "played"
    t.integer  "win"
    t.integer  "loss"
    t.integer  "draw"
    t.integer  "points"
    t.integer  "form"
    t.integer  "link_url"
    t.integer  "strength_overall_home"
    t.integer  "strength_overall_away"
    t.integer  "strength_attack_home"
    t.integer  "strength_attack_away"
    t.integer  "strength_defence_home"
    t.integer  "strength_defence_away"
    t.integer  "team_division"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

end
