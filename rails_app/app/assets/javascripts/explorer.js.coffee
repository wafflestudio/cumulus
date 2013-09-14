class @Explorer
  constructor: () ->
    @tabs = [new Tab(fileSystem.rootIds)]
    @tabs[0].isFocused = true

  currentTab: () ->
    currentTab
    for tab in @tabs
      currentTab = tab if tab.isFocused
    currentTab

  render: () ->
    @currentTab().renderDirectory()

class @Tab
  constructor: (paths) ->
    @parentPaths = []
    @paths = paths
    @isFocused = false

  body: () ->
    $('#explorer > tbody')

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
    @renderDirectory()

  copy: (from, to) ->

  move: (from, to) ->

  remove: (fileId) ->
 
  displayDirectory: (files) ->
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
        $title = $('<td class="title">').html($('<a>').attr('href', fileLink).html(file.typeIcon()).append(' ' + file.title))
      else if file.isAudio()
        musicID = window.fileSystem.getIndex(file.id)
        $title = $('<td class="title">').html($('<a>').attr({'href': '#music'+musicID, 'data-target': '#music'+musicID, 'data-toggle': 'modal', 'class': 'btn btn-primary btn-lg'}).html(file.typeIcon()).append(' ' + file.title))
        console.log("Music ID: #{musicID}")
        console.log("FILE ID: #{file.id}")
        if(not file.isDirectory() and file.id.indexOf('/') is 0)
          $('<div class="modal fade" id="music' + musicID + '" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"><div class="modal-dialog"><div class="modal-content"><div class="modal-body"><audio controls><source src="' + file.downloadUrl + '" type="audio/mpeg" /></audio> ').appendTo $('body')
        else
          $('<div class="modal fade" id="music' + musicID + '" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"><div class="modal-dialog"><div class="modal-content"><div class="modal-body"><audio controls><source src="' + file.downloadUrl + '" type="audio/mpeg" /></audio> ').appendTo $('body')

      else
        fileLink = file.previewUrl
        $title = $('<td class="title">').html($('<a>').attr('href', fileLink).html(file.typeIcon()).append(' ' + file.title))
      $title.appendTo $tr

      console.log(file.downloadUrl)
      if(file.downloadUrl?)
        $('<td class="downloadurl">').html($('<a>').attr('href', file.downloadUrl).html('<span class="glyphicon glyphicon-cloud-download"></span>')).appendTo $tr
      else if(not file.isDirectory() and file.id.indexOf('/') is 0)
        $td = $('<td class="downloadurl downloadurl-dropbox">').html($('<a>').attr('href', file.downloadUrl).attr('class', 'dropbox-download').html('<span class="glyphicon glyphicon-cloud-download"></span>'))
        $td.appendTo $tr
      else $('<td class="downloadurl">').appendTo $tr
      $tr.appendTo body


      if file.isDirectory()
        _this = @
        $tr.click (e) ->
          id = $(@).attr('file-id')
          _this.open(id)
    true

  renderDirectory: () ->
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
    @displayDirectory(filesInDirectory)

  displayPhoto: (files) ->
    body = @body()
    body.html ''

    for file in files
      console.log file
      fileLink = file.previewUrl
      $('<img>').attr('src', file.downloadUrl).attr('class', 'img-thumbnail').appendTo $('#photos')

    true

  renderPhoto: () ->
    @path = fileSystem.rootId if @path is null
    filesInDirectory = []
    files = fileSystem.files

    for file in files
      filesInDirectory.push(file) if file.isPhoto() and not intersection(@paths, file.parentIds).empty()
    
    @displayPhoto(filesInDirectory)
