import traceback
from flask import Flask, request
import datetime
import os 

app = Flask(__name__)

if not (os.path.exists('dados')):
    os.makedirs('dados')

@app.route('/')
def home():
    return "Servidor Flask está online!", 200

@app.route('/receber', methods=['POST'])
def receber_dados():
    try:
        dados = request.get_json()

        agora = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        nome_arquivo = os.path.join("dados", f"specs_{agora}.txt")

        with open(nome_arquivo, 'w', encoding='utf-8') as f:
            f.write(str(dados))


        return "Dados recebidos com sucesso!", 200
    except Exception as e:
        print(f"Erro ao receber dados: {e}")
        traceback.print_exc()
    return "Erro ao receber dados", 500
    

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
