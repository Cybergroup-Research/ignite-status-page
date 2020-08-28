echo "Build Version:"$1
echo RUNTIME_VERSION=$1 >> .env

mv -f ./packages/node_modules/@node-red/editor-api/lib/auth/auth-prod.js ./packages/node_modules/@node-red/editor-api/lib/auth/auth.js

echo "Installing Dev Dependencies"
npm install
npm run build

echo "obfuscating"
node ofc.js ./packages/node_modules/@node-red/editor-api/lib/auth/
node ofc.js ./packages/node_modules/@node-red/ignite/
node ofc.js ./packages/node_modules/cg/

npm install --production