class Datatable
  delegate :params, :link_to, :content_tag, to: :@view

  include Rails.application.routes.url_helpers

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    if @records_total.nil?
      raise NoParamError.new '@records_total is not defined in child class'
    end
    if @records_filtered.nil?
      raise NoParamError.new '@records_filtered is not defined in child class'
    end

    {
      draw: params[:draw].to_i,
      recordsTotal: @records_total,
      recordsFiltered: @records_filtered,
      data: data
    }
  end

  private

  # Default implementation of the data fetcher - map @process_record_lambda to each record and handle pagination.
  def data
    paginated_records.map(&@process_record_lambda)
  end

  def paginated_records
    @paginated_records ||=
      if per_page > 0
        # @records can either be a relation or an array.
        if @records.respond_to?(:page)
          @records.page(page).per_page(per_page)
        else
          range_start = (page - 1) * per_page
          @records.to_a.slice(range_start..range_start + per_page - 1)
        end
      else
        @records
      end
  end

  def page
    params[:start].to_i / per_page + 1
  end

  def per_page
    10
  end

  def sort_direction
    params[:order]['0'][:dir] == 'desc' ? 'desc' : 'asc'
  end

  class NoParamError < ArgumentError
  end

  def sort_column
    columns[params[:order]['0'][:column].to_i]
  end

  def sorting
    "#{sort_column} #{sort_direction}"
  end
end
