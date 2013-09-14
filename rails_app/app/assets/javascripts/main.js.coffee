window.fileSystem = new FileSystem()
window.explorer = new Explorer()

window.handleClientLoad = () ->
  googleDriveClient = new GoogleDriveClient(GOOGLE_DRIVE_CLIENT_ID, GOOGLE_DRIVE_SCOPES)
  googleDriveClient.checkAuth()

  #  dropboxClient = new DropboxClient(DROPBOX_DRIVE_KEY)
  #dropboxClient.authorize()
