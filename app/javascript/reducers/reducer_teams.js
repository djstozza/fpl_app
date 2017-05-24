import { FETCH_TEAMS } from '../actions/types';

export default function(state=[], action) {
  switch (action.type) {
    case FETCH_TEAMS:
      return action.payload

    default:
      return state;
  }
}
