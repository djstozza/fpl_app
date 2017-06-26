import { FETCH_DRAFT_PICKS, CREATE_DRAFT_PICKS, UPDATE_DRAFT_PICK, SHOW_ERRORS } from '../actions/types';

export default function(state=[], action) {
  switch (action.type) {
    case FETCH_DRAFT_PICKS:
      return action.payload;
    case UPDATE_DRAFT_PICK:
      return action.payload;
    case CREATE_DRAFT_PICKS:
      return action.payload;
    case SHOW_ERRORS:
      return action.payload;

    default:
      return state;
  }
}
