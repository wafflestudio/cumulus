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
        $title = $('<td class="title">').html($('<a>').attr({'href': '#music'+musicID, 'data-target': '#music'+musicID, 'data-toggle': 'modal'}).html(file.typeIcon()).append(' ' + file.title))
        console.log("Music ID: #{musicID}")
        console.log("FILE ID: #{file.id}")
        $('<div class="modal fade" id="music' + musicID + '" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"><div class="modal-dialog"><div class="modal-content"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button><h4 class="modal-title">' + file.title + '</h4></div><div class="modal-body"><audio src="' + file.downloadUrl + '" preload ="auto" />').appendTo $('body')
      else if file.isVideo()
        videoID = window.fileSystem.getIndex(file.id)
        $title = $('<td class="title">').html($('<a>').attr({'href': '#video'+videoID, 'data-target': '#video'+videoID, 'data-toggle': 'modal'}).html(file.typeIcon()).append(' ' + file.title))
        console.log("videoID: #{videoID}")
        console.log("FILE ID: #{file.id}")
        $('<div class="modal fade" id="video' + videoID + '" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"><div class="modal-dialog"><div class="modal-content"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button><h4 class="modal-title">' + file.title + '</h4></div><div class="modal-body"><video controls width="100%" class="video-js vjs-default-skin" src="' + file.downloadUrl + '" preload ="auto" />').appendTo $('body')

      else
        fileLink = file.previewUrl
        $title = $('<td class="title">').html($('<a>').attr('href', fileLink).html(file.typeIcon()).append(' ' + file.title))
      $title.appendTo $tr

      console.log(file.downloadUrl)
      if(file.downloadUrl?)
        $('<td class="downloadurl">').html($('<a>').attr('href', file.downloadUrl).html('<span class="glyphicon glyphicon-cloud-download"></span>')).appendTo $tr
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
    $('.modal').remove()

    if @parentPaths.empty()
      console.log "enter root directory"
      for file in files
        filesInDirectory.push(file) if file.isRoot
    else
      console.log "enter none root directory"
      for file in files
        console.log intersection(@paths, file.parentIds)
        filesInDirectory.push(file) unless intersection(@paths, file.parentIds).empty()
<<<<<<< HEAD
    @renderDirectory(filesInDirectory)
    audiojs.events.ready ->
      as = audiojs.createAll()
    $(".modal").on "hidden.bs.modal", ->
      $('.playing').removeClass('playing')
      $('.playing audio')[0].pause()

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
