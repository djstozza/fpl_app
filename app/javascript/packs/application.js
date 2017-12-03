/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb
import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import createHistory from 'history/createBrowserHistory'
import { Route, IndexRoute } from 'react-router'
import { createStore, applyMiddleware } from 'redux';
import { ConnectedRouter, routerReducer, routerMiddleware, push } from 'react-router-redux';
import { Row, Col } from 'react-bootstrap';
import Rounds from '../containers/rounds.js';
import Team from '../containers/team.js';
import Players from '../containers/players.js';
import Player from '../containers/player.js';
import League from '../containers/league.js';
import DraftPicks from '../containers/draft_picks.js';
import FplTeam from '../containers/fpl_team.js';
import FplTeams from '../containers/fpl_teams.js';
import InterTeamTradeGroups from '../containers/inter_team_trade_groups.js';
import MiniDraftPicks from '../containers/mini_draft_picks.js'
import thunk from 'redux-thunk';
import reducers from '../reducers';
import axios from 'axios';
import Alert from 'react-s-alert';
import '../../../node_modules/react-bootstrap-table/dist/react-bootstrap-table.min.css';
import '../../../node_modules/react-s-alert/dist/s-alert-default.css';
import '../../../node_modules/react-s-alert/dist/s-alert-css-effects/bouncyflip.css';
import '../../../node_modules/react-select/dist/react-select.css';
// Support component names relative to this directory:

const history = createHistory();
const middleware = routerMiddleware(history);
const createStoreWithMiddleware = applyMiddleware(thunk)(createStore);
const store = createStoreWithMiddleware(reducers);

var componentRequireContext = require.context("components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);

export default class App extends Component {
  constructor(props) {
    super(props);
  }

  render () {
    return (
      <Provider store={store}>
        <ConnectedRouter history={history}>
          <div className='container'>
            <Row className='clearfix'>
              <Col md={12} xs={12}>
                <Alert stack={ { limit: 3 } } />
                <Route exact path="/" component={ Rounds } />
                <Route exact path='/rounds' component={ Rounds } />
                <Route exact path='/rounds/:id(\d+)' component={ Rounds } />
                <Route path='/teams/:id(\d+)' component={ Team } />
                <Route exact path='/players' component={ Players } />
                <Route exact path='/players/:id(\d+)' component={ Player } />
                <Route exact path='/leagues/:id(\d+)' component={ League } />
                <Route exact path='/leagues/:id(\d+)/draft_picks' component={ DraftPicks } />
                <Route exact path='/leagues/:id(\d+)/mini_draft_picks' component={ MiniDraftPicks } />
                <Route exact path='/fpl_teams' component={ FplTeams } />
                <Route exact path='/fpl_teams/:id(\d+)' component={ FplTeam } />
                <Route
                  exact
                  path='/fpl_teams/:fpl_team_id(\d+)/inter_team_trade_groups'
                  component={ InterTeamTradeGroups }
                />
             </Col>
            </Row>
          </div>
        </ConnectedRouter>
      </Provider>
    );
  }
}

ReactDOM.render(
  <App />,
  document.getElementById('root')
)
