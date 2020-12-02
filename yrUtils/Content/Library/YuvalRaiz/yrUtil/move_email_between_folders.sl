namespace: YuvalRaiz.yrUtil
operation:
  name: move_email_between_folders
  inputs:
    - mail_server
    - username
    - password:
        sensitive: true
    - from_folder
    - to_folder
    - msg_id
  python_action:
    use_jython: false
    script: "import imaplib\n\ndef execute(mail_server,username,password,from_folder,to_folder,msg_id): \n    return_code=0\n    return_result=''\n    error_message=''\n    try:\n        imap=imaplib.IMAP4_SSL(mail_server)\n        imap.login(username,password)\n        imap.select(from_folder)\n        rv,msg=imap.copy(msg_id,to_folder)\n        if rv=='OK':\n            imap.uid('STORE',msg_id,'+FLAGS','(\\\\Deleted)')\n            if rv=='OK':\n                imap.expunge()\n            else:\n                error_message=msg[0].decode()\n                return_code=3\n        else:\n            error_message=msg[0].decode()\n            return_code=2\n    except Exception as e:\n        error_message=e\n        return_code=-1\n    return locals()"
  results:
    - SUCCESS
