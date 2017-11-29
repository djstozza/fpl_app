import { NEW_INTER_TEAM_TRADE_GROUP } from '../types';
import axios from 'axios';

export default function newInterTeamTradeGroup (fplTeamId, fplTeamListId) {
  return dispatch => {
    axios.get(`/fpl_teams/${fplTeamId}/fpl_team_lists/${fplTeamListId}/inter_team_trade_groups/new.json`)
      .then(res => {
        dispatch(newInterTeamTradeGroupAsync(res.data));
      });
  }
}

function newInterTeamTradeGroupAsync (data) {
  return {
    type: NEW_INTER_TEAM_TRADE_GROUP,
    payload: data
  };
}
