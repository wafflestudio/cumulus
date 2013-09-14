class @StorageClient
  constructor: () ->

class @GoogleDriveClient extends StorageClient
  constructor: (clientId, scopes) ->
    super()
    @clientId = clientId
    @scopes = scopes
    console.log "GoogleDrive(#{@clientId}, #{@scopes})"

  listFiles: (rootFolderId) ->
    request = gapi.client.request(
      path: "/drive/v2/files"
      method: "GET"
      params: {'maxResults':1000}
    )
    request.execute (data) ->
      console.log data
      console.log data.items
      for item in data.items
        item.parents = item.parents.map (parent) -> parent.id
        file = new File(item.id, item.parents, item.parents.length is 0 or rootFolderId in item.parents, item.mimeType, item.title, item.webContentLink)
        fileSystem.push(file)
      explorer.render()

  getUserInfo: () ->
    request = gapi.client.request(
      path: "/drive/v2/about"
      method: "GET"
    )
    request.execute (data) =>
      console.log data
      $('#user-info').append data.name
      fileSystem.rootId = data.rootFolderId
      @listFiles(data.rootFolderId)
    $('#form-authorize').remove()
    

  handleAuthResult: (authResult) =>
    authButton = document.getElementById("btn-authorize")
    authButton.style.display = "none"
    @getUserInfo()
    unless authResult and not authResult.error
      authButton.style.display = "block"
      authButton.onclick = ->
        gapi.auth.authorize
          client_id: @clientId
          scope: @scopes
          immediate: false
        , @handleAuthResult

  checkAuth: () ->
    gapi.auth.authorize
      client_id: @clientId
      scope: @scopes
      immediate: true
    , @handleAuthResult

class @DropboxClient extends StorageClient
  constructor: (key) ->
    super()
    @client = new Dropbox.Client(key: key)

  authorize: () ->
    @client.authenticate (error, data) =>
        return console.log error if error
        $('#form-authorize').remove()
        @listFiles('/')
        @client.getAccountInfo (error, userInfo) =>
          return @showError(error) if error
          $('#user-info').text userInfo.name

  listFiles: (path) ->
    @client.readdir path, (error, entries, dir_stat, entry_stats) =>
      return console.log error if error
      console.log dir_stat
      console.log entry_stats
          
      for entry in entry_stats
        file = new File(entry.path, path, true, entry.mimeType, entry.name, null)
        fileSystem.push(file)
      explorer.render()

  isAuthorized: () ->
    @client.isAuthenticated()

