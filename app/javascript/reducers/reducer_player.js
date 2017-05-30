import { FETCH_PLAYER } from '../actions/types';

export default function(state=[], action) {
  switch (action.type) {
    case FETCH_PLAYER:
      return action.payload

    default:
      return state;
  }
}
