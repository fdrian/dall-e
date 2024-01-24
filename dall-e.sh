#!/bin/bash
# by @fdr1an

# Verifica se um parâmetro foi fornecido
if [ $# -eq 0 ]; then
    echo "No prompt provided. Usage: ./dall-e.sh <prompt>"
    exit 1
fi

# Usa o parâmetro como o prompt
user_prompt=$1

# Faz a requisição CURL com a entrada do usuário e armazena a resposta
echo "Processing..."
response=$(curl -s https://api.openai.com/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d "{
    \"model\": \"dall-e-3\",
    \"prompt\": \"$user_prompt\",
    \"n\":1,
    \"size\":\"1024x1024\"
   }")

# Usa o comando 'jq' para extrair a URL da resposta JSON
url=$(echo $response | jq -r '.data[0].url')

# Cria a pasta 'imagine' se ela não existir
mkdir -p imagine

# Gera um timestamp
timestamp=$(date +%Y%m%d%H%M%S)

# Baixa a imagem para a pasta 'imagine' com um nome de arquivo único
curl -s -o imagine/image_$timestamp.png $url

# Exibe a imagem usando 'xdg-open'
xdg-open imagine/image_$timestamp.png