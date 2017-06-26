import { combineReducers } from 'redux';
import TeamsReducer from './reducer_teams';
import RoundsReducer from './reducer_rounds';
import TeamReducer from './reducer_team';
import PlayersReducer from './reducer_players';
import PlayerReducer from './reducer_player';
import LeagueReducer from './reducer_league';
import DraftPicksReducer from './reducer_draft_picks';

const rootReducer = combineReducers({
  TeamsReducer: TeamsReducer,
  RoundsReducer: RoundsReducer,
  TeamReducer: TeamReducer,
  PlayersReducer: PlayersReducer,
  PlayerReducer: PlayerReducer,
  LeagueReducer: LeagueReducer,
  DraftPicksReducer: DraftPicksReducer
});

export default rootReducer;
