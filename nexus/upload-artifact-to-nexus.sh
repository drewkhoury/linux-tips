# note: if this is the FIRST artifact you're uploading,
#       you'll need to set $NEW_VERSION=x.x.x just before you do the curl.
#       every other time, the script figures it out auto-magically.
 
# params - change these as required...
#################################################################
 
# artifact data
GROUP_ID=x,y,z
ARTIFACT_ID=foo
CLASSIFIER=
TYPE=gz
LOCAL_FILE=${ARTIFACT_ID}.${TYPE} # curl will assume this lives in pwd
 
# nexus data
NEXUS_HOST=host_name
NEXUS_USERNAME=user_name
NEXUS_PASSWORD=password
REPO=my_repo

# nexus url data 
SERVER="http://${NEXUS_HOST}:8081"
USER="${NEXUS_USERNAME}:${NEXUS_PASSWORD}"
 
# choose :: 1a (auto-generate artiact version) or 1.b (manually set artifact version)
#####################################################################################  

# 1a ::IF THE ARTIFACT EXISTS
########################################### 
# get current version (major.minor.patch)
VERSION=`curl -X GET -u ${NEXUS_USERNAME}:${NEXUS_PASSWORD} "$SERVER/nexus/service/local/artifact/maven/resolve?r=${REPO}&g=${GROUP_ID}&a=${ARTIFACT_ID}&e=${TYPE}&v=LATEST" | sed -n 's|<version>\(.*\)</version>|\1|p'`
a=( ${VERSION//./ } )
MAJOR=${a[0]}
MINOR=${a[1]}
PATCH=${a[2]} 

 
# the new version is just a bump to the patch (e.g if the latest was 52.1.0 then the new version will be 52.1.1)
NEW_VERSION=${MAJOR}.${MINOR}.$(($PATCH+1))
 
# 1b :: MANUALLY SET THE ARTIFACT VERSION
###########################################
# NEW_VERSION=1.2.3
 
# 2 :: upload to nexus :: curl will assume the file you want to upload is in pwd
#####################################################################################
# upload to nexus :: curl will assume the file you want to upload is in pwd
URL="$SERVER/nexus/service/local/artifact/maven/content"
curl --write-out "\nStatus: %{http_code}\n" \
    --request POST \
    --user $USER \
    -F "r=${REPO}" \
    -F "g=${GROUP_ID}" \
    -F "a=${ARTIFACT_ID}" \
    -F "v=${NEW_VERSION}" \
    -F "c=${CLASSIFIER}" \
    -F "p=${TYPE}" \
    -F "hasPom=false" \
    -F "e=${TYPE}" \
    -F "file=@${LOCAL_FILE}" \
    "$URL"