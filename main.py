import subprocess
import time
import unicodedata
import requests
from openai import OpenAI
import mysql.connector
import os

# Configuração do banco
conexao = mysql.connector.connect(
    host='localhost',
    user='root',
    password='12345678',
    database='chatbot_gpt'
)
cursor = conexao.cursor()

# Cliente OpenAI apontando pro backend local
client = OpenAI(base_url="http://localhost:8000/v1", api_key="not-needed")

ia_process = None
MODELO_PATH = "modelos/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf"
PORTA = 8000

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
        "--model", MODELO_PATH,
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

def limpar_pergunta(texto):
    texto = texto.replace('"', "'")
    texto = unicodedata.normalize('NFKC', texto)
    return texto.strip()

def limpar_terminal():
    os.system('cls' if os.name == 'nt' else 'clear')

def perguntar_ia(pergunta: str) -> str:
    try:
        modelos = requests.get(f"http://localhost:{PORTA}/v1/models").json().get("data", [])
        if not modelos:
            return "❌ Nenhum modelo disponível no servidor."
        modelo = modelos[0]["id"]
    except Exception as e:
        return f"❌ Erro ao obter modelos: {e}"

    try:
        # Usa chat completions (mais adequado para chat)
        response = client.chat.completions.create(
            model=modelo,
            messages=[{"role": "user", "content": pergunta}],
            max_tokens=100,
            temperature=0.7
        )
        print("DEBUG RESPONSE RAW:", response)
        return response.choices[0].message.content.strip()
    except Exception as e:
        return f"❌ Erro ao consultar IA: {str(e)}"

def mostrar_historico():
    cursor.execute("SELECT id, pergunta, data FROM interacoes ORDER BY id DESC LIMIT 5")
    rows = cursor.fetchall()
    for row in rows:
        print(f"[{row[2]}] (#{row[0]}) {row[1]}")

def mostrar_interacao(id_interacao):
    cursor.execute("SELECT pergunta, resposta FROM interacoes WHERE id = %s", (id_interacao,))
    row = cursor.fetchone()
    if row:
        print("\n[🔁 Pergunta antiga]\n" + row[0])
        print("\n[💬 Resposta da época]\n" + row[1])
    else:
        print("ID não encontrado.")

def main():
    global ia_process
    iniciar_ia()
    limpar_terminal()

    while True:
        print("🤖 IA de Terminal:")
        print("""
======== MENU ========
1 - Enviar pergunta para IA
2 - Mostrar histórico recente
3 - Mostrar interação por ID
0 - Sair
        """)
        opcao = input("Escolha uma opção: ").strip()

        if opcao == "1":
            pergunta = limpar_pergunta(input("Digite sua pergunta: "))
            resposta = perguntar_ia(pergunta)
            print("\n🤖 Resposta:\n", resposta)

            cursor.execute(
                "INSERT INTO interacoes (pergunta, resposta) VALUES (%s, %s)",
                (pergunta, resposta)
            )
            conexao.commit()

        elif opcao == "2":
            mostrar_historico()

        elif opcao == "3":
            id_busca = input("Digite o ID da interação: ").strip()
            if id_busca.isdigit():
                mostrar_interacao(int(id_busca))
            else:
                print("ID inválido.")

        elif opcao == "0":
            print("Encerrando...")
            if ia_process:
                print("⏹️ Encerrando servidor da IA...")
                ia_process.terminate()
                ia_process.wait()
                print("✅ IA encerrada.")
            break
        else:
            print("Opção inválida.")

        input("\nPressione Enter para continuar...")
        limpar_terminal()

if __name__ == "__main__":
    main()
