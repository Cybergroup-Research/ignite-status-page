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
mv -f ./$PUBLISH_FOLDER/packages/node_modules/@node-red/editor-api/lib/auth/auth-prod.js ./$PUBLISH_FOLDER/packages/node_modules/@node-red/editor-api/lib/auth/auth.js
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
