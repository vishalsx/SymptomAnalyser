#!/bin/bash

# Title: Start both frontend and backend for Patient Symptoms Analyzer

echo "🔧 Installing backend dependencies..."
cd server
npm install

echo "🚀 Starting backend server..."
npm run start &

cd ..

echo "🔧 Installing frontend dependencies..."
cd client
npm install

echo "🌐 Starting frontend UI..."
npm run dev

