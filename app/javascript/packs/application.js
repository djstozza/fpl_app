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
import Rounds from '../containers/rounds.js';
import Team from '../containers/team.js';
import Players from '../containers/players.js';
import Player from '../containers/player.js';
import thunk from 'redux-thunk';
import reducers from '../reducers';
import axios from 'axios';
import '../../../node_modules/react-bootstrap-table/dist/react-bootstrap-table.min.css';

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
    console.log(this.props);
    return (
      <Provider store={store}>
        <ConnectedRouter history={history}>
           <div className='col-md-offset-1 col-md-10 col-xs-12'>
            <Route exact path="/" component={Rounds}/>
            <Route exact path='/rounds' component={Rounds}/>
            <Route exact path='/rounds/:id' component={Rounds} />
            <Route path='/teams/:id' component={Team} />
            <Route exact path='/players' component={Players} />
            <Route exact path='/players/:id' component={Player} />
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
