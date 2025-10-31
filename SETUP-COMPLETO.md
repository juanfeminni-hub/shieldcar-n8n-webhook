# 🚀 Setup Completo - ShieldCar (ManyChat + HubSpot)

Guia passo a passo para configurar a integração completa.

## 🎯 Arquitetura

```
┌─────────────────┐
│  Formulário     │
│  Landing Page   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   n8n Webhook   │
│   (Railway)     │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌────────┐ ┌──────────┐
│ManyChat│ │ HubSpot  │
│WhatsApp│ │   CRM    │
└────────┘ └──────────┘
    │
    ├─► Lead recebe boas-vindas
    └─► Equipe é notificada
```

---

## 📝 Checklist Pré-requisitos

Antes de começar, você precisa:

- [ ] Conta no **Railway** (https://railway.app)
- [ ] Conta no **ManyChat** (https://manychat.com)
- [ ] Conta no **HubSpot** (https://hubspot.com)
- [ ] Acesso ao código do **formulário** da landing page

---

## 🚀 Passo 1: Deploy do n8n no Railway

### 1.1 Criar Projeto

**Opção A - Template Automático:**
1. Acesse: https://railway.app/new
2. Clique em **"Deploy from GitHub repo"**
3. Conecte: `juanfeminni-hub/shieldcar-n8n-webhook`
4. Clique **"Deploy"**

**Opção B - Manual:**
```bash
railway login
railway init
railway up
```

### 1.2 Adicionar PostgreSQL

1. No projeto Railway, clique **"+ New"**
2. Selecione **"Database"** → **"PostgreSQL"**
3. Aguarde ~30 segundos para inicializar

### 1.3 Configurar Variáveis de Ambiente

Vá em **Variables** e adicione:

```env
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=ShieldCar2024!
N8N_PORT=5678
N8N_PROTOCOL=https
GENERIC_TIMEZONE=America/Sao_Paulo
EXECUTIONS_DATA_SAVE_ON_SUCCESS=all
EXECUTIONS_DATA_SAVE_ON_ERROR=all
```

### 1.4 Gerar Domínio Público

1. **Settings** → **Networking**
2. **"Generate Domain"**
3. **COPIE A URL** (ex: `n8n-production-abc123.up.railway.app`)

📋 **Guarde essa URL - você vai precisar!**

### 1.5 Aguardar Deploy

Aguarde ~2-3 minutos até aparecer **"Success"** nos logs.

---

## 🔐 Passo 2: Obter Credenciais

### 2.1 API Token do ManyChat

1. Acesse: https://manychat.com
2. **Settings** → **API**
3. **"Generate API Key"**
4. Copie o token (formato: `Bearer abc123...`)

📋 **Guarde o token ManyChat**

### 2.2 Criar Custom Fields no ManyChat

1. **Audience** → **Custom Fields** → **"+ New Field"**
2. Crie estes campos (tipo: Text):
   - `email`
   - `cidade`
   - `estado`
   - `veiculo`
   - `placa`
   - `tipo_veiculo`

### 2.3 Obter Subscriber ID da Equipe (ManyChat)

**Opção A - Via Dashboard:**
1. **Audience** → **All Contacts**
2. Encontre o contato que receberá notificações
3. Clique nele → copie o ID da URL
4. Ex: `manychat.com/contacts/123456789` → ID = `123456789`

**Opção B - Via API:**
```bash
curl -X GET "https://api.manychat.com/fb/subscriber/getInfo?phone=+5547999999999" \
  -H "Authorization: Bearer SEU_TOKEN_MANYCHAT"
```

📋 **Guarde o Subscriber ID**

### 2.4 OAuth do HubSpot

1. Acesse seu n8n: `https://sua-url.railway.app`
2. Login: `admin` / `ShieldCar2024!`
3. **Credentials** → **"+ Create New"**
4. Tipo: **"HubSpot OAuth2 API"**
5. Clique em **"Connect my account"**
6. Autorize no HubSpot
7. Salve as credenciais com nome: **"HubSpot ShieldCar"**

### 2.5 Criar Custom Properties no HubSpot (se necessário)

No HubSpot, vá em **Settings** → **Properties** → **Contact Properties**

Certifique-se que existem:
- `firstname` ✅ (padrão)
- `lastname` ✅ (padrão)
- `email` ✅ (padrão)
- `phone` ✅ (padrão)
- `city` ✅ (padrão)
- `state` ✅ (padrão)
- `placa_veiculo` ⚠️ (criar se não existir)
- `tipo_veiculo` ⚠️ (criar se não existir)
- `veiculo` ⚠️ (criar se não existir)

**Como criar:**
1. **"Create property"**
2. Nome: `placa_veiculo`, Type: **Single-line text**
3. Repetir para `tipo_veiculo` e `veiculo`

---

## ⚙️ Passo 3: Importar e Configurar Workflow

### 3.1 Importar Workflow

1. No n8n: **Menu (≡)** → **"Import from File"**
2. Selecione: `workflow-shieldcar-completo.json`
3. Clique **"Import"**

### 3.2 Configurar Credenciais ManyChat

Configure nos seguintes nós:

#### Nó: "ManyChat - Criar Contato"
1. Clique no nó
2. **Headers Parameters** → **Authorization**
3. Substitua `SEU_MANYCHAT_API_TOKEN` por: `Bearer seu_token_aqui`

#### Nó: "ManyChat - Mensagem Boas-vindas"
1. Clique no nó
2. **Headers Parameters** → **Authorization**
3. Substitua `SEU_MANYCHAT_API_TOKEN` por: `Bearer seu_token_aqui`

#### Nó: "ManyChat - Notificar Equipe"
1. Clique no nó
2. **Headers Parameters** → **Authorization**
3. Substitua `SEU_MANYCHAT_API_TOKEN` por: `Bearer seu_token_aqui`
4. **Body** → **subscriber_id**
5. Substitua `SEU_SUBSCRIBER_ID_EQUIPE` pelo ID copiado anteriormente

### 3.3 Configurar Credenciais HubSpot

#### Nó: "HubSpot - Criar/Atualizar Contato"
1. Clique no nó
2. **Credential to connect with**
3. Selecione: **"HubSpot ShieldCar"** (criado no passo 2.4)

### 3.4 Ativar Workflow

1. Botão **"Active"** (canto superior direito)
2. Deve ficar VERDE ✅

### 3.5 Copiar URL do Webhook

1. Clique no nó **"Webhook - Receber Lead"**
2. Copie a **Production URL**
3. Formato: `https://sua-url.railway.app/webhook/shieldcar-lead`

📋 **Copie essa URL - vai no formulário!**

---

## 🌐 Passo 4: Atualizar Formulário

### 4.1 Localizar Arquivo do Formulário

Exemplos de nomes comuns:
- `index.html`
- `cotacao.html`
- `lead-form.html`

### 4.2 Encontrar o JavaScript

Procure por uma linha similar a:

```javascript
const webhookUrl = 'https://...';
// OU
fetch('https://...', {
```

### 4.3 Atualizar URL

**ANTES:**
```javascript
const webhookUrl = 'https://hooks.zapier.com/...';
```

**DEPOIS:**
```javascript
const webhookUrl = 'https://SUA-URL.railway.app/webhook/shieldcar-lead';
```

### 4.4 Verificar Payload

Certifique-se que o formulário envia:

```javascript
{
  "firstname": "João",
  "lastname": "Silva",
  "email": "joao@email.com",
  "phone": "47999999999",
  "city": "Blumenau",
  "state": "SC",
  "placa_veiculo": "ABC1234",
  "tipo_veiculo": "Carro",
  "marca_veiculo": "Toyota",
  "modelo_veiculo": "Corolla",
  "ano_veiculo": "2023"
}
```

### 4.5 Fazer Deploy

- **Netlify:** `netlify deploy --prod`
- **Vercel:** `vercel --prod`
- **GitHub Pages:** Commit e push

---

## 🧪 Passo 5: Testar Integração

### Teste 1: Via cURL (API)

```bash
curl -X POST https://SUA-URL.railway.app/webhook/shieldcar-lead \
  -H "Content-Type: application/json" \
  -d '{
    "firstname": "Teste",
    "lastname": "Sistema",
    "email": "teste@shieldcar.com",
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

**Resposta esperada:**
```json
{
  "success": true,
  "message": "Lead processado com sucesso",
  "integrations": {
    "hubspot": "✅ Contato criado/atualizado",
    "manychat": "✅ Contato adicionado + mensagem enviada"
  }
}
```

### Teste 2: Verificar HubSpot

1. Acesse **HubSpot** → **Contacts**
2. Procure por "Teste Sistema"
3. Verifique se todos os campos foram preenchidos

### Teste 3: Verificar ManyChat

1. Acesse **ManyChat** → **Audience** → **All Contacts**
2. Procure por "Teste Sistema"
3. Verifique os Custom Fields

### Teste 4: Verificar WhatsApp

**Lead deve receber:**
```
🚗 *Olá Teste!*

Obrigado pelo interesse na *ShieldCar Blumenau*! 🛡️

Recebemos seus dados:
• Veículo: Toyota Corolla 2024
• Placa: TST1234

Em breve um consultor entrará em contato!

📱 Fique à vontade para tirar dúvidas!
```

**Equipe deve receber:**
```
🚗 *NOVO LEAD - ShieldCar*

👤 Teste Sistema
📱 47999999999
📧 teste@shieldcar.com
📍 Blumenau/SC

🚘 *Veículo:*
• Carro
• Toyota Corolla 2024
• Placa: TST1234

⏰ 31/10/2024 16:30

✅ Contato registrado no HubSpot!
```

### Teste 5: Formulário Real

1. Acesse sua landing page
2. Preencha o formulário
3. Verifique se recebeu mensagem no WhatsApp
4. Verifique se apareceu no HubSpot
5. Verifique se equipe foi notificada

---

## 🔍 Troubleshooting

### ❌ Erro: "Invalid API Token" (ManyChat)

**Solução:**
1. Verifique se copiou o token completo (incluindo `Bearer`)
2. Gere novo token no ManyChat
3. Atualize todos os 3 nós
4. Salve e reative o workflow

### ❌ HubSpot não cria contato

**Solução:**
1. Verifique se fez OAuth corretamente
2. Teste credenciais: Clique em **"Test Credential"**
3. Verifique se custom properties existem
4. Veja logs de execução no n8n

### ❌ ManyChat não envia mensagem

**Solução:**
1. Lead precisa ter iniciado conversa antes OU
2. Use WhatsApp Template Messages (requer aprovação)
3. Verifique subscriber_id da equipe

### ❌ Webhook retorna 400

**Solução:**
1. Verifique payload do formulário
2. Campos obrigatórios: `email`, `phone`
3. Veja logs no n8n **Executions**

### ❌ Railway deu erro no deploy

**Solução:**
1. Verifique variáveis de ambiente
2. Certifique-se que PostgreSQL está rodando
3. Veja logs: **View Logs** no Railway

---

## 📊 Monitoramento

### n8n - Ver Execuções

1. **Executions** (menu lateral)
2. Verde = sucesso, Vermelho = erro
3. Clique para ver detalhes

### Railway - Ver Logs

1. Dashboard do projeto
2. **View Logs**
3. Filtrar por: `error` ou `warning`

### HubSpot - Relatórios

1. **Reports** → **Analytics Tools**
2. Veja taxa de conversão
3. Atividade dos contatos

### ManyChat - Analytics

1. **Dashboard** → **Analytics**
2. Novos subscribers
3. Taxa de engajamento

---

## 💰 Custos Mensais Estimados

| Serviço | Plano | Custo |
|---------|-------|-------|
| Railway | Hobby | $5 grátis + ~$2-3 |
| ManyChat | Free | $0 (até 1k contatos) |
| HubSpot | Free | $0 (recursos básicos) |
| **TOTAL** | - | **~$2-3/mês** |

---

## ✅ Checklist Final

- [ ] n8n rodando no Railway
- [ ] Workflow importado e ativo
- [ ] Credenciais ManyChat configuradas
- [ ] Credenciais HubSpot configuradas
- [ ] Formulário atualizado com URL webhook
- [ ] Teste via cURL funcionou
- [ ] Lead recebe mensagem no WhatsApp
- [ ] Contato aparece no HubSpot
- [ ] Equipe recebe notificação
- [ ] Teste com formulário real funcionou

---

## 🎯 Próximas Melhorias

1. **Automações ManyChat**
   - Criar flow de follow-up
   - Quiz de qualificação
   - Lembretes automáticos

2. **HubSpot Workflows**
   - Email automation
   - Lead scoring
   - Pipelines de vendas

3. **Analytics**
   - Dashboard personalizado
   - Relatórios semanais
   - Métricas de conversão

---

**Status:** ✅ Pronto para Produção
**Versão:** 2.0.0 (ManyChat + HubSpot)
**Última atualização:** 31/10/2024
