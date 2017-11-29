class TradeGroupsDecorator < SimpleDelegator
  def all_trades
    map { |trade_group| { id: trade_group.id, trades: TradeGroupDecorator.new(trade_group).all_data } }
  end
end
