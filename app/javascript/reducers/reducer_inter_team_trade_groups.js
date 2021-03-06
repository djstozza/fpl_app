import {
  INTER_TEAM_TRADE_GROUPS,
  CREATE_INTER_TEAM_TRADE_GROUP,
  ADD_TO_INTER_TEAM_TRADE_GROUP,
  SUBMIT_INTER_TEAM_TRADE_GROUP,
  DELETE_INTER_TEAM_TRADE_GROUP,
  REMOVE_INTER_TEAM_TRADE,
  APPROVE_INTER_TEAM_TRADE_GROUP,
  DECLINE_INTER_TEAM_TRADE_GROUP,
  SHOW_ERRORS
} from '../actions/types';

export default function(state=[], action) {
  switch (action.type) {
    case INTER_TEAM_TRADE_GROUPS:
      return action.payload;
    case CREATE_INTER_TEAM_TRADE_GROUP:
      return action.payload;
    case ADD_TO_INTER_TEAM_TRADE_GROUP:
      return action.payload;
    case SUBMIT_INTER_TEAM_TRADE_GROUP:
      return action.payload;
    case DELETE_INTER_TEAM_TRADE_GROUP:
      return action.payload;
    case REMOVE_INTER_TEAM_TRADE:
      return action.payload;
    case APPROVE_INTER_TEAM_TRADE_GROUP:
      return action.payload;
    case DECLINE_INTER_TEAM_TRADE_GROUP:
      return action.payload;
    case SHOW_ERRORS:
      return action.payload;

    default:
      return state;
  }
}
