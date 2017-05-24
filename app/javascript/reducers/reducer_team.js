import { FETCH_TEAM } from '../actions/types';

export default function(state=[], action) {
  switch (action.type) {
    case FETCH_TEAM:
      return action.payload

    default:
      return state;
  }
}
