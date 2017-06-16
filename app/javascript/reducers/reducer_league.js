import { FETCH_LEAGUE } from '../actions/types';

export default function(state=[], action) {
  switch (action.type) {
    case FETCH_LEAGUE:
      return action.payload

    default:
      return state;
  }
}
