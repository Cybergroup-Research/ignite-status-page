
#!/bin/sh

read -p 'Enter environment (local | dev | prod): ' env
echo "Environment Selected : $env"
version=""
if [ "$env" == "dev" ]
then
    read -p 'Enter version (dev): ' version
    version="$version-dev"
elif [ "$env" == "prod" ]
then
    read -p 'Enter version (prod): ' version
    version="$version"
elif [ "$env" == "local" ]
then
    version="local"
else
    echo "Invalid Environment : $env"
    exit
fi
echo "New Docker Version  :  cybergroupignite/runtime:$version"

PUBLISH_FOLDER="publish"
echo "publishing to $PUBLISH_FOLDER"
if [ -d "$PUBLISH_FOLDER" ]
then
    echo "Clean Publish Folder"
    rm -rif ./"$PUBLISH_FOLDER"
fi
mkdir ./$PUBLISH_FOLDER
echo "Publish Folder created"

echo "Publishing"
cp ./package.json ./$PUBLISH_FOLDER
cp -r ./packages/ ./$PUBLISH_FOLDER/packages/
cp -r ./scripts/ ./$PUBLISH_FOLDER/scripts/
cp ./Gruntfile.js ./$PUBLISH_FOLDER
cp ./Procfile ./$PUBLISH_FOLDER
cp ./ofc.js ./$PUBLISH_FOLDER
if [ "$env" != "local" ]
then
    echo "Inject Production Auth"
    mv -f ./$PUBLISH_FOLDER/packages/node_modules/@node-red/editor-api/lib/auth/auth-prod.js ./$PUBLISH_FOLDER/packages/node_modules/@node-red/editor-api/lib/auth/auth.js
else
    echo "Skip Auth"
fi

cp ./Dockerfile ./$PUBLISH_FOLDER
cd ./$PUBLISH_FOLDER
npm i -D
npm run build

echo "obfuscating"
node ofc.js ./packages/node_modules/@node-red/editor-api/lib/auth/auth.js
node ofc.js ./packages/node_modules/@node-red/editor-api/lib/auth/index.js
node ofc.js ./packages/node_modules/@node-red/ignite-auth/authentication.js

rm -f ./ofc.js

rm -rf ./packages/node_modules/@node-red/editor-client/src

rm -rf ./node_modules/

echo "Published"
echo "Generate Docker Build"
docker build -t cybergroupignite/runtime:latest .
echo "Tag Docker Build : $version"
docker tag cybergroupignite/runtime:latest cybergroupignite/runtime:$version

if [ "$env" == "local" ]
then
    echo "Running $version on local docker"
    docker run --rm  -p 1881:1881 -e Storage=Local -e Project=enabled  cybergroupignite/runtime:$version
else
    echo "Publish $version on docker for $env"
    docker push cybergroupignite/runtime:"$version"
fi
if [ "$env" == "prod" ]
then
    echo "Publish $version on docker for $env"
    docker push cybergroupignite/runtime:latest
fi
rm -rf *