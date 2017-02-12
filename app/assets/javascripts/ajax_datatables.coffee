jQuery ->
  # Default settings that are shared by all Datatables. These can be overriden for specific datatables in
  # containerIdToSettings.
  defaultSettings =
    pagingType: 'simple_numbers'
    jQueryUI: true
    processing: true
    serverSide: true
    autoWidth: false
    destroy: true
    responsive: true

  # Specific settings for each Datatable. The columns and default order are read from the markup, so vanilla Datatables
  # don't need any extra configuration.
  containerIdToSettings =
    'team-ladder': {
      paginate: false
      bInfo: false
      filter: false
      headerCallback: (thead) ->
        $(thead).find('th b').tooltip(container: 'body')
    }

  for containerId, containerSettings of containerIdToSettings
    $container = $('#' + containerId)
    continue unless $container.length
    defaultOrder = [[0, 'asc']]
    colTitleToIndex = {}
    columns = $.makeArray($container.find('th').map (colIndex) ->
      $this = $(this)
      defaultOrder = [[colIndex, 'desc']] if $this.hasClass('sorting-default-desc')
      defaultOrder = [[colIndex, 'asc']] if $this.hasClass('sorting-default-asc')
      colTitleToIndex[$this.text()] = colIndex
      {
        orderable: $this.hasClass('sorting')
        visible: !$this.hasClass('inactive')
      }
    )
    table = $container.DataTable(
      $.extend({},
               defaultSettings,
               containerSettings,
               columns: columns
               order: defaultOrder
               ajax: $container.data('source'))
    )

    containerSettings._setupTrigger(table, colTitleToIndex) if containerSettings._setupTrigger
    setInterval((-> table.ajax.reload(null, false)), 180000)
