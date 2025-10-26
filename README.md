# Kaamsetu
# 🌾 KaamSetu – Rural Labor Exchange & Mediation App

### Team: **AI for Goods**

> Empowering India’s rural workforce with AI-driven job matching, voice assistance, and Panchayat-verified trust.

---

## 📖 Overview

**KaamSetu** bridges the gap between **rural workers** and **local employers** through an **AI-powered job exchange** and **community mediation platform**.

The app enables **daily wage laborers** and **small contractors** to connect, verify, and collaborate — even in **low-connectivity rural areas**, through **offline and SMS-based access**.

---

## 💡 Problem Statement

- Over 80% of India’s rural workforce still depends on word-of-mouth for daily wage jobs.  
- Rural unemployment stands at ~7.4% (CMIE, 2024).  
- No organized or trusted digital platform exists for rural labor exchange.  
- Workers face payment disputes, fraud, and lack of skill recognition.  
- Urban-focused job portals exclude rural and semi-skilled workers.

---

## 👥 Target Audience

| Type | Description |
|------|--------------|
| **Primary Users (B2C)** | Rural and semi-urban daily wage workers: farmers, masons, carpenters, artisans, construction workers (age 18–50). |
| **Secondary Users (B2B / Governance)** | Local employers (contractors, MSMEs), Panchayats, NGOs for worker verification and dispute mediation. |

---

## ⚙️ Key Features

- 🤖 **AI Skill-Match Engine** – Matches jobs based on skills, location & wage preference.  
- 📱 **Offline + SMS Access** – Works seamlessly without internet via Gupshup/Twilio API.  
- ✅ **Verified Worker Profiles** – Panchayat-level digital verification builds community trust.  
- 🗣️ **AI Voice Assistant** – Natural, multilingual interaction for low-literacy users.  
- ⚖️ **Community Mediation** – Local dispute resolution between workers and employers.  
- 🌍 **Multi-Language Support** – Auto-translates job posts and worker profiles.

---

## 🧠 Why It’s Unique

| Existing Platforms | **KaamSetu Advantage** |
|--------------------|------------------------|
| Focused on urban, skilled jobs | Built for rural & unorganized workforce |
| Requires full internet | Works offline / via SMS |
| No verification system | Panchayat & community verified |
| Static job listings | AI-driven smart recommendations |

---

## 🧩 Tech Stack

| Layer | Tools / Frameworks | Description |
|-------|---------------------|-------------|
| **Frontend** | Flutter / React.js | Cross-platform app + web UI (works offline) |
| **Backend / APIs** | FastAPI (Python) / Node.js | Authentication, data handling, matching |
| **Database** | Firebase Firestore / PostgreSQL | Stores users, jobs, verification data |
| **AI Engine** | Python (scikit-learn / TensorFlow Lite) | Skill & location-based matching |
| **Messaging Layer** | Twilio / Gupshup API | SMS alerts & verification |
| **Admin Dashboard** | React Admin / Streamlit | Panchayat-level verification & analytics |
| **Cloud Hosting** | Google Cloud / AWS | Backend & ML model deployment |
| **Voice Assistant** | Dialogflow / TensorFlow Lite | Multilingual voice commands |

---

## 🏗️ Architecture

```text
[User App / SMS Interface]  
        ↓  
[API Gateway / FastAPI Backend]  
        ↓  
[Database + AI Matching Engine]


🧰 Setup Instructions
1. Clone the repository
git clone https://github.com/<your-username>/KaamSetu.git
cd KaamSetu
2. Backend Setup
cd backend
pip install -r requirements.txt
uvicorn main:app --reload
3. Frontend Setup
cd frontend
flutter pub get
flutter run
4. Firebase Configuration
Add your Firebase config file to /frontend/lib/firebase_options.dart
Enable Firestore, Authentication, and Cloud Functions.
5. SMS Integration
Create a Twilio or Gupshup account.
Add credentials in .env:
6. AI Model
Place trained model in /ml_model/kaamsetu_model.pkl
The model runs using TensorFlow Lite or scikit-learn.

❤️ Built for AI for Goods Hackathon 2025
“Empowering rural livelihoods through AI, accessibility, and trust.”
        ↓  
[Panchayat / Admin Dashboard]
