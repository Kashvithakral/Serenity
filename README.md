# Serenity - "Not just an app, a friend in your pocket.” (MVP)

An *AI-powered, confidential, and empathetic mental wellness solution* designed to support youth in overcoming stigma, expressing emotions safely, and accessing help when needed.  

This MVP combines *empathetic + logical AI chatbots, a **private journaling space, an integrated **helpline directory, and a **wellness zone* with engaging activities and mood-based music playlists.  

---

## ✨ Features

- 🤝 *Dual AI Chatbots* –  
  - Empathetic Bot: Active listening, emotional comfort  
  - Logical Bot: Practical guidance and coping strategies  

- 📓 *Private Journal* –  
  - Secure, confidential journaling with mood tagging  
  - Emotional trend insights  

- 📞 *Helpline Integration* –  
  - Direct call/text options to professional services  
  - Crisis support pathways  

- 🎮 *Wellness Zone* –  
  - Breathing game with calming visuals  
  - Wordhunt (positive affirmation words)  
  - Doodle pad with background music  

- 🎵 *Mood-based Music Playlists* –  
  - Personalized music based on current mood  
  - Spotify/YouTube API integration  

- 🔒 *Privacy by Design* –  
  - Encrypted storage of journals  
  - User control over personal data  

---

## 🏗 Architecture
1. Frontend (Flutter App)

-Cross-platform mobile app (Android & iOS).
-Provides UI for AI chatbots, journaling, wellness zone, and helpline access.
-Ensures smooth user experience with animations and background music support.



2. AI Engine (Google Gemini API)

-Powers the dual chatbots: empathetic and logical.
-natural language understanding, sentiment detection, and context awareness.
-Provides safe, stigma-sensitive conversational flows.



3. Backend & Database (Firebase)

-Firebase Authentication → secure user login/anonymous access.
-Firestore Database → stores journals, mood logs, and user preferences (with privacy controls).
-Firebase Cloud Functions → lightweight serverless backend for API orchestration.
-Firebase Cloud Messaging (FCM) → push notifications for reminders and nudges.



4. Development Tools

-Cline → used for AI-assisted development, debugging, and prototyping.
-Firebase Studio → app management, monitoring, and deployment.



5. External Integrations

-Optional APIs (Spotify/YouTube) for mood-based music.
-Helpline connections (call/text) directly from Flutter app.

---

## 🛠 Tech Stack

- *Frontend:* React Native (mobile), React (web)  
- *Backend:* Node.js + Express  
- *AI/ML:* Python, HuggingFace Transformers (NLP, sentiment & intent models)  
- *Database:* MongoDB (encrypted storage for journals & mood logs)  
- *Integrations:* Spotify API, YouTube API, Twilio/WhatsApp API, Push notifications  
- *Security:* JWT authentication, end-to-end encryption, privacy-first architecture  

---

## 💡 Problem Statement

- Youth often avoid mental health support due to *stigma, lack of privacy, and limited access*.  
- Existing tools feel too *clinical* or *detached from youth culture*.  
- Small struggles go unnoticed until they escalate into crises.  

---

## 🎯 Solution

- Confidential space with *empathetic AI support*  
- *Gamified, engaging wellness activities* that reduce stigma  
- *24/7 accessible help* through chatbots + helplines  
- *Mood-based personalization* (music, journaling insights)  

---

## 📊 Impact

- Reduces stigma by making support *relatable and private*  
- Encourages *early help-seeking* before problems escalate  
- Builds resilience through *micro-interventions* and self-care tools  
- Provides a bridge to *professional services* when needed  

---

## 🚀 Future Roadmap

- [ ] Add peer-support community with moderation  
- [ ] Expand multilingual support  
- [ ] AI personalization (adaptive coping strategies)  
- [ ] Partnerships with schools & NGOs for wider reach  
- [ ] Clinical validation through pilot testing  

---

## 📞 Helplines Disclaimer

This app is *not a substitute for professional help*.  
If you are in crisis, please reach out to your local emergency number or a trusted helpline immediately.  

---

## 👥 Team

- Team Name: SkyZen 
- Team Leader: Kashvi Thakral
- Hackathon: GenAI Exchange Hackathon  

---

## 📜 License

This project is licensed under the MIT License.
