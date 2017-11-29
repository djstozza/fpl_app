import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Provider } from 'react-redux';
import { Row, Col, Button } from 'react-bootstrap';
import axios from 'axios';
import fetchFplTeam from '../actions/fpl_teams/action_fetch_fpl_team.js';
import fetchFplTeamLists from '../actions/fpl_team_lists/action_fetch_fpl_team_lists.js';
import fetchInterTeamTradeGroups from '../actions/inter_team_trade_groups/action_index.js';
import fetchInterTeamTradeGroup from '../actions/inter_team_trade_groups/action_show.js';
import newInterTeamTradeGroup from '../actions/inter_team_trade_groups/action_new.js';
import createInterTeamTradeGroup from '../actions/inter_team_trade_groups/action_create.js';
import fetchTeams from '../actions/action_fetch_teams.js';
import OutTradesTable from '../components/inter_team_trades/out_trades_table.js';
import InTradesTable from '../components/inter_team_trades/in_trades_table.js';
import TradeGroupsTable from '../components/inter_team_trades/trade_group_table.js';

class InterTeamTradeGroups extends Component {
  constructor (props) {
    super(props);

    this.state = {
      fplTeamId: this.props.match.params.fpl_team_id,
      fplTeamListId: this.props.match.params.fpl_team_list_id,
    }

    this.newTradeGroup = this.newTradeGroup.bind(this);
    this.tradeGroupPlayerList = this.tradeGroupPlayerList.bind(this);
    this.setOutPlayer = this.setOutPlayer.bind(this);
    this.completeTradeAction = this.completeTradeAction.bind(this);
    this.outTradeGroups = this.outTradeGroups.bind(this);
    this.fetchTradeGroup = this.fetchTradeGroup.bind(this);
  }

  newTradeGroup () {
    this.setState({
      out_players_tradeable: null,
      in_players_tradeable: null,
      tradeGroup: null
    })
    this.props.newInterTeamTradeGroup(this.state.fplTeamId, this.state.fplTeamListId);
  }

  componentWillMount () {
    this.props.fetchFplTeam(this.state.fplTeamId);
    this.props.fetchFplTeamLists(this.state.fplTeamId);
    this.props.fetchInterTeamTradeGroups(this.state.fplTeamId, this.state.fplTeamListId);
    this.props.fetchTeams();
  }

  completeTradeAction (in_player) {
    if (this.state.tradeGroup == null) {
      this.props.createInterTeamTradeGroup(
        this.state.fplTeamId,
        this.state.fplTeamListId,
        in_player.in_fpl_team_list_id,
        this.state.out_player.out_player_id,
        in_player.in_player_id
      );
    }

    this.setState({
      out_players_tradeable: null,
      in_players_tradeable: null,
      tradeGroup: null
    });
  }

  componentWillReceiveProps (nextProps) {
    this.setState({
      league: nextProps.league,
      fpl_team: nextProps.fpl_team,
      fpl_teams: nextProps.fpl_teams,
      current_user: nextProps.current_user,
      picked_players: nextProps.picked_players,
      fpl_team_list: nextProps.fpl_team_list,
      fpl_team_lists: nextProps.fpl_team_lists,
      out_players_tradeable: nextProps.out_players_tradeable,
      in_players_tradeable: nextProps.in_players_tradeable,
      status: nextProps.status,
      positions: nextProps.positions,
      round: nextProps.round,
      rounds: nextProps.rounds,
      teams: nextProps.teams,
      out_trade_groups: nextProps.out_trade_groups,
      in_trade_groups: nextProps.in_trade_groups
    });
  }

  tradeGroupPlayerList (tradeGroup) {
    if (this.state.out_players_tradeable == null || this.state.tradeGroup != tradeGroup) {
      return;
    }

    return (
      <div>
        <Row className='clearfix'>
          <Col xs={5}>
            <OutTradesTable
              out_players_tradeable={ this.state.out_players_tradeable }
              fpl_team={ this.state.fpl_team }
              current_user={ this.state.current_user }
              status={ this.state.status }
              setOutPlayer={ this.setOutPlayer }
            />
          </Col>
          <Col xs={7}>
            <InTradesTable
              in_players_tradeable={ this.state.in_players_tradeable }
              teams={ this.state.teams }
              fpl_teams={ this.state.fpl_teams }
              positions={ this.state.positions }
              out_player={ this.state.out_player }
              status={ this.state.status }
              fpl_team={ this.state.fpl_team }
              current_user={ this.state.current_user }
              completeTradeAction={ this.completeTradeAction }
            />
          </Col>
        </Row>
      </div>
    );
  }

  outTradeGroups () {
    return (
      this.state.out_trade_groups.map( (tradeGroup) => {
        return (
          <div key={ `outTradeGroup-${tradeGroup.id}` }>
            <Button  onClick={ () => this.fetchTradeGroup(tradeGroup) }>
              Add to Trade Group
            </Button>
            { this.tradeGroupPlayerList(tradeGroup) }
            <TradeGroupsTable tradeGroup={ tradeGroup } />
          </div>
        )
      })
    )
  }

  fetchTradeGroup (tradeGroup) {
    this.setState({ tradeGroup: tradeGroup });
    this.props.fetchInterTeamTradeGroup(this.state.fplTeamId, this.state.fplTeamListId, tradeGroup.id);
  }

  setOutPlayer (outPlayer) {
    this.setState({ out_player: outPlayer });
  }

  render () {
    if (this.state == null || this.state.fpl_team == null || this.state.fpl_team_list == null) {
      return (
        <p>Loading...</p>
      )
    } else {
      return (
        <div>
          <Button onClick={ (e) => this.newTradeGroup(e) }>Create A New Trade</Button>
          { this.tradeGroupPlayerList() }
          { this.outTradeGroups() }
        </div>
      )
    }
  }
}

function mapStateToProps (state) {
  return {
    league: state.FplTeamReducer.league,
    fpl_team: state.FplTeamReducer.fpl_team,
    fpl_teams: state.FplTeamReducer.fpl_teams,
    current_user: state.FplTeamReducer.current_user,
    fpl_team_list: state.FplTeamListsReducer.fpl_team_list,
    fpl_team_lists: state.FplTeamListsReducer.fpl_team_lists,
    status: state.FplTeamListsReducer.status,
    positions: state.FplTeamReducer.positions,
    round: state.FplTeamListsReducer.round,
    rounds: state.FplTeamListsReducer.rounds,
    teams: state.TeamsReducer,
    out_trade_groups: state.InterTeamTradeGroupsReducer.out_trade_groups,
    in_trade_groups: state.InterTeamTradeGroupsReducer.in_trade_groups,
    out_players_tradeable: state.InterTeamTradeGroupsReducer.out_players_tradeable,
    in_players_tradeable: state.InterTeamTradeGroupsReducer.in_players_tradeable,
    success: state.InterTeamTradeGroupsReducer.success,
    errors: state.InterTeamTradeGroupsReducer.errors
  }
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({
    fetchFplTeam: fetchFplTeam,
    fetchFplTeamLists: fetchFplTeamLists,
    fetchTeams: fetchTeams,
    newInterTeamTradeGroup: newInterTeamTradeGroup,
    createInterTeamTradeGroup: createInterTeamTradeGroup,
    fetchInterTeamTradeGroups: fetchInterTeamTradeGroups,
    fetchInterTeamTradeGroup: fetchInterTeamTradeGroup
  }, dispatch);
}

export default connect(mapStateToProps, mapDispatchToProps)(InterTeamTradeGroups);
