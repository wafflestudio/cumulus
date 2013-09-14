$ ->
  window.fileSystem = new FileSystem()
  window.explorer = new Explorer()

  window.handleClientLoad = () ->
    googleDriveClient = new GoogleDriveClient(GOOGLE_DRIVE_CLIENT_ID, GOOGLE_DRIVE_SCOPES)
    googleDriveClient.checkAuth()

  dropboxClient = new DropboxClient(DROPBOX_DRIVE_KEY)
  dropboxClient.authorize()

  $('#photo-album').click ->
    if $('#photo-album').html() is "Photo Album"
      explorer.currentTab().renderPhoto()
      $('#photo-album').html("Go Back")
    else
      explorer.currentTab().render()
      $('#photo-album').html("Photo Album")
