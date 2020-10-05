namespace: YuvalRaiz.yrUtil
flow:
  name: _get_newest_relevant_email
  inputs:
    - mailserver
    - username
    - password:
        sensitive: true
    - message_number
    - sender
    - subject
  workflow:
    - get_mail_message:
        do:
          io.cloudslang.base.mail.get_mail_message:
            - host: '${mailserver}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - message_number: '${message_number}'
            - enable_TLS: 'true'
            - character_set: UTF-8
        publish:
          - email_subject: '${subject}'
          - from_address: "${return_result.split('\\nFrom:')[1].split('<')[1].split('>')[0]}"
          - email_body: '${body}'
          - return_result
          - email_plain_text_body: '${plain_text_body}'
        navigate:
          - SUCCESS: is_this_is_the_message
          - FAILURE: NOT_THAT_MESSAGE
    - is_this_is_the_message:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(from_address.find(sender) > -1 and email_subject == subject)}'
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': NOT_THAT_MESSAGE
  outputs:
    - from_address
    - email_subject
    - email_body
    - email_plain_text_body
    - return_result
  results:
    - SUCCESS
    - NOT_THAT_MESSAGE
extensions:
  graph:
    steps:
      get_mail_message:
        x: 52
        'y': 97
        navigate:
          4fdb93c3-f60b-8c91-1401-e625434f07d9:
            targetId: e1582845-41f9-02ae-5df6-4e8459af57ee
            port: FAILURE
      is_this_is_the_message:
        x: 369
        'y': 95
        navigate:
          958434a0-a25f-9ddb-1b72-5ba8f306c4c7:
            targetId: e1582845-41f9-02ae-5df6-4e8459af57ee
            port: 'FALSE'
          d1d531d7-817d-8251-6efb-c4d0d10e808b:
            targetId: 7c6f80a3-a660-a6e3-898a-6f2b39ed5464
            port: 'TRUE'
    results:
      SUCCESS:
        7c6f80a3-a660-a6e3-898a-6f2b39ed5464:
          x: 560
          'y': 99
      NOT_THAT_MESSAGE:
        e1582845-41f9-02ae-5df6-4e8459af57ee:
          x: 201
          'y': 278
