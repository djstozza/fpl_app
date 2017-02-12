# TODO: Merge all the datatable files into this one. The idea is that defining a new datatable will only require adding
# TODO: table-specific settings here. This file will require some changes to account for all use cases, but it shouldn't
# TODO: be too hard.
jQuery ->
  buttonExportOptions =
    format:
      # Remove HTML elements (e.g., dropdown options) from column headers on export.
      header: (cellInnerHtml, cellIndex, cellNode) ->
        $(cellNode).contents().filter(-> this.nodeType == Node.TEXT_NODE).text()

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

  # Create a setup trigger function for Datatables that are shown in tabs.
  # Arguments:
  #  * tabLinkSelector - CSS selector string for the link that triggers the Datatable's tab
  #  * showTabOnLoad - if true, the Datatable's tab will be shown when the Datatable is first created
  _createTabSetupTrigger = (tabLinkSelector, showTabOnLoad = false) ->
    (table) ->
      $tabLink = $(tabLinkSelector)
      $tabLink.tab('show') if showTabOnLoad
      $tabLink.click (e) ->
        e.preventDefault()
        $(this).tab('show')
        $(table).DataTable().responsive.recalc()

  createYadcfTextFilter = (columnNumber) ->
    { column_number: columnNumber, filter_type: 'text', filter_delay: 250, text_data_delimiter: ',' }

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
    table = $container.dataTable(
      $.extend({},
               defaultSettings,
               containerSettings,
               columns: columns
               order: defaultOrder
               ajax: $container.data('source'))
    )

    containerSettings._setupTrigger(table, colTitleToIndex) if containerSettings._setupTrigger
