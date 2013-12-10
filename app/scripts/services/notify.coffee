notify = (msg, tag = 'dasixi') ->
  return unless window.Notification
  switch Notification.permission
    when 'default' then Notification.requestPermission -> notify()
    when 'granted'
      n = new Notification '$$$',
        body: msg
        tag: tag
    when 'denied' then return

@notify = notify
