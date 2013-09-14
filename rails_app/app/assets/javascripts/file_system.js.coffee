class @FileSystem
  constructor: () ->
    @rootIds = []
    @files = []
    @filesIndex = {}

  push: (file) ->
    @files.push(file)
    @filesIndex[file.id] = @files.length - 1
  
  addRoot: (rootId) ->
    @rootIds.push(rootId)
    @rootIds.unique()

  getFile: (fileId) ->
    console.log "fileId: #{fileId}"
    @files[@filesIndex[fileId]]

class @File
  constructor: (id, parentIds, isRoot, mimeType, title, downloadUrl, previewUrl) ->
    @id = id
    @parentIds = parentIds
    @isRoot = isRoot

    @mimeType = mimeType
    @title = title
    @downloadUrl = downloadUrl
    @previewUrl = previewUrl

  isDirectory: () ->
    @mimeType in ['application/vnd.google-apps.folder', "inode/directory"]
