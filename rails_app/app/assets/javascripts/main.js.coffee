window.fileSystem = new FileSystem()
window.explorer = new Explorer()
window.handleClientLoad = () ->
  console.log "google sdk loaded"
  window.googleDriveClient = new GoogleDriveClient(GOOGLE_DRIVE_CLIENT_ID, GOOGLE_DRIVE_SCOPES)
  googleDriveClient.checkAuth()

window.dropboxClient = new DropboxClient(DROPBOX_DRIVE_KEY)
dropboxClient.authorize()

$ ->
  $('#photo-album').click ->
    if $('#photo-album').html() is "Photo Album"
      if explorer.tabs.length is 1
        explorer.tabs.push(new Tab(fileSystem.rootIds))

      explorer.tabs[0].isFocused = false
      explorer.tabs[1].isFocused = true
      explorer.currentTab().renderPhoto()
      $('#explorer').hide()
      $('#photo-album').html("Go Back")
    else
      explorer.tabs[0].isFocused = true
      explorer.tabs[1].isFocused = false
      explorer.currentTab().renderDirectory()
      $('.img-thumbnail').remove()
      $('#explorer').show()
      $('#photo-album').html("Photo Album")
