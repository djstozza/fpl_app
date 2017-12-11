import { FETCH_CURRENT_ROUND } from '../actions/types';

export default function(state=[], action) {
  switch (action.type) {
    case FETCH_CURRENT_ROUND:
      return action.payload

    default:
      return state;
  }
}
