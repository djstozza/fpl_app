import { TRADE_PLAYERS, SHOW_ERRORS } from './types';
import axios from 'axios';

export default function tradePlayers (fplTeamId, listPositionId, targetId) {
  return dispatch => {
    axios({
      method: 'post',
      url: `/fpl_teams/${fplTeamId}/trades.json`,
      data: {
        list_position_id: listPositionId,
        in_player_id: targetId
      }
    }).then(res => {
      dispatch(tradePlayersAsync(res.data));
    }).catch(error => {
      dispatch({ type: SHOW_ERRORS, payload: error.response.data });
    });;
  }
}

function tradePlayersAsync (data) {
  return {
    type: TRADE_PLAYERS,
    payload: data
  };
}
