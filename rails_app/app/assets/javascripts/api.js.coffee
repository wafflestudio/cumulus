class @StorageClient
  constructor: () ->

class @GoogleDriveClient extends StorageClient
  constructor: (clientId, scopes) ->
    @clientId = clientId
    @scopes = scopes
    gapi.client.setApiKey('AIzaSyAH5BivYV9VBWBrIuyXUfaMt2rY0c5bEpg');
    console.log "GoogleDrive(#{@clientId}, #{@scopes})"

  listFiles: (rootFolderId) ->
    request = gapi.client.request(
      path: "/drive/v2/files"
      method: "GET"
      params: {'maxResults':1000}
    )
    request.execute (data) ->
      #console.log data
      #console.log data.items
      for item in data.items
        item.parents = item.parents.map (parent) -> parent.id
        file = new File(item.id, item.parents, item.parents.length is 0 or rootFolderId in item.parents, item.mimeType, item.title, item.webContentLink, item.alternateLink)
        fileSystem.push(file)
      explorer.render()

  getUserInfo: () ->
    request = gapi.client.request(
      path: "/drive/v2/about"
      method: "GET"
    )
    request.execute (data) =>
      console.log data
      $li = $('<li>')
      $li.append $('<span>').attr('class', 'glyphicon glyphicon-hdd')
      $li.append $('<span>').text(" GoogleDrive: #{data.name}")
      $('#user-info').append $li
      fileSystem.addRoot(data.rootFolderId)
      @listFiles(data.rootFolderId)
    #$('#form-authorize').hide()

  handleAuthResult: (authResult) =>
    authButton = document.getElementById("btn-authorize")
    $('#form-authorize').hide()
    console.log authResult
    if authResult
      @getUserInfo()
    unless authResult and not authResult.error
      $('#form-authorize').show()
      authButton.onclick = =>
        gapi.auth.authorize
          client_id: @clientId
          scope: @scopes
          immediate: false
        , @handleAuthResult

  checkAuth: () =>
    console.log @clientId, @scopes
    gapi.auth.authorize
      client_id: @clientId
      scope: @scopes
      immediate: true
    , @handleAuthResult

class @DropboxClient extends StorageClient
  constructor: (key) ->
    @client = new Dropbox.Client(key: key)

  authorize: () ->
    @client.authenticate (error, data) =>
        return console.log error if error
        console.log data
        #$('#form-authorize').hide()
        fileSystem.addRoot("/")
        @listFiles('/')
        @client.getAccountInfo (error, userInfo) =>
          return @showError(error) if error
          $li = $('<li>')
          $li.append $('<span>').attr('class', 'glyphicon glyphicon-hdd')
          $li.append $('<span>').text(" Dropbox: #{userInfo.name}")
          $('#user-info').append $li

  setDownloadLink: (path) =>
    @client.makeUrl path, {download: true}, (error, data) =>
      return console.log error if error
      console.log data.url
      console.log "File Added: #{data.url}"
      window.fileSystem.getFile(path).downloadUrl = data.url
      console.log "Url1: #{data.url}"
      console.log "Url2: #{fileSystem.getFile(path).downloadUrl}"

  listFiles: (path) ->
    @client.readdir path, (error, entries, dir_stat, entry_stats) =>
      if error
        console.log error
        if error.status is 429
          @client.authenticate (error, data) =>
            console.log data
            @listFiles(path)
        else
          return error
          
      console.log dir_stat
      console.log entry_stats
          
      for entry in entry_stats
        file = new File(entry.path, path, path is "/", entry.mimeType, entry.name, null)
        fileSystem.push(file)
        this.setDownloadLink(file.id)

      explorer.render()

  isAuthorized: () ->
    @client.isAuthenticated()
