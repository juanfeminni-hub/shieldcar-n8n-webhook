# 🚀 Quick Start - ShieldCar + ManyChat

Guia rápido de 5 minutos para começar!

## 🎯 O que você vai fazer

1. ✅ Deploy do n8n no Railway (3 min)
2. ✅ Importar workflow ManyChat (1 min)
3. ✅ Configurar API do ManyChat (1 min)
4. ✅ Testar integração (30 seg)

**Tempo total: ~5 minutos**

---

## ⚡ Passo a Passo Super Rápido

### 1. Deploy no Railway

```bash
# Opção A: Botão mágico ✨
```
[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template?template=https://github.com/juanfeminni-hub/shieldcar-n8n-webhook)

**OU**

```bash
# Opção B: Via CLI
railway login
railway init
railway add postgresql
railway up
railway domain  # Copie a URL gerada
```

### 2. Configurar Variáveis (no Railway)

```env
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=ShieldCar2024!
N8N_PORT=5678
N8N_PROTOCOL=https
GENERIC_TIMEZONE=America/Sao_Paulo
EXECUTIONS_DATA_SAVE_ON_SUCCESS=all
```

### 3. Obter Token do ManyChat

1. https://manychat.com → Login
2. **Settings** → **API** → **Generate Key**
3. Copie o token (começa com `Bearer ...`)

### 4. Importar Workflow

1. Acesse: `https://sua-url.railway.app`
2. Login: `admin` / `ShieldCar2024!`
3. **Menu** → **Import from File**
4. Selecione: `workflow-shieldcar-manychat.json`

### 5. Configurar Token (3 lugares)

Nos nós abaixo, substitua `SEU_MANYCHAT_API_TOKEN`:

1. **"Criar Contato ManyChat"** → Headers → Authorization
2. **"Enviar Mensagem Boas-vindas"** → Headers → Authorization
3. **"Notificar Equipe"** → Headers → Authorization

Cole: `Bearer seu_token_real_aqui`

### 6. Ativar Workflow

1. Botão **"Active"** (canto superior direito)
2. Copie a **Webhook URL**

### 7. Atualizar Landing Page

No seu arquivo HTML:

```javascript
const webhookUrl = 'https://sua-url.railway.app/webhook/shieldcar-lead';
```

### 8. Testar! 🎉

```bash
curl -X POST https://sua-url.railway.app/webhook/shieldcar-lead \
  -H "Content-Type: application/json" \
  -d '{
    "firstname": "Teste",
    "lastname": "ShieldCar",
    "email": "teste@teste.com",
    "phone": "47999999999",
    "city": "Blumenau",
    "state": "SC",
    "placa_veiculo": "TST1234",
    "tipo_veiculo": "Carro",
    "marca_veiculo": "Toyota",
    "modelo_veiculo": "Corolla",
    "ano_veiculo": "2024"
  }'
```

**Se retornar `{"success": true}` → FUNCIONOU! 🎊**

---

## 🆘 Problemas Comuns

### ❌ "Invalid API Token"
→ Verifique se copiou o token completo (incluindo `Bearer`)

### ❌ "Subscriber not found"
→ Telefone precisa ter formato: `+5547999999999` (com +55)

### ❌ Workflow não ativa
→ Verifique se todos os 3 nós têm o token configurado

### ❌ Landing page não envia
→ Verifique se atualizou a URL do webhook no código

---

## 📚 Próximos Passos

Agora que está funcionando:

1. **[Guia Completo ManyChat](INTEGRACAO-MANYCHAT.md)** - Configurações avançadas
2. **[Deploy Railway](DEPLOY-RAILWAY.md)** - Detalhes do deploy
3. **README.md** - Documentação completa

---

## 💬 Mensagens Enviadas

### Para o Lead:
```
🚗 *Olá [Nome]!*

Obrigado pelo interesse na *ShieldCar Blumenau*! 🛡️

Recebemos seus dados do veículo:
• [Marca Modelo Ano]
• Placa: [ABC1234]

Em breve um de nossos consultores entrará em contato!

📱 Fique à vontade para tirar dúvidas por aqui!
```

### Para a Equipe:
```
🚗 *NOVO LEAD - ShieldCar Blumenau*

👤 *Cliente:* [Nome Completo]
📱 *Telefone:* [Número]
📧 *Email:* [Email]
📍 *Localização:* [Cidade/Estado]

🚘 *Veículo:*
• Tipo: [Tipo]
• Modelo: [Marca Modelo Ano]
• Placa: [Placa]

⏰ *Recebido em:* [Data/Hora]

✅ Entre em contato em até 2 minutos!
```

---

**🎯 Tudo pronto! Seus leads agora vão direto para o WhatsApp via ManyChat!**

---

**Desenvolvido para:** ShieldCar Blumenau
**Versão:** 1.0.0
**Status:** ✅ Produção
