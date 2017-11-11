import { FETCH_MINI_DRAFT_PICKS, CREATE_MINI_DRAFT_PICK, PASS_MINI_DRAFT_PICK, SHOW_ERRORS } from '../actions/types';

export default function(state=[], action) {
  switch (action.type) {
    case FETCH_MINI_DRAFT_PICKS:
      return action.payload;
    case CREATE_MINI_DRAFT_PICK:
      return action.payload;
    case PASS_MINI_DRAFT_PICK:
      return action.payload;
    case SHOW_ERRORS:
      return action.payload;

    default:
      return state;
  }
}
