class @FileSystem
  constructor: () ->
    @rootId = null
    @files = []
    @filesIndex = {}

  push: (file) ->
    @files.push(file)
    @filesIndex[file.id] = @files.length - 1

  getFile: (fileId) ->
    console.log "fileId: #{fileId}"
    @files[@filesIndex[fileId]]

class @File
  constructor: (id, parentIds, isRoot, mimeType, title, directUrl, previewUrl) ->
    @id = id
    @parentIds = parentIds
    @isRoot = isRoot

    @mimeType = mimeType
    @title = title
    @directUrl = directUrl
    @previewUrl = previewUrl

  isDirectory: () ->
    @mimeType is 'application/vnd.google-apps.folder'
