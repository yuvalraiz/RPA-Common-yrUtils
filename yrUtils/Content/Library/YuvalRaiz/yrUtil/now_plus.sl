namespace: YuvalRaiz.yrUtil
operation:
  name: now_plus
  inputs:
    - seconds: '0'
    - minutes: '0'
  python_action:
    use_jython: false
    script: "#import datetime \n# do not remove the execute function \ndef execute(seconds,minutes):\n    next_time= datetime.datetime.now()+datetime.timedelta(minutes=minutes,seconds=seconds)\n    next_time_format=next_time.strftime(\"%Y-%m-%dT%H:%M:%S+00:00\")\n    return locals()\n    # code goes here\n# you can add additional helper methods below."
  outputs:
    - next_time
    - next_time_format
  results:
    - SUCCESS
