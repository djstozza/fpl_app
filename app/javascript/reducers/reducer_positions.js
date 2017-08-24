import { FETCH_POSITIONS } from '../actions/types';

export default function(state=[], action) {
  switch (action.type) {
    case FETCH_POSITIONS:
      return action.payload

    default:
      return state;
  }
}
