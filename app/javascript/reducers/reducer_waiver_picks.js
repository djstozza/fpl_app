import {
  FETCH_WAIVER_PICKS,
  CREATE_WAIVER_PICK,
  UPDATE_WAIVER_PICK_ORDER,
  DELETE_WAIVER_PICK,
  SHOW_ERRORS
} from '../actions/types';

export default function(state=[], action) {
  switch (action.type) {
    case FETCH_WAIVER_PICKS:
      return action.payload;
    case CREATE_WAIVER_PICK:
      return action.payload;
    case UPDATE_WAIVER_PICK_ORDER:
      return action.payload;
    case DELETE_WAIVER_PICK:
      return action.payload;
    case SHOW_ERRORS:
      return action.payload;

    default:
      return state;
  }
}
