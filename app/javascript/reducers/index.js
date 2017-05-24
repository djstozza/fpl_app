import { combineReducers } from 'redux';
import TeamReducer from './reducer_teams';
import RoundsReducer from './reducer_rounds';

const rootReducer = combineReducers({
  teams: TeamReducer,
  rounds_data: RoundsReducer
});

export default rootReducer;
