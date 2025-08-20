const messages = document.getElementById("messages");
const input = document.getElementById("input");
const send = document.getElementById("send");

function addMessage(text, who) {
  const b = document.createElement("div");
  b.className = "bubble " + (who === "me" ? "me" : "pandy");
  b.textContent = text;
  messages.appendChild(b);
  messages.scrollTop = messages.scrollHeight;
}

async function perguntarIA(pergunta) {
  try {
    const response = await fetch("/perguntar", {
      // <-- chama a API do FastAPI
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ pergunta }),
    });
    if (!response.ok) throw new Error("Erro HTTP: " + response.status);
    const data = await response.json();
    return data.resposta || "⚠️ Sem resposta";
  } catch (err) {
    return "❌ Erro: " + err.message;
  }
}

async function enviarMensagem() {
  const texto = input.value.trim();
  if (!texto) return;
  addMessage(texto, "me");
  input.value = "";
  const resposta = await perguntarIA(texto);
  addMessage(resposta, "pandy");
}

send.onclick = enviarMensagem;
input.addEventListener("keydown", (e) => {
  if (e.key === "Enter") enviarMensagem();
});

// Mensagem inicial
addMessage(
  "Olá! Eu sou o PANDY 🤖💜. Agora com expressões que voltam ao estado normal!",
  "pandy"
);
