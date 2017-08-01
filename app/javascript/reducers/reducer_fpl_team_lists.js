import { FETCH_FPL_TEAM_LISTS, UPDATE_FPL_TEAM_LIST } from '../actions/types';

export default function(state=[], action) {
  switch (action.type) {
    case FETCH_FPL_TEAM_LISTS:
      return action.payload
    case UPDATE_FPL_TEAM_LIST:
      return action.payload

    default:
      return state;
  }
}
