/**
 * J.A.R.V.I.S. – Cloudflare Worker (Groq Edition)
 * ────────────────────────────────────────────────
 * Endpoints:
 *   POST /chat   → llama a Groq y devuelve {content:[{type:"text",text:"..."}]}
 *   POST /tts    → 404 → el frontend cae en browser speechSynthesis (gratis)
 *   POST /image  → 404 por ahora
 *
 * Variable de entorno requerida en Cloudflare:
 *   GROQ_KEY  →  tu API key de console.groq.com  (gratis, sin tarjeta)
 */

const CORS = {
  "Access-Control-Allow-Origin":  "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
};

export default {
  async fetch(request, env) {
    // Preflight CORS
    if (request.method === "OPTIONS") {
      return new Response(null, { status: 204, headers: CORS });
    }

    const url = new URL(request.url);

    // ── /chat ──────────────────────────────────────────────
    if (url.pathname === "/chat" && request.method === "POST") {
      try {
        const body = await request.json();
        const { messages = [], system = "" } = body;

        // Construir mensajes para Groq (formato OpenAI)
        const groqMessages = [];
        if (system) {
          groqMessages.push({ role: "system", content: system });
        }
        for (const m of messages) {
          groqMessages.push({ role: m.role, content: m.content });
        }

        const groqRes = await fetch("https://api.groq.com/openai/v1/chat/completions", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${env.GROQ_KEY}`,
          },
          body: JSON.stringify({
            model: "llama3-8b-8192",   // gratis y rápido
            messages: groqMessages,
            max_tokens: 1024,
            temperature: 0.85,
          }),
        });

        if (!groqRes.ok) {
          const err = await groqRes.text();
          return new Response(
            JSON.stringify({ error: "Groq error", detail: err }),
            { status: 502, headers: { ...CORS, "Content-Type": "application/json" } }
          );
        }

        const data = await groqRes.json();
        const text = data.choices?.[0]?.message?.content ?? "Error en el sistema central.";

        // Devolver en formato Anthropic para que el frontend no necesite cambios
        return new Response(
          JSON.stringify({ content: [{ type: "text", text }] }),
          { status: 200, headers: { ...CORS, "Content-Type": "application/json" } }
        );

      } catch (e) {
        return new Response(
          JSON.stringify({ error: e.message }),
          { status: 500, headers: { ...CORS, "Content-Type": "application/json" } }
        );
      }
    }

    // ── /tts  (no implementado → browser fallback) ─────────
    if (url.pathname === "/tts") {
      return new Response(
        JSON.stringify({ error: "TTS no disponible — usando síntesis del navegador" }),
        { status: 404, headers: { ...CORS, "Content-Type": "application/json" } }
      );
    }

    // ── /image (no implementado aún) ───────────────────────
    if (url.pathname === "/image") {
      return new Response(
        JSON.stringify({ error: "Generación de imágenes no disponible en plan actual" }),
        { status: 404, headers: { ...CORS, "Content-Type": "application/json" } }
      );
    }

    // ── Ruta desconocida ───────────────────────────────────
    return new Response(
      JSON.stringify({ status: "J.A.R.V.I.S. Worker online", endpoints: ["/chat"] }),
      { status: 200, headers: { ...CORS, "Content-Type": "application/json" } }
    );
  },
};
