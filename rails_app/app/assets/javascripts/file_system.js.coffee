class @FileSystem
  constructor: () ->
    @rootIds = []
    @files = []
    @filesIndex = {}

  push: (file) ->
    unless @filesIndex[file.id]
      @files.push(file)
      @filesIndex[file.id] = @files.length - 1
  
  addRoot: (rootId) ->
    @rootIds.push(rootId)
    @rootIds.unique()

  getFile: (fileId) ->
    console.log "fileId: #{fileId}"
    @files[@filesIndex[fileId]]

  getIndex: (fileId) ->
    @filesIndex[fileId]

class @File
  constructor: (id, parentIds, isRoot, mimeType, title, downloadUrl, previewUrl) ->
    @id = id
    if parentIds instanceof Array
      @parentIds = parentIds
    else
      @parentIds = [parentIds]
    @isRoot = isRoot

    @mimeType = mimeType
    @title = title
    @downloadUrl = downloadUrl
    @previewUrl = previewUrl

  isDirectory: () ->
    @mimeType in ['application/vnd.google-apps.folder', "inode/directory"]
  isAudio: () ->
    @mimeType in ['audio/mpeg']
  isPhoto: () ->
    @mimeType in ['image/jpeg', 'image/pjpeg', 'image/png']
  isArchive: () ->
    @mimeType in ['application/xzip']
  isDocument: () ->
    @mimeType in ['application/vnd.google-apps.document']
  isSpreadsheet: () ->
    @mimeType in ['application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'application/vnd.google-apps.spreadsheet']
  isForm: () ->
    @mimeType in ['application/vnd.google-apps.form']
  isImage: () ->
    @mimeType in ['image/jpeg', 'image/png']
  isVideo: () ->
    @mimeType in ['video/mp4']

  typeIcon: () ->
    glyphicon = '<span class="glyphicon"></span>'

    addType = (className) ->
      $(glyphicon).addClass(className)

    if this.isDirectory()
      addType('glyphicon-folder-close')
    else if this.isAudio()
      addType 'glyphicon-music'
    else if this.isArchive()
      addType 'glyphicon-compressed'
    else if this.isDocument()
      addType 'glyphicon-file'
    else if this.isSpreadsheet()
      addType 'glyphicon-tasks'
    else if this.isForm()
      addType 'glyphicon-list-alt'
    else if this.isImage()
      addType 'glyphicon-picture'
    else if this.isVideo()
      addType 'glyphicon-film'
    else
      addType 'glyphicon-question-sign'
