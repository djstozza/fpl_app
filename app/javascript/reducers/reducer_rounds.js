import { FETCH_ROUNDS } from '../actions/types';

export default function(state=[], action) {
  switch (action.type) {
    case FETCH_ROUNDS:
      return action.payload

    default:
      return state;
  }
}
