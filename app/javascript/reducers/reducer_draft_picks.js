import { FETCH_DRAFT_PICKS } from '../actions/types';

export default function(state=[], action) {
  switch (action.type) {
    case FETCH_DRAFT_PICKS:
      return action.payload

    default:
      return state;
  }
}
