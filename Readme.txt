/* To run the client*/
cd client

install dependencies
npm install

npm run dev

http://localhost:3000

/* to run the backend code*/

The backend is at https://localhost:3001

cd server

install dependencies
npm install express cors body-parser @google/generative-ai dotenv


Create .env file 
add this entry for identifying API key for gemini

GEMINI_API_KEY='*****'

update the index,js file to use .env file

require("dotenv").config();

Start the backend server 
node index.js

open the site http://localhost:3001

✅ Test Flow
Visit http://localhost:3000

Enter a symptom like fever or headache

Answer 10 dynamic follow-up questions

View Gemini-powered diagnosis and treatment suggestions
