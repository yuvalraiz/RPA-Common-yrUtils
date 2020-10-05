########################################################################################################################
#!!
#! @input total_retries: how many 10 second retries
#!!#
########################################################################################################################
namespace: YuvalRaiz.yrUtil
flow:
  name: get_newest_relevant_email
  inputs:
    - mailserver
    - username
    - password:
        sensitive: true
    - sender
    - subject
    - total_retries: '12'
  workflow:
    - init_counter:
        do:
          YuvalRaiz.yrUtil.do_nothing:
            - input_0: '${total_retries}'
        publish:
          - counter: '${input_0}'
        navigate:
          - SUCCESS: get_mail_message_count
    - get_mail_message_count:
        do:
          io.cloudslang.base.mail.get_mail_message_count:
            - host: '${mailserver}'
            - protocol: imap4
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - folder: Inbox
            - enable_TLS: 'true'
            - in_counter: '${counter}'
        publish:
          - message_count: '${return_result}'
          - return_code
          - exception
          - counter: '${str(int(in_counter)-1)}'
        navigate:
          - SUCCESS: is_mailbox_not_empty
          - FAILURE: does_have_more_retries
    - is_mailbox_not_empty:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(message_count != '0' )}"
        navigate:
          - 'TRUE': _get_newest_relevant_email
          - 'FALSE': does_have_more_retries
    - _get_newest_relevant_email:
        loop:
          for: 'message_number in range(int(message_count),0,-1)'
          do:
            YuvalRaiz.yrUtil._get_newest_relevant_email:
              - mailserver: '${mailserver}'
              - username: '${username}'
              - password:
                  value: '${password}'
                  sensitive: true
              - message_number: '${str(message_number)}'
              - sender: '${sender}'
              - subject: '${subject}'
          break:
            - SUCCESS
          publish:
            - from_address
            - email_subject
            - email_body
            - email_plain_text_body
            - return_result
        navigate:
          - SUCCESS: SUCCESS
          - NOT_THAT_MESSAGE: does_have_more_retries
    - does_have_more_retries:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(int(counter) >= 0)}'
        publish: []
        navigate:
          - 'TRUE': sleep
          - 'FALSE': FAILURE
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '5'
        navigate:
          - SUCCESS: get_mail_message_count
          - FAILURE: get_mail_message_count
  outputs:
    - email_subject
    - from_address
    - email_body
    - return_result
    - email_plain_text_body
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      init_counter:
        x: 77
        'y': 129
      get_mail_message_count:
        x: 244
        'y': 124
      is_mailbox_not_empty:
        x: 393
        'y': 124
      _get_newest_relevant_email:
        x: 608
        'y': 125
        navigate:
          064da931-5524-0674-2ada-2444fea928ba:
            targetId: 4389314a-50ad-d882-3e28-b8a9c0a04664
            port: SUCCESS
      sleep:
        x: 266
        'y': 317
      does_have_more_retries:
        x: 525
        'y': 313
        navigate:
          f14898ea-e276-d243-2c0b-465af4866c26:
            targetId: e1d79625-756d-2eec-98f7-dea82478998c
            port: 'FALSE'
    results:
      FAILURE:
        e1d79625-756d-2eec-98f7-dea82478998c:
          x: 782
          'y': 293
      SUCCESS:
        4389314a-50ad-d882-3e28-b8a9c0a04664:
          x: 818
          'y': 110
