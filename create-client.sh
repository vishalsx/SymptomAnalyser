#!/bin/bash

echo "🚀 Creating Vite + React + TypeScript project: client"
npm create vite@latest client -- --template react-ts
cd client || exit

echo "📦 Installing dependencies"
npm install

echo "🎨 Setting up TailwindCSS"
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# Configure Tailwind
cat > tailwind.config.js <<EOF
module.exports = {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {},
  },
  plugins: [],
};
EOF

# Add Tailwind to global styles
cat > src/index.css <<EOF
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

echo "📁 Creating folders: components, pages, services, types"
mkdir -p src/components src/pages src/services src/types

echo "🧩 Creating core files"

# App.tsx
cat > src/App.tsx <<'EOF'
import { useState } from "react";
import Home from "./pages/Home";

function App() {
  return <Home />;
}

export default App;
EOF

# main.tsx
cat > src/main.tsx <<'EOF'
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.tsx";
import "./index.css";

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOF

# Home.tsx
cat > src/pages/Home.tsx <<'EOF'
import { useState } from "react";
import QuestionForm from "../components/QuestionForm";
import DiagnosisResult from "../components/DiagnosisResult";

const Home = () => {
  const [symptom, setSymptom] = useState("");
  const [questions, setQuestions] = useState<string[]>([]);
  const [answers, setAnswers] = useState<string[]>([]);
  const [result, setResult] = useState("");

  const startDiagnosis = async () => {
    const res = await fetch("http://localhost:3001/start", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ symptom }),
    });
    const data = await res.json();
    setQuestions(data.questions);
  };

  const submitAnswers = async () => {
    const res = await fetch("http://localhost:3001/diagnose", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ answers }),
    });
    const data = await res.json();
    setResult(data.diagnosis);
  };

  return (
    <div className="max-w-2xl mx-auto p-4">
      <h1 className="text-2xl font-bold mb-4">Patient Symptoms Analyzer</h1>
      <input
        className="border px-3 py-2 w-full mb-2"
        placeholder="Enter your symptom"
        value={symptom}
        onChange={(e) => setSymptom(e.target.value)}
      />
      <button
        className="bg-blue-500 text-white px-4 py-2 rounded"
        onClick={startDiagnosis}
      >
        Start
      </button>

      {questions.length > 0 && (
        <QuestionForm
          questions={questions}
          answers={answers}
          setAnswers={setAnswers}
          onSubmit={submitAnswers}
        />
      )}

      {result && <DiagnosisResult result={result} />}
    </div>
  );
};

export default Home;
EOF

# QuestionForm.tsx
cat > src/components/QuestionForm.tsx <<'EOF'
interface Props {
  questions: string[];
  answers: string[];
  setAnswers: (a: string[]) => void;
  onSubmit: () => void;
}

const QuestionForm = ({ questions, answers, setAnswers, onSubmit }: Props) => {
  const handleChange = (index: number, value: string) => {
    const updated = [...answers];
    updated[index] = value;
    setAnswers(updated);
  };

  return (
    <div className="mt-4">
      <h2 className="text-lg font-semibold">Answer the following questions:</h2>
      {questions.map((q, i) => (
        <div key={i} className="mb-2">
          <label className="block mb-1">{q}</label>
          <input
            className="border px-2 py-1 w-full"
            value={answers[i] || ""}
            onChange={(e) => handleChange(i, e.target.value)}
          />
        </div>
      ))}
      <button
        className="mt-4 bg-green-600 text-white px-4 py-2 rounded"
        onClick={onSubmit}
      >
        Submit Answers
      </button>
    </div>
  );
};

export default QuestionForm;
EOF

# DiagnosisResult.tsx
cat > src/components/DiagnosisResult.tsx <<'EOF'
const DiagnosisResult = ({ result }: { result: string }) => {
  return (
    <div className="mt-6 p-4 bg-gray-100 border rounded">
      <h3 className="font-bold mb-2">Diagnosis & Recommendation:</h3>
      <pre className="whitespace-pre-wrap">{result}</pre>
    </div>
  );
};

export default DiagnosisResult;
EOF

# api.ts
cat > src/services/api.ts <<'EOF'
// Placeholder API helpers (not used in this version)
export const API_BASE = "http://localhost:3001";
EOF

# types/index.ts
cat > src/types/index.ts <<'EOF'
export interface Question {
  id: number;
  text: string;
}
EOF

echo "✅ Client setup complete!"
echo "👉 To run the app:"
echo "   cd client"
echo "   npm run dev"

