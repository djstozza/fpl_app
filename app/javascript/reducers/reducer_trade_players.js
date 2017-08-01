import { TRADE_PLAYERS, SHOW_ERRORS } from '../actions/types';

export default function(state=[], action) {
  switch (action.type) {
    case TRADE_PLAYERS:
      return action.payload;
    case SHOW_ERRORS:
      return action.payload;

    default:
      return state;
  }
}
