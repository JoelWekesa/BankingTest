After cloning this project,

1. Database configuration
   a. Install Postgres and PgAdmin
   b. Create a database with the name BankingTest
   c. Download the database tables from the dump I sent you

2. Sever side configuration
   a. Download and install node and npm
   b. cd into the cloned project folder
   c. cd into Server
   d. create a .env file in this directory
   e. your env file should include the following: 
        dbname=BankingTest
        dbuser=postgres
        dbpassword=Enter you user password
   f. run this command - npm install -g nodemon
   g. run this command - npm install
   h. run this command to start the server - npm run dev

3. App configuration
   a. open a new terminal
   b. cd into the cloned project folder
   c. cd into banking_testapp
   d. run this command - flutter clean
   e. run this command - flutter pub get
   f. start your virtual device - either android or ios
   g. run this command - flutter run

Enjoy the app.
