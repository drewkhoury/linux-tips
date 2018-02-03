aws-env-vars () {
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_DEFAULT_PROFILE
  unset AWS_SESSION_TOKEN
  unset AWS_ACCESS_KEY
  unset AWS_SECRET_KEY

  export AWS_ACCESS_KEY=`aws configure get aws_access_key_id --profile $1`
  export AWS_ACCESS_KEY_ID=`aws configure get aws_access_key_id --profile $1`
  export AWS_SECRET_ACCESS_KEY=`aws configure get aws_secret_access_key --profile $1`
  export AWS_SECRET_KEY=`aws configure get aws_secret_access_key --profile $1`
  export AWS_SESSION_TOKEN=`aws configure get aws_session_token --profile $1`
  export AWS_SECURITY_TOKEN=`aws configure get aws_session_token --profile $1`
  export AWS_DEFAULT_PROFILE=$1
}

flush-dns () {
  sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder
}

aws-whoami () {
  aws iam list-account-aliases
}

aws-profile-refresh () {
 aws-mfa --device arn:aws:iam::xxx:mfa/drew --duration 3600 --profile my_profile
 aws-env-vars my_profile
}

aws-env-unset () {
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_DEFAULT_PROFILE
  unset AWS_SESSION_TOKEN
  unset AWS_ACCESS_KEY
  unset AWS_SECRET_KEY
}

okta-auth () {
  docker run -it xxx/okta-auth:latest
}
