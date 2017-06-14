import { combineReducers } from 'redux';
import TeamsReducer from './reducer_teams';
import RoundsReducer from './reducer_rounds';
import TeamReducer from './reducer_team';
import PlayersReducer from './reducer_players';
import PlayerReducer from './reducer_player';

const rootReducer = combineReducers({
  teams: TeamsReducer,
  rounds_data: RoundsReducer,
  team_data: TeamReducer,
  players: PlayersReducer,
  player_data: PlayerReducer,
});

export default rootReducer;
