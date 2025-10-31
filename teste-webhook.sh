#!/bin/bash

# Teste do Webhook ShieldCar - n8n + ManyChat + HubSpot
# Data: 31/10/2024

echo "🚀 Testando webhook ShieldCar..."
echo ""
echo "📍 URL: https://starken.app.n8n.cloud/webhook/c7fef93a-ac2b-4871-b217-73c085f181d8"
echo "📱 Telefone teste: +5547992752697"
echo ""

curl -X POST https://starken.app.n8n.cloud/webhook/c7fef93a-ac2b-4871-b217-73c085f181d8 \
  -H "Content-Type: application/json" \
  -d '{
    "firstname": "Teste",
    "lastname": "ShieldCar",
    "email": "teste@shieldcar.com.br",
    "phone": "47992752697",
    "city": "Blumenau",
    "state": "SC",
    "placa_veiculo": "TST1234",
    "tipo_veiculo": "Carro",
    "marca_veiculo": "Toyota",
    "modelo_veiculo": "Corolla",
    "ano_veiculo": "2024"
  }'

echo ""
echo ""
echo "✅ Requisição enviada!"
echo ""
echo "📋 Próximos passos:"
echo "1. Verifique a execução no n8n (Executions)"
echo "2. Confira se o contato foi criado no HubSpot"
echo "3. Verifique se o contato aparece no ManyChat"
echo "4. Cheque se recebeu mensagem no WhatsApp: +5547992752697"
echo ""
