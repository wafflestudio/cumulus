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
  constructor: (paths) ->
    @parentPaths = []
    @paths = paths

  body: () ->
    $('#explorer > tbody')

  isFocused: () ->
    true

  isRoot: () ->
    @parentPaths.empty()

  open: (fileIds) ->
    console.log "enter #{fileIds}"
    @parentPaths = @paths
    if fileIds instanceof Array
      @paths = fileIds 
    else
      @paths = [fileIds]
    unless intersection(@paths, fileSystem.rootIds).empty()
      console.log "Path is root dir" 
      @parentPaths = []

    for path in @paths
      console.log "get file in #{path}"
      dropboxClient.listFiles(path)
    @render()

  copy: (from, to) ->

  move: (from, to) ->

  remove: (fileId) ->

  renderDirectory: (files) ->
    body = @body()
    body.html ''

    if not @isRoot()
      $tr = $('<tr>').attr('file-id', @parentPaths[0])
      $title = $('<td>').html($('<a>').attr('href', '#' + @parentPaths[0]).text(".."))
      $title.appendTo $tr
      $('<td>').html("").appendTo $tr
      $tr.appendTo body

      _this = @
      $tr.click (e) ->
        id = $(@).attr('file-id')
        _this.open(id)

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
    @paths = fileSystem.rootIds if @paths.empty()
    filesInDirectory = []
    files = fileSystem.files

    if @parentPaths.empty()
      console.log "enter root directory"
      for file in files
        filesInDirectory.push(file) if file.isRoot
    else
      console.log "enter none root directory"
      for file in files
        console.log intersection(@paths, file.parentIds)
        filesInDirectory.push(file) unless intersection(@paths, file.parentIds).empty()
    @renderDirectory(filesInDirectory)

  renderPhoto: () ->
    @path = fileSystem.rootId if @path is null
    filesInDirectory = []
    files = fileSystem.files

    for file in files
      filesInDirectory.push(file) if file.isPhoto()
    
    @renderDirectory(filesInDirectory)
