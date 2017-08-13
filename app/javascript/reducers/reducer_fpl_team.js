import { FETCH_FPL_TEAMS, FETCH_FPL_TEAM } from '../actions/types';

export default function(state=[], action) {
  switch (action.type) {
    case FETCH_FPL_TEAMS:
      return action.payload;
    case FETCH_FPL_TEAM:
      return action.payload;

    default:
      return state;
  }
}
