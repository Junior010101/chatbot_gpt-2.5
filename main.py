from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse, JSONResponse
import uvicorn
import requests
import mysql.connector
import subprocess
import time
from openai import OpenAI
import os

# Conexão com o banco
conexao = mysql.connector.connect(
    host='localhost',
    user='root',
    password='12345678',
    database='chatbot_gpt'
)
cursor = conexao.cursor()

app = FastAPI()
client = OpenAI(base_url="http://localhost:8000/v1", api_key="not-needed")
app.mount("/static", StaticFiles(directory="Interface"), name="static")

ia_process = None
PORTA = 8000
URL_IA = f"http://localhost:{PORTA}/v1/completions"

# Caminho real do arquivo .gguf (onde está salvo no seu projeto)
MODELO_PATH = "/home/marcondes/Documentos/chatbot_gpt-2.5/modelos/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf"

# ID do modelo (igual ao nome do arquivo, será mostrado em /v1/models)
MODELO_ID = "tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf"

def iniciar_ia():
    global ia_process
    try:
        r = requests.get(f"http://localhost:{PORTA}/v1/models")
        if r.status_code == 200:
            print("✅ Servidor da IA já está rodando.")
            return
    except:
        pass

    print("🔄 Limpando possíveis instâncias antigas na porta", PORTA)
    try:
        subprocess.run(f"fuser -k {PORTA}/tcp", shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    except Exception as e:
        print(f"⚠️ Erro ao matar processos antigos: {e}")

    print("🚀 Iniciando servidor da IA local...")
    ia_process = subprocess.Popen([
        "python", "-m", "llama_cpp.server",
        "--model", MODELO_PATH,   # usa o caminho completo do modelo
        "--n_gpu_layers", "0",
        "--n_ctx", "2048",
        "--port", str(PORTA)
    ])
    if not esperar_ia_ficar_pronta():
        print("❌ Erro ao iniciar a IA.")
        exit(1)

def esperar_ia_ficar_pronta(timeout=120):
    print("⏳ Aguardando IA ficar pronta...")
    inicio = time.time()
    while time.time() - inicio < timeout:
        try:
            r = requests.get(f"http://localhost:{PORTA}/v1/models")
            if r.status_code == 200:
                print("✅ Servidor da IA está pronto.")
                return True
        except:
            pass
        time.sleep(2)

    print("❌ Tempo esgotado esperando a IA.")
    return False

def montar_prompt():
    cursor.execute("SELECT pergunta, resposta FROM interacoes ORDER BY id ASC")
    interacoes = cursor.fetchall()
    contexto = "Você é uma IA útil que responde sempre em Português do Brasil de forma direta e clara.\n\n"
    for perg, resp in interacoes:
        contexto += f"Usuário: {perg}\nIA: {resp}\n"
    return contexto

def limpar_terminal():
    os.system('cls' if os.name == 'nt' else 'clear')

@app.get("/")
def home():
    return FileResponse("Interface/index.html")

@app.post("/perguntar")
async def perguntar(request: Request):
    data = await request.json()
    pergunta = data.get("pergunta", "").strip()
    if not pergunta:
        return JSONResponse({"erro": "Pergunta vazia"}, status_code=400)

    try:
        # Carrega últimas 5 interações
        cursor.execute("SELECT pergunta, resposta FROM interacoes ORDER BY id DESC LIMIT 5")
        interacoes = cursor.fetchall()
        interacoes.reverse()  # mantém ordem cronológica

        # Monta histórico completo para resumo
        historico_texto = ""
        for perg, resp in interacoes:
            historico_texto += f"Usuário: {perg}\nIA: {resp}\n"

        # Prompt para gerar resumo automático
        prompt_resumo = f"Resuma o histórico abaixo em 2-3 frases, mantendo o sentido das interações:\n{historico_texto}\nResumo:"
        payload_resumo = {
            "model": MODELO_ID,
            "prompt": prompt_resumo,
            "max_tokens": 60,
            "temperature": 0.5
        }

        r_resumo = requests.post(URL_IA, json=payload_resumo, timeout=20)
        if r_resumo.status_code != 200:
            print("Erro ao gerar resumo:", r_resumo.status_code, r_resumo.text)
            resumo = ""  # se falhar, ignora resumo
        else:
            resumo = r_resumo.json()["choices"][0]["text"].strip()

        # Monta prompt final usando o resumo
        prompt_final = f"Você é uma IA útil que responde sempre em Português do Brasil de forma direta e clara.\nHistórico resumido: {resumo}\nUsuário: {pergunta}\nIA:"

        # Trunca prompt final para não ultrapassar limite
        if len(prompt_final) > 4000:
            prompt_final = prompt_final[-4000:]

        payload_final = {
            "model": MODELO_ID,
            "prompt": prompt_final,
            "max_tokens": 150,
            "temperature": 0.7
        }
        print("Payload enviado para a IA:", payload_final)

        r_final = requests.post(URL_IA, json=payload_final, timeout=20)
        if r_final.status_code != 200:
            print("Erro da IA:", r_final.status_code, r_final.text)
            return JSONResponse({"erro": f"Erro da IA: {r_final.text}"}, status_code=r_final.status_code)

        resposta = r_final.json()["choices"][0]["text"].strip()

        # Salva no banco
        cursor.execute(
            "INSERT INTO interacoes (pergunta, resposta) VALUES (%s, %s)",
            (pergunta, resposta)
        )
        conexao.commit()

        return {"resposta": resposta}

    except requests.Timeout:
        return JSONResponse({"erro": "Tempo esgotado ao chamar a IA"}, status_code=504)
    except requests.RequestException as e:
        return JSONResponse({"erro": f"Erro ao conectar com a IA: {e}"}, status_code=500)
    except Exception as e:
        return JSONResponse({"erro": str(e)}, status_code=500)

@app.get("/historico")
def historico():
    cursor.execute("SELECT id, pergunta, resposta, data FROM interacoes ORDER BY id DESC LIMIT 10")
    rows = cursor.fetchall()
    historico = [{"id": r[0], "pergunta": r[1], "resposta": r[2], "data": str(r[3])} for r in rows]
    return {"historico": historico}

if __name__ == "__main__":
    iniciar_ia()
    limpar_terminal()

    print("🚀 Servidor rodando em: http://127.0.0.1:5000")
    uvicorn.run("main:app", host="127.0.0.1", port=5000, reload=True)
