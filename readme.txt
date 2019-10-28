OAuth console util

Start script:

    ./oauth.sh ${file_with_urls.txt} ${client_id} ${client_secret}

file_with_urls must contain the following fields:

    auth_server_url
    token_server_url
    redirect_uri

for example google url:

    auth_server_url=https://accounts.google.com/o/oauth2/v2/auth
    token_server_url=https://www.googleapis.com/oauth2/v4/token
    redirect_uri=http://localhost:8080/callback

Also, the script requires python2
