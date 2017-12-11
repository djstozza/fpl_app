import { FETCH_CURRENT_ROUND } from './types';
import axios from 'axios';

export default function fetchCurrentRound () {
  return dispatch => {
    axios.get('/current_rounds.json')
      .then(res => {
        dispatch(fetchCurrentRoundAsync(res.data));
      });
  }
}

function fetchCurrentRoundAsync (data) {
  return {
    type: FETCH_CURRENT_ROUND,
    payload: data
  };
}
