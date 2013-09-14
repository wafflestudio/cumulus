window.fileSystem = new FileSystem()
window.explorer = new Explorer()

window.handleClientLoad = () ->
  window.googleDriveClient = new GoogleDriveClient(GOOGLE_DRIVE_CLIENT_ID, GOOGLE_DRIVE_SCOPES)
  window.googleDriveClient.checkAuth()

#dropboxClient = new DropboxClient(DROPBOX_DRIVE_KEY)
#dropboxClient.authorize()
