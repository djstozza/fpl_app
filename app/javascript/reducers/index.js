import { combineReducers } from 'redux';
import TeamsReducer from './reducer_teams';
import RoundsReducer from './reducer_rounds';
import RoundReducer from './reducer_round';
import TeamReducer from './reducer_team';

const rootReducer = combineReducers({
  teams: TeamsReducer,
  rounds_data: RoundsReducer,
  round_data: RoundReducer,
  team_data: TeamReducer
});

export default rootReducer;
