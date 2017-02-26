class PlayerStatDatatable < Datatable
  def initialize(view_context, stat)
    super(view_context)
    @stat = stat
    @records = Player.where("#{@stat} > 0").order(sorting)
    @records_total = Player.where("#{@stat} > 0").count
    @records_filtered = @records.count
    @process_record_lambda = -> (player) do
      [
        player.last_name,
        player.team.short_name,
        player.position.singular_name_short,
        player.public_send(@stat),
      ]
    end
  end

  private

  def columns
    ['last_name',
     'team_id',
     'position_id',
     @stat]
  end
end
