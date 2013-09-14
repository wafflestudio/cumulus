class @Explorer
  constructor: () ->
    @tabs = [new Tab(fileSystem.rootIds)]

  currentTab: () ->
    currentTab
    for tab in @tabs
      currentTab = tab if tab.isFocused()
    currentTab

  render: () ->
    @currentTab().render()


class @Tab
  constructor: (path) ->
    @parentPath = null
    @path = path

  body: () ->
    $('#explorer > tbody')

  isFocused: () ->
    true

  isRoot: () ->
    @parentPath is null

  open: (fileId) ->
    console.log "enter #{fileId}"
    @parentPath = @path
    @path = fileId
    @parentPath = null if @path is fileSystem.rootId
    @render()

  copy: (from, to) ->

  move: (from, to) ->

  remove: (fileId) ->

  renderDirectory: (files) ->
    body = @body()
    body.html ''

    if not @isRoot()
      $tr = $('<tr>').attr('file-id', @parentPath)
      $title = $('<td>').html($('<a>').attr('href', '#' + @parentPath).text(".."))
      $title.appendTo $tr
      $('<td>').html("").appendTo $tr
      $tr.appendTo body

    for file in files
      $tr = $('<tr>').attr('file-id', file.id)
      if file.isDirectory()
        fileLink = '#' + file.id
      else
        fileLink = file.previewUrl
      $title = $('<td class="title">').html($('<a>').attr('href', fileLink).html(file.typeIcon()).append(' ' + file.title))
      $title.appendTo $tr
      if(file.downloadUrl)
        $('<td class="downloadurl">').html($('<a>').attr('href', file.downloadUrl).html('<span class="glyphicon glyphicon-cloud-download"></span>')).appendTo $tr
      else $('<td class="downloadurl">').appendTo $tr
      $tr.appendTo body

      if file.isDirectory()
        _this = @
        $tr.click (e) ->
          id = $(@).attr('file-id')
          _this.open(id)


    true

  render: () ->
    @path = fileSystem.rootId if @path is null
    filesInDirectory = []
    files = fileSystem.files

    if not @parentPath
      for file in files
        filesInDirectory.push(file) if file.isRoot
    else
      for file in files
        filesInDirectory.push(file) if @path in file.parentIds

    @renderDirectory(filesInDirectory)
