# J.A.R.V.I.S.

> **Just A Rather Very Intelligent System** — Asistente virtual web con estética Iron Man.

![JARVIS Logo](public/logo.svg)

---

## ¿Qué es?

JARVIS es un asistente virtual web tipo PWA (Progressive Web App). Funciona en:

- 🌐 **Navegador** — escritorio y móvil
- 📱 **Android** — se instala desde Chrome con un toque (se ve como una app nativa)
- 🍎 **iOS (Safari)** — se agrega a pantalla de inicio

## Demo

[https://proyecto-jarvis-05s12ev.web.app](https://proyecto-jarvis-05s12ev.web.app)

## Características

- 💬 Chat con IA (Pollinations.ai sin key · o tu propia key gratis de Groq)
- 🎙️ Reconocimiento de voz (Web Speech API)
- 🔊 Voz de respuesta (Web Speech / opcional ElevenLabs)
- 🔐 Login con Google + historial en Firestore (opcional)
- 🟢 Modo invitado (sin cuenta) — funciona inmediatamente
- 🔴 **Modo Super JARVIS** — colores Iron Man (escribe `Modo Super JARVIS: ON`)
- 💠 Sistema de planes (Gratuito · Plus · Platino · Diamante)
- 🎫 Licencias Stark Industries (formato `STARK-INDUSTRIES-XXXXXXXXX`)

## Cómo usar JARVIS desde el celular

1. Abre [https://proyecto-jarvis-05s12ev.web.app](https://proyecto-jarvis-05s12ev.web.app) en Chrome Android.
2. Menú ⋮ → **"Agregar a la pantalla de inicio"** o **"Instalar app"**.
3. JARVIS aparece como aplicación nativa con su logo.
4. Para que JARVIS funcione como asistente virtual del sistema (al mantener el botón de inicio), se necesita el **APK** — ver carpeta `jarvis-android/` en este repo.

## Estructura

```
jarvis-app/
├── public/
│   ├── index.html      → la app entera (HTML + CSS + JS inline)
│   ├── logo.svg        → logo oficial JARVIS
│   └── manifest.json   → PWA manifest (para instalar en Android)
├── firebase.json       → configuración de Firebase Hosting
├── desplegar-jarvis.bat → script Windows para `firebase deploy`
└── jarvis-worker-groq.js → Cloudflare Worker (proxy opcional, para producción dura)
```

## Despliegue local (Windows)

```bat
:: instalar Firebase CLI (una vez)
npm install -g firebase-tools

:: login en Firebase
firebase login

:: desplegar
firebase deploy --only hosting
```

O simplemente doble clic en `desplegar-jarvis.bat`.

## Configuración del motor de IA

Por defecto JARVIS usa **Pollinations.ai** (gratis, sin auth).
Para mejor calidad, configura una API key gratis de Groq:

1. Crear cuenta en [console.groq.com](https://console.groq.com) → **Create API Key**
2. En JARVIS: menú ☰ → **"🔑 Configurar API key (Groq)"** → pegar
3. JARVIS empieza a usar `llama-3.3-70b-versatile` automáticamente

## Stack

- HTML5 + CSS3 + Vanilla JavaScript (1 archivo, ~1500 líneas)
- Firebase Hosting (gratis)
- Firebase Authentication + Firestore (opcional)
- Pollinations.ai / Groq API (IA)
- Cloudflare Workers (proxy opcional)

## Licencia

Proyecto personal de Santiago Esquivel.
Inspirado en J.A.R.V.I.S. de Iron Man (Marvel / Disney). Solo uso educativo y personal.

---

*"Sometimes you gotta run before you can walk."* — Tony Stark
