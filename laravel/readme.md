# Tinder for politics



## Api

Ip address: 188.166.45.118
Token in header or as a url parameter (with name '''token''')
In header: Authorization Bearer: token

'''POST signin''' get a token and create an account
parameters: '''email''' and '''password'''

'''POST signup''' get a token for an exsiting account
parameters: '''email''' and '''password'''

'''GET refreah''' refresh a token

'''GET v0/question''' answered questions

'''GET v0/question/new''' new questions

'''GET v0/question/id''' details for the question

'''POST v0/question/id''' send response for question
parameters: '''answer''' : string

'''POST v0/question'''  send new question
parameters: '''text''' : string, '''theme''' : a theme id, '''answer''': string

'''GET v0/party'''  get list of parties

'''GET v0/theme'''  get list of themes

