window.fileSystem = new FileSystem()
window.explorer = new Explorer()

window.handleClientLoad = () ->
  console.log "google sdk loaded"
  window.googleDriveClient = new GoogleDriveClient(GOOGLE_DRIVE_CLIENT_ID, GOOGLE_DRIVE_SCOPES)
  googleDriveClient.checkAuth()

window.dropboxClient = new DropboxClient(DROPBOX_DRIVE_KEY)
dropboxClient.authorize()
