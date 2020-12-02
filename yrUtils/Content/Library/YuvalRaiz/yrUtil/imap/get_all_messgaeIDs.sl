namespace: YuvalRaiz.yrUtil.imap
operation:
  name: get_all_messgaeIDs
  inputs:
    - mail_server
    - username
    - password:
        sensitive: true
    - folder
    - sender:
        required: false
    - subject:
        required: false
    - body:
        required: false
  python_action:
    use_jython: false
    script: "import imaplib\n\ndef execute(mail_server,username,password,folder,sender,subject,body): \n    return_code=0\n    return_result=''\n    error_message=''\n    filter='''(%s %s %s)''' % ('' if sender == '' else 'FROM %s' % (sender), '' if subject == '' else 'SUBJECT \"%s\"' % (subject),  '' if body == '' else 'TEXT \"%s\"' % (body))\n\n    try:\n        imap=imaplib.IMAP4_SSL(mail_server)\n        imap.login(username,password)\n        imap.select(folder)\n        rv,msg_ids=imap.search(None, filter)\n        if rv!='OK':\n            error_message=msg[0].decode()\n            return_code=2\n        msg_ids=str(msg_ids[0])[2:-1].replace(' ',',')\n        imap.close()\n        imap.logout()\n    except Exception as e:\n        error_message=e\n        return_code=-1\n    return locals()"
  outputs:
    - msg_ids
    - return_code
    - error_message
    - filter
  results:
    - SUCCESS: "${return_code=='0'}"
    - FAILURE
