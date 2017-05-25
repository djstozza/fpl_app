import { FETCH_ROUND } from './types';
import axios from 'axios';

export default function fetchRound(roundId) {
  return dispatch => {
    axios.get(`/rounds/${roundId}.json`)
      .then(res => {
        dispatch(fetchRoundsAsync(res.data));
      });
  }
}

function fetchRoundsAsync(data){
  return {
    type: FETCH_ROUND,
    payload: data
  };
}
