# 🚗 ShieldCar - n8n Webhook para WhatsApp

Webhook permanente para notificações de leads no WhatsApp do grupo ShieldCar Blumenau.

## 🚀 Deploy Rápido no Railway

### Passo 1: Criar conta no Railway

1. Acesse: https://railway.app
2. Faça login com GitHub
3. Você ganha $5 de crédito grátis/mês

### Passo 2: Deploy Automático

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new)

**OU manualmente:**

1. No Railway, clique em **"+ New Project"**
2. Selecione **"Deploy from GitHub repo"**
3. Conecte este repositório: `juanfeminni-hub/shieldcar-n8n-webhook`
4. Railway detectará o Dockerfile automaticamente

### Passo 3: Adicionar PostgreSQL

1. No projeto, clique em **"+ New"**
2. Selecione **"Database"** → **"Add PostgreSQL"**
3. Railway criará automaticamente as variáveis de ambiente

### Passo 4: Configurar Variáveis de Ambiente

No Railway, vá em **"Variables"** e adicione:

```bash
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=ShieldCar2024!
N8N_PORT=5678
N8N_PROTOCOL=https
GENERIC_TIMEZONE=America/Sao_Paulo
EXECUTIONS_DATA_SAVE_ON_SUCCESS=all
```

### Passo 5: Gerar Domínio Público

1. No Railway, vá em **"Settings"** → **"Networking"**
2. Clique em **"Generate Domain"**
3. Copie a URL gerada (ex: `n8n-production-xxxx.up.railway.app`)

### Passo 6: Acessar n8n

1. Acesse: `https://sua-url.up.railway.app`
2. Login: `admin` / `ShieldCar2024!`

### Passo 7: Importar Workflow

1. No n8n, clique em **"+"** → **"Import from File"**
2. Selecione o arquivo: `workflow-shieldcar-leads.json`
3. Configure o nó do WhatsApp com sua API

## 📋 Configuração do WhatsApp

### Opção 1: Evolution API (Recomendado - Gratuito)

1. Instale Evolution API: https://evolution-api.com
2. Configure instância do WhatsApp
3. No workflow, use o endpoint da Evolution API

### Opção 2: WhatsApp Business API (Oficial)

1. Configure Meta Business: https://business.facebook.com
2. Obtenha token de acesso
3. Configure webhook no workflow

### Opção 3: Baileys (Simples)

1. Use biblioteca Baileys
2. QR Code scan
3. Envio direto

## 🔧 Estrutura do Webhook

**URL do Webhook:**
```
https://sua-url.up.railway.app/webhook/hubspot-lead
```

**Payload esperado:**
```json
{
  "firstname": "João",
  "lastname": "Silva",
  "email": "joao@email.com",
  "phone": "(47) 99999-9999",
  "city": "Blumenau",
  "state": "SC",
  "placa_veiculo": "ABC1234",
  "tipo_veiculo": "Carro",
  "marca_veiculo": "Toyota",
  "modelo_veiculo": "Corolla",
  "ano_veiculo": "2023"
}
```

**Resposta:**
- Status 200: Lead processado
- Notificação enviada ao WhatsApp

## 📊 Mensagem WhatsApp

```
🚗 *NOVO LEAD - ShieldCar Blumenau*

👤 *Cliente:* João Silva
📱 *Telefone:* (47) 99999-9999
📧 *Email:* joao@email.com
📍 *Localização:* Blumenau/SC

🚘 *Veículo:*
• Tipo: Carro
• Modelo: Toyota Corolla 2023
• Placa: ABC1234

⏰ *Recebido em:* 31/10/2024 às 00:30

✅ Entre em contato em até 2 minutos!
```

## 🔒 Segurança

- ✅ Autenticação básica ativada
- ✅ HTTPS obrigatório
- ✅ Webhook com ID único
- ✅ Logs de execução salvos

## 💰 Custos

**Railway (Estimado):**
- $5/mês de crédito grátis
- Uso real: ~$2-3/mês (baixo tráfego)
- PostgreSQL incluído

**Total:** Provavelmente **GRATUITO** com o crédito mensal

## 🆘 Suporte

### Testar Webhook

```bash
curl -X POST https://sua-url.up.railway.app/webhook/hubspot-lead \
  -H "Content-Type: application/json" \
  -d '{
    "firstname": "Teste",
    "lastname": "Sistema",
    "email": "teste@teste.com",
    "phone": "(47) 99999-9999",
    "city": "Blumenau",
    "state": "SC",
    "placa_veiculo": "TST1234",
    "tipo_veiculo": "Carro",
    "marca_veiculo": "Test",
    "modelo_veiculo": "Model",
    "ano_veiculo": "2024"
  }'
```

### Logs

Acesse logs em tempo real no Railway:
- **View Logs** no dashboard do projeto

### Troubleshooting

- **500 Error:** Verifique variáveis de ambiente
- **503 Error:** Container não iniciou, veja logs
- **WhatsApp não envia:** Verifique configuração da API

## 📝 Próximos Passos

Após deploy:

1. ✅ Copie a URL do webhook
2. ✅ Atualize `cotacao.html` linha 1015:
   ```javascript
   const webhookUrl = 'https://SUA-URL.up.railway.app/webhook/hubspot-lead';
   ```
3. ✅ Faça novo deploy do Netlify
4. ✅ Teste formulário completo

## 🔗 Links Úteis

- **Railway Dashboard:** https://railway.app/dashboard
- **n8n Docs:** https://docs.n8n.io
- **Evolution API:** https://evolution-api.com
- **WhatsApp Business:** https://business.facebook.com

---

**Desenvolvido para:** ShieldCar Blumenau
**Status:** ✅ Pronto para Produção
**Versão:** 1.0.0
