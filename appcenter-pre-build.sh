#!/usr/bin/env bash

echo "export STAGING_APP_URL=$STAGING_APP_URL" > env-vars.sh
echo "export TESTING_APP_URL=$TESTING_APP_URL" >> env-vars.sh
echo "export PRODUCTION_APP_URL=$PRODUCTION_APP_URL" >> env-vars.sh
echo "export APPODEAL_KEY=$APPODEAL_KEY" >> env-vars.sh
echo "export STAGING_ADMOB_KEY=$STAGING_ADMOB_KEY" >> env-vars.sh
echo "export PRODUCTION_ADMOB_KEY=$PRODUCTION_ADMOB_KEY" >> env-vars.sh
echo "export STAGING_ADMOB_UNIT_ID=$STAGING_ADMOB_UNIT_ID" >> env-vars.sh
echo "export PRODUCTION_ADMOB_UNIT_ID=$PRODUCTION_ADMOB_UNIT_ID" >> env-vars.sh
echo "export STRIPE_KEY=$STRIPE_KEY" >> env-vars.sh

echo "\n.env-vars created with contents:\n"
cat env-vars.sh

npm config delete prefix
