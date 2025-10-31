# 🤖 Integração ShieldCar + ManyChat

Guia completo para integrar os leads da ShieldCar com o ManyChat via n8n.

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Configuração do ManyChat](#configuração-do-manychat)
3. [Deploy do n8n](#deploy-do-n8n)
4. [Configuração do Workflow](#configuração-do-workflow)
5. [Teste da Integração](#teste-da-integração)
6. [Troubleshooting](#troubleshooting)

---

## 🎯 Visão Geral

### O que acontece quando um lead preenche o formulário:

1. ✅ **Formulário enviado** → Landing page envia dados para webhook n8n
2. ✅ **n8n processa** → Valida e formata os dados do lead
3. ✅ **Cria contato** → Adiciona/atualiza contato no ManyChat
4. ✅ **Mensagem automática** → Lead recebe boas-vindas no WhatsApp
5. ✅ **Notificação equipe** → Vendedores são notificados sobre o novo lead

### Fluxo Visual

```
Landing Page → n8n Webhook → Validação → ManyChat API
                                            ↓
                                    Lead recebe mensagem
                                            +
                                    Equipe é notificada
```

---

## 🔧 Configuração do ManyChat

### Passo 1: Obter API Token

1. Acesse: https://manychat.com
2. Login → **Settings** → **API**
3. Clique em **Generate API Key**
4. Copie o token (começa com `Bearer ...`)
5. ⚠️ **Guarde em local seguro!**

### Passo 2: Criar Custom Fields

No ManyChat, crie os seguintes campos personalizados:

1. Vá em **Audience** → **Custom Fields** → **+ New Field**
2. Crie cada campo:

| Campo | Nome | Tipo |
|-------|------|------|
| `email` | Email | Text |
| `cidade` | Cidade | Text |
| `estado` | Estado | Text |
| `veiculo` | Veículo | Text |
| `placa` | Placa | Text |
| `tipo_veiculo` | Tipo de Veículo | Text |

### Passo 3: Obter Subscriber ID da Equipe

Para notificar a equipe, você precisa do ID do contato que receberá as notificações:

**Opção A: Via Dashboard**
1. Vá em **Audience** → **All Contacts**
2. Encontre o contato da equipe
3. Clique nele → copie o **Subscriber ID** da URL
4. Exemplo: `https://manychat.com/contacts/123456789` → ID é `123456789`

**Opção B: Via API (teste rápido)**
```bash
curl -X GET "https://api.manychat.com/fb/subscriber/getInfo?phone=+5547999999999" \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"
```

---

## 🚀 Deploy do n8n

### Railway (Recomendado - Mais Fácil)

Siga o guia completo em [DEPLOY-RAILWAY.md](DEPLOY-RAILWAY.md)

**Resumo rápido:**

1. **Deploy no Railway**
   ```bash
   # Clone o repositório
   git clone https://github.com/juanfeminni-hub/shieldcar-n8n-webhook.git
   cd shieldcar-n8n-webhook

   # Deploy
   railway login
   railway up
   ```

2. **Adicionar PostgreSQL**
   - No Railway: **+ New** → **Database** → **PostgreSQL**

3. **Variáveis de Ambiente**
   ```env
   N8N_BASIC_AUTH_ACTIVE=true
   N8N_BASIC_AUTH_USER=admin
   N8N_BASIC_AUTH_PASSWORD=ShieldCar2024!
   N8N_PORT=5678
   N8N_PROTOCOL=https
   GENERIC_TIMEZONE=America/Sao_Paulo
   EXECUTIONS_DATA_SAVE_ON_SUCCESS=all
   ```

4. **Gerar Domínio**
   - **Settings** → **Networking** → **Generate Domain**
   - Copie a URL: `https://n8n-production-xxxx.up.railway.app`

---

## ⚙️ Configuração do Workflow

### Passo 1: Acessar n8n

1. Acesse: `https://sua-url.up.railway.app`
2. Login: `admin` / `ShieldCar2024!`

### Passo 2: Importar Workflow

1. No n8n: **+ (Menu)** → **Import from File**
2. Selecione: `workflow-shieldcar-manychat.json`
3. Clique em **Import**

### Passo 3: Configurar Nós do ManyChat

O workflow tem 3 nós que precisam do API Token:

#### 1️⃣ Nó "Criar Contato ManyChat"

1. Clique no nó **"Criar Contato ManyChat"**
2. Em **Headers Parameters** → **Authorization**
3. Substitua `SEU_MANYCHAT_API_TOKEN` pelo seu token
4. Exemplo: `Bearer sk_123abc456def789ghi`

#### 2️⃣ Nó "Enviar Mensagem Boas-vindas"

1. Clique no nó **"Enviar Mensagem Boas-vindas"**
2. Em **Headers Parameters** → **Authorization**
3. Substitua `SEU_MANYCHAT_API_TOKEN` pelo seu token

#### 3️⃣ Nó "Notificar Equipe"

1. Clique no nó **"Notificar Equipe"**
2. Em **Headers Parameters** → **Authorization**
3. Substitua `SEU_MANYCHAT_API_TOKEN` pelo seu token
4. Em **Body** → **subscriber_id**
5. Substitua `SEU_SUBSCRIBER_ID_EQUIPE` pelo ID obtido no Passo 3

### Passo 4: Ativar Workflow

1. Clique no botão **"Active"** (canto superior direito)
2. O workflow ficará verde = **ATIVO** ✅

### Passo 5: Copiar URL do Webhook

1. Clique no nó **"Webhook - Receber Lead"**
2. Copie a **Webhook URL** (Production)
3. Exemplo: `https://n8n-production-xxxx.up.railway.app/webhook/shieldcar-lead`

---

## 🌐 Atualizar Landing Page

### Editar arquivo da landing page

No arquivo HTML do formulário (ex: `index.html`, `cotacao.html`):

1. Localize a linha do webhook (geralmente próximo ao JavaScript do formulário)
2. Substitua pela URL copiada:

```javascript
// ANTES
const webhookUrl = 'https://hooks.zapier.com/...';

// DEPOIS
const webhookUrl = 'https://n8n-production-xxxx.up.railway.app/webhook/shieldcar-lead';
```

3. Faça novo deploy da landing page

---

## 🧪 Teste da Integração

### Teste 1: Via n8n (Manual)

1. No workflow, clique no nó **"Webhook - Receber Lead"**
2. Clique em **"Listen for Test Event"**
3. Preencha o formulário da landing page
4. Volte ao n8n → você verá os dados chegando
5. Clique em **"Execute Workflow"**
6. ✅ Verifique se todas as etapas ficaram verdes

### Teste 2: Via cURL (API)

```bash
curl -X POST https://n8n-production-xxxx.up.railway.app/webhook/shieldcar-lead \
  -H "Content-Type: application/json" \
  -d '{
    "firstname": "João",
    "lastname": "Silva",
    "email": "joao@teste.com",
    "phone": "47999999999",
    "city": "Blumenau",
    "state": "SC",
    "placa_veiculo": "ABC1234",
    "tipo_veiculo": "Carro",
    "marca_veiculo": "Toyota",
    "modelo_veiculo": "Corolla",
    "ano_veiculo": "2023"
  }'
```

**Resposta esperada:**
```json
{
  "success": true,
  "message": "Lead recebido e processado com sucesso",
  "lead": {
    "nome": "João Silva",
    "telefone": "47999999999",
    "veiculo": "Toyota Corolla 2023"
  },
  "timestamp": "2024-10-31T12:00:00.000Z"
}
```

### Teste 3: Verificar ManyChat

1. Acesse **ManyChat** → **Audience** → **All Contacts**
2. Procure por "João Silva" (do teste)
3. Clique no contato → verifique **Custom Fields**
4. Todos os dados devem estar preenchidos

### Teste 4: WhatsApp

1. O lead deve receber mensagem:
```
🚗 *Olá João!*

Obrigado pelo interesse na *ShieldCar Blumenau*! 🛡️

Recebemos seus dados do veículo:
• Toyota Corolla 2023
• Placa: ABC1234

Em breve um de nossos consultores entrará em contato para apresentar as melhores opções de proteção veicular! ⚡

📱 Enquanto isso, fique à vontade para tirar dúvidas por aqui!
```

2. A equipe deve receber notificação:
```
🚗 *NOVO LEAD - ShieldCar Blumenau*

👤 *Cliente:* João Silva
📱 *Telefone:* 47999999999
📧 *Email:* joao@teste.com
📍 *Localização:* Blumenau/SC

🚘 *Veículo:*
• Tipo: Carro
• Modelo: Toyota Corolla 2023
• Placa: ABC1234

⏰ *Recebido em:* 31/10/2024 12:00

✅ *Ação:* Entre em contato em até 2 minutos!
```

---

## 🔍 Troubleshooting

### ❌ Erro: "Invalid API Token"

**Causa:** Token do ManyChat incorreto ou expirado

**Solução:**
1. Verifique se copiou o token completo (incluindo `Bearer`)
2. Gere um novo token no ManyChat
3. Atualize todos os 3 nós do workflow
4. Salve e reative o workflow

### ❌ Erro: "Subscriber not found"

**Causa:** Telefone não está no formato correto

**Solução:**
1. Certifique-se que o telefone tem formato: `+5547999999999`
2. No workflow, verifique o nó **"Formatar Dados Lead"**
3. O campo `telefone_limpo` remove caracteres especiais
4. Teste com um número válido

### ❌ Erro: "Custom field not found"

**Causa:** Campos personalizados não foram criados no ManyChat

**Solução:**
1. Vá em **ManyChat** → **Audience** → **Custom Fields**
2. Crie todos os campos listados no [Passo 2](#passo-2-criar-custom-fields)
3. Use exatamente os mesmos nomes (case-sensitive)

### ❌ Lead não recebe mensagem

**Causa:** Telefone não está inscrito no WhatsApp/ManyChat

**Solução:**
1. O lead precisa ter enviado pelo menos 1 mensagem antes para o número do ManyChat
2. **OU** usar a API de template messages (requer aprovação do WhatsApp Business)
3. **OU** enviar link de opt-in primeiro

### ❌ Equipe não recebe notificação

**Causa:** `subscriber_id` da equipe está incorreto

**Solução:**
1. Verifique o ID no nó **"Notificar Equipe"**
2. Teste com o ID correto do ManyChat
3. Certifique-se que o contato está ativo

### ⚠️ Webhook retorna 400

**Causa:** Telefone vazio ou inválido

**Solução:**
1. Verifique o campo `phone` no payload
2. Deve conter apenas números
3. No mínimo 10 dígitos (DDD + número)

---

## 📊 Monitoramento

### Ver Logs no Railway

1. Acesse Railway → seu projeto
2. Clique em **"View Logs"**
3. Filtre por erros: `error` ou `failed`

### Ver Execuções no n8n

1. No n8n, vá em **Executions** (menu lateral)
2. Veja todas as execuções (sucesso/erro)
3. Clique em qualquer execução para detalhes

### Estatísticas no ManyChat

1. **Dashboard** → **Analytics**
2. Veja novos subscribers
3. Taxa de engajamento das mensagens

---

## 💰 Custos Estimados

| Serviço | Plano | Custo/mês |
|---------|-------|-----------|
| **Railway** | Hobby | $5 grátis + ~$2-3 uso |
| **ManyChat** | Free | $0 (até 1.000 contatos) |
| **ManyChat** | Pro | $15 (10k mensagens/mês) |
| **WhatsApp Business API** | - | Varia (Meta cobra por mensagem) |

**Total estimado:** $0-5/mês para volume baixo

---

## 🚀 Próximos Passos

### Melhorias Sugeridas

1. **Flow de Follow-up**
   - Criar sequência de mensagens no ManyChat
   - Enviar lembretes após 24h se não houver resposta

2. **Tags Automáticas**
   - Adicionar tags baseadas em tipo de veículo
   - Segmentar por cidade/estado

3. **Qualificação de Lead**
   - Criar quiz no ManyChat
   - Coletar mais informações antes de passar para vendas

4. **CRM Integration**
   - Conectar com HubSpot/Pipedrive
   - Sincronizar dados automaticamente

5. **Analytics Avançado**
   - Dashboard de conversão
   - Tempo médio de resposta
   - Taxa de fechamento

---

## 📞 Suporte

**Documentação Oficial:**
- n8n: https://docs.n8n.io
- ManyChat API: https://api.manychat.com/swagger
- Railway: https://docs.railway.app

**Dúvidas:**
- Abra uma issue no GitHub do projeto
- Entre em contato com o desenvolvedor

---

**Status:** ✅ Pronto para Produção
**Versão:** 1.0.0
**Última atualização:** 31/10/2024
