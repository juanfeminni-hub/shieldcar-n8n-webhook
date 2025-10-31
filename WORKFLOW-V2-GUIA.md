# 🚀 Workflow V2 - Guia Completo de Configuração

## 📋 Visão Geral

Este é o **workflow mais completo** para ShieldCar com:

✅ **Validação completa** (email, telefone, dados do veículo obrigatórios)
✅ **HubSpot** - Cria/atualiza contatos automaticamente
✅ **ManyChat** - Adiciona subscriber com custom fields
✅ **WhatsApp Lead** - Mensagem de boas-vindas automática
✅ **WhatsApp Equipe** - Notificação para grupo/equipe
✅ **Respostas adequadas** - Sucesso ou erro detalhado

---

## 🎯 Fluxo do Workflow

```
📝 Formulário
    ↓
🔍 Validar Dados (email, phone, placa, marca, modelo)
    ↓
✅ VÁLIDO                    ❌ INVÁLIDO
    ↓                            ↓
📊 Formatar Dados         ⚠️ Retorna Erro 400
    ↓
┌───┴───┐
│       │
▼       ▼
🏢      📱
HubSpot ManyChat
    │       │
    │       ├─► 💬 Mensagem Boas-vindas → Lead
    │       └─► 📢 Notificação → Grupo/Equipe
    │
    └─► ✅ Resposta Sucesso
```

---

## 📥 Passo 1: Importar Workflow no n8n Cloud

### 1.1 Baixar o arquivo

O arquivo está em: `workflow-shieldcar-v2-completo.json`

### 1.2 Importar no n8n

1. Acesse seu n8n Cloud: https://starken.app.n8n.cloud
2. No menu lateral, clique em **"Workflows"**
3. Clique no botão **"+ Add workflow"** → **"Import from file"**
4. Selecione o arquivo: `workflow-shieldcar-v2-completo.json`
5. Clique **"Import"**

O workflow será importado com o nome:
**"ShieldCar V2 - Lead Completo (HubSpot + ManyChat + WhatsApp)"**

---

## 🔐 Passo 2: Configurar Credenciais

Você precisa configurar 2 credenciais:

### 2.1 Credencial HubSpot (OAuth2)

1. No workflow, clique no nó **"HubSpot - Criar/Atualizar Contato"**
2. Em **"Credential to connect with"**:
   - Clique em **"Create New"**
   - Tipo: **HubSpot OAuth2 API**
3. Clique em **"Connect my account"**
4. Você será redirecionado para o HubSpot
5. Faça login e autorize o acesso
6. Após autorizar, volte ao n8n
7. Dê um nome: **"HubSpot ShieldCar"**
8. Clique **"Save"**

### 2.2 Credencial ManyChat (API Token)

1. **Obter token no ManyChat:**
   - Acesse: https://manychat.com
   - Vá em **Settings** → **API**
   - Clique em **"Generate API Key"**
   - Copie o token (formato: `123abc456def...`)

2. **Configurar no n8n:**
   - No workflow, clique em qualquer nó do ManyChat
   - Em **"Credential to connect with"**:
     - Clique em **"Create New"**
     - Tipo: **ManyChat API**
   - Cole o **API Token** (sem o "Bearer")
   - Dê um nome: **"ManyChat ShieldCar"**
   - Clique **"Save"**

3. **Aplicar nos outros nós ManyChat:**
   - Clique no nó **"ManyChat - Mensagem Boas-vindas"**
   - Selecione a credencial: **"ManyChat ShieldCar"**
   - Repita para o nó **"ManyChat - Notificar Grupo/Equipe"**

---

## ⚙️ Passo 3: Configurar Subscriber ID da Equipe

Para notificar o grupo/equipe, você precisa do **Subscriber ID**.

### 3.1 Obter Subscriber ID

**Opção A - Via Dashboard ManyChat:**

1. Vá em **Audience** → **All Contacts**
2. Encontre o contato que representa o grupo/equipe
3. Clique nele
4. Na URL, você verá algo como:
   ```
   https://manychat.com/fb123456789/contacts/987654321
   ```
   O Subscriber ID é: **987654321**

**Opção B - Via API:**

```bash
curl -X GET "https://api.manychat.com/fb/subscriber/getInfo?phone=+5547XXXXXXXXX" \
  -H "Authorization: Bearer SEU_TOKEN_MANYCHAT"
```

Procure no retorno: `"id": 987654321`

### 3.2 Configurar no Workflow

1. No workflow, clique no nó **"ManyChat - Notificar Grupo/Equipe"**
2. Na seção **"Body"**, localize a linha:
   ```json
   "subscriber_id": "SUBSCRIBER_ID_DO_GRUPO_OU_EQUIPE",
   ```
3. Substitua `SUBSCRIBER_ID_DO_GRUPO_OU_EQUIPE` pelo ID obtido
4. **IMPORTANTE:** Se for número, remova as aspas:
   ```json
   "subscriber_id": 987654321,
   ```
5. Clique **"Save"** (ícone de disquete no canto superior direito)

---

## 🔧 Passo 4: Verificar Custom Fields no ManyChat

O workflow envia estes custom fields para o ManyChat:

- `email`
- `cidade`
- `estado`
- `veiculo`
- `placa`
- `tipo_veiculo`

**Certifique-se que eles existem:**

1. No ManyChat: **Audience** → **Custom Fields**
2. Verifique se todos os 6 campos existem
3. Se não existirem, crie-os:
   - Clique **"+ New Field"**
   - Nome: `email` (exatamente assim, minúsculas)
   - Tipo: **Text**
   - Repita para os outros

---

## 🔧 Passo 5: Verificar Custom Properties no HubSpot

O workflow envia estes dados para o HubSpot:

- `firstname` ✅ (padrão)
- `lastname` ✅ (padrão)
- `phone` ✅ (padrão)
- `email` ✅ (padrão)
- `city` ✅ (padrão)
- `state` ✅ (padrão)
- `placa_veiculo` ⚠️ (pode precisar criar)
- `tipo_veiculo` ⚠️ (pode precisar criar)
- `veiculo` ⚠️ (pode precisar criar)

**Criar custom properties (se necessário):**

1. No HubSpot: **Settings** → **Properties** → **Contact Properties**
2. Clique **"Create property"**
3. Preencha:
   - **Label:** Placa do Veículo
   - **Internal name:** `placa_veiculo`
   - **Type:** Single-line text
4. Repita para `tipo_veiculo` e `veiculo`

---

## ✅ Passo 6: Ativar Workflow

1. No workflow, clique no botão **"Active"** (canto superior direito)
2. O botão deve ficar VERDE e mudar para **"Active"** ✅
3. Clique no nó **"Webhook - Receber Lead"**
4. **COPIE A PRODUCTION URL:**
   ```
   https://starken.app.n8n.cloud/webhook/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
   ```

📋 **Guarde essa URL - vai no formulário!**

---

## 🌐 Passo 7: Atualizar Formulário

No seu arquivo HTML do formulário:

### 7.1 Localizar o código

Procure por algo como:

```javascript
const webhookUrl = 'https://...';
// OU
fetch('https://...', {
```

### 7.2 Substituir URL

**ANTES:**
```javascript
const webhookUrl = 'https://antiga-url.com/webhook';
```

**DEPOIS:**
```javascript
const webhookUrl = 'https://starken.app.n8n.cloud/webhook/SEU-WEBHOOK-ID';
```

### 7.3 Verificar payload

Certifique-se que o formulário envia **EXATAMENTE** esses campos:

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

⚠️ **IMPORTANTE:** Os nomes devem ser EXATAMENTE como acima (case-sensitive).

---

## 🧪 Passo 8: Testar o Workflow

### Teste via cURL

Copie e execute este comando (substitua a URL):

```bash
curl -X POST https://starken.app.n8n.cloud/webhook/SEU-WEBHOOK-ID \
  -H "Content-Type: application/json" \
  -d '{
    "firstname": "Teste",
    "lastname": "Sistema",
    "email": "teste@shieldcar.com.br",
    "phone": "47992752697",
    "city": "Blumenau",
    "state": "SC",
    "placa_veiculo": "TST9999",
    "tipo_veiculo": "Carro",
    "marca_veiculo": "Honda",
    "modelo_veiculo": "Civic",
    "ano_veiculo": "2024"
  }'
```

### Resposta Esperada - SUCESSO ✅

```json
{
  "success": true,
  "message": "Lead processado com sucesso!",
  "integrações": {
    "hubspot": "✅ Contato criado/atualizado",
    "manychat": "✅ Subscriber adicionado",
    "whatsapp_lead": "✅ Mensagem de boas-vindas enviada",
    "whatsapp_equipe": "✅ Equipe notificada"
  },
  "lead": {
    "nome": "Teste Sistema",
    "email": "teste@shieldcar.com.br",
    "telefone": "47992752697",
    "veiculo": "Honda Civic 2024",
    "placa": "TST9999"
  },
  "timestamp": "2024-10-31T19:30:00.000Z"
}
```

### Resposta Esperada - ERRO ❌ (dados incompletos)

```json
{
  "success": false,
  "message": "Dados incompletos. Verifique os campos obrigatórios.",
  "campos_obrigatorios": [
    "email",
    "phone",
    "placa_veiculo",
    "marca_veiculo",
    "modelo_veiculo"
  ],
  "dados_recebidos": {
    "email": "VAZIO",
    "phone": "47992752697",
    "placa_veiculo": "TST9999",
    "marca_veiculo": "VAZIO",
    "modelo_veiculo": "VAZIO"
  }
}
```

---

## 📱 Passo 9: Verificar Integrações

### 9.1 Verificar Execução no n8n

1. No workflow, clique em **"Executions"** (menu lateral)
2. Veja a última execução
3. Todos os nós devem estar VERDES ✅
4. Se algum estiver VERMELHO ❌, clique nele para ver o erro

### 9.2 Verificar HubSpot

1. Acesse: https://app.hubspot.com/contacts
2. Procure por: **"Teste Sistema"**
3. Verifique se todos os campos foram preenchidos

### 9.3 Verificar ManyChat

1. Acesse: https://manychat.com
2. **Audience** → **All Contacts**
3. Procure por: **"Teste Sistema"** ou **47992752697**
4. Clique no contato
5. Verifique os **Custom Fields**

### 9.4 Verificar WhatsApp

**Telefone do Lead (47992752697) deve receber:**

```
🚗 *Olá Teste!*

Obrigado pelo interesse na *ShieldCar Blumenau*! 🛡️

Recebemos seus dados:
• Veículo: Honda Civic 2024
• Placa: TST9999

Em breve um de nossos consultores entrará em contato para apresentar as melhores opções de proteção veicular! ⚡

📱 Fique à vontade para tirar dúvidas por aqui!
```

**Grupo/Equipe deve receber:**

```
🚗 *NOVO LEAD - ShieldCar Blumenau*

👤 *Cliente:* Teste Sistema
📱 *Telefone:* 47992752697
📧 *Email:* teste@shieldcar.com.br
📍 *Localização:* Blumenau/SC

🚘 *Veículo:*
• Tipo: Carro
• Modelo: Honda Civic 2024
• Placa: TST9999

⏰ *Recebido em:* 31/10/2024 16:30

✅ *Ações realizadas:*
• Contato criado no HubSpot
• Lead adicionado ao ManyChat
• Mensagem de boas-vindas enviada

📞 *Entre em contato em até 2 minutos!*
```

---

## 🔍 Troubleshooting

### ❌ Erro: "Invalid API Token" (ManyChat)

**Solução:**
1. Verifique se o token está correto
2. Gere novo token no ManyChat
3. Atualize a credencial em todos os nós ManyChat

### ❌ Erro: "Unauthorized" (HubSpot)

**Solução:**
1. Refaça o OAuth no HubSpot
2. Delete a credencial antiga
3. Crie nova credencial e autorize novamente

### ❌ Erro: "Subscriber not found"

**Solução:**
1. Verifique o Subscriber ID da equipe
2. Certifique-se que o contato existe no ManyChat
3. Use o ID numérico (sem aspas)

### ❌ Lead não recebe mensagem

**Causa:** Telefone não iniciou conversa antes

**Solução:**
1. Lead deve enviar pelo menos 1 mensagem antes OU
2. Use WhatsApp Template Messages (requer aprovação Meta)

### ❌ Campos vazios no HubSpot/ManyChat

**Solução:**
1. Verifique se o payload do formulário está correto
2. Confirme que os nomes dos campos estão exatos
3. Veja os dados no nó "Formatar Dados" no n8n

---

## 📊 Campos do Workflow

### Entrada (Webhook)

| Campo | Tipo | Obrigatório | Exemplo |
|-------|------|-------------|---------|
| `firstname` | String | ❌ | "João" |
| `lastname` | String | ❌ | "Silva" |
| `email` | String | ✅ | "joao@email.com" |
| `phone` | String | ✅ | "47999999999" |
| `city` | String | ❌ | "Blumenau" |
| `state` | String | ❌ | "SC" |
| `placa_veiculo` | String | ✅ | "ABC1234" |
| `tipo_veiculo` | String | ❌ | "Carro" |
| `marca_veiculo` | String | ✅ | "Toyota" |
| `modelo_veiculo` | String | ✅ | "Corolla" |
| `ano_veiculo` | String | ❌ | "2023" |

### Saída (Processado)

| Campo | Descrição | Exemplo |
|-------|-----------|---------|
| `nome_completo` | Nome + Sobrenome | "João Silva" |
| `telefone_limpo` | Só números | "47999999999" |
| `telefone_whatsapp` | Com +55 | "+5547999999999" |
| `veiculo_completo` | Marca + Modelo + Ano | "Toyota Corolla 2023" |
| `timestamp` | Data/hora formatada | "31/10/2024 16:30" |

---

## ✅ Checklist de Configuração

Antes de colocar em produção:

- [ ] Workflow importado no n8n Cloud
- [ ] Credencial HubSpot (OAuth) configurada
- [ ] Credencial ManyChat (API Token) configurada
- [ ] Subscriber ID da equipe configurado
- [ ] Custom Fields criados no ManyChat
- [ ] Custom Properties criados no HubSpot (se necessário)
- [ ] Workflow ATIVO (verde)
- [ ] Production URL copiada
- [ ] Formulário atualizado com nova URL
- [ ] Teste via cURL executado com sucesso
- [ ] Lead recebeu mensagem no WhatsApp
- [ ] Equipe recebeu notificação
- [ ] Contato aparece no HubSpot
- [ ] Contato aparece no ManyChat

---

## 🎯 Próximos Passos

Depois que tudo estiver funcionando:

1. **Testar com formulário real**
2. **Monitorar primeiras execuções**
3. **Ajustar mensagens se necessário**
4. **Criar flows de follow-up no ManyChat**
5. **Configurar pipelines no HubSpot**

---

**Status:** ✅ Pronto para Produção
**Versão:** 2.0.0
**Data:** 31/10/2024
