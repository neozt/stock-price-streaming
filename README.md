# stock-price-streaming

## Architecture

## Tech stack
1. Amazon AppSync Events
2. AlpineJS
3. AG Grid
4. SAM

## How to deploy
1. Make sure Node.js, Docker and SAM CLI are installed.
2. Run `aws configure` to configure your access key and secret.
3. Run `sam build` to build the application.
4. Run `sam deploy --config-env <dev|prod>` to deploy the application to AWS.
5. Run `.\deploy_frontend.ps1` to deploy the frontend website.

## How to teardown
1. Run `sam delete --config-env <dev|prod>` to delete the SAM application.
