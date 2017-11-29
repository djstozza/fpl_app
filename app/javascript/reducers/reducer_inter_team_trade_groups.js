import {
  INTER_TEAM_TRADE_GROUPS,
  NEW_INTER_TEAM_TRADE_GROUP,
  CREATE_INTER_TEAM_TRADE_GROUP,
  INTER_TEAM_TRADE_GROUP
} from '../actions/types';

export default function(state=[], action) {
  switch (action.type) {
    case INTER_TEAM_TRADE_GROUPS:
      return action.payload;
    case NEW_INTER_TEAM_TRADE_GROUP:
      return action.payload;
    case CREATE_INTER_TEAM_TRADE_GROUP:
      return action.payload;
    case INTER_TEAM_TRADE_GROUP:
      return action.payload;

    default:
      return state;
  }
}
