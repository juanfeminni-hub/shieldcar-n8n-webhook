# 🚀 Deploy no Railway - Passo a Passo Completo

## ✅ Pré-requisitos
- Conta no GitHub (você já tem)
- Navegador web
- 5 minutos de tempo

---

## 📋 PASSO A PASSO

### 1️⃣ Acessar Railway (1 min)

1. Abra: **https://railway.app**
2. Clique em **"Start a New Project"** ou **"Login"** (canto superior direito)
3. Escolha **"Login with GitHub"**
4. Autorize o Railway a acessar sua conta GitHub
5. Você ganhará **$5 de crédito grátis/mês** ✅

---

### 2️⃣ Criar Novo Projeto (30 segundos)

1. No dashboard do Railway, clique em **"+ New Project"**
2. Selecione **"Deploy from GitHub repo"**
3. Se aparecer "Configure GitHub App", clique e autorize o Railway
4. Procure e selecione: **`shieldcar-n8n-webhook`**
5. Clique em **"Deploy Now"**

Railway vai detectar automaticamente o `Dockerfile` e começar o build! 🎉

---

### 3️⃣ Adicionar Banco de Dados PostgreSQL (1 min)

O n8n precisa de um banco de dados para funcionar.

1. **Enquanto o build acontece**, clique no botão **"+ New"** dentro do projeto
2. Selecione **"Database"**
3. Escolha **"Add PostgreSQL"**
4. Railway criará o banco automaticamente
5. Aguarde até aparecer "✓ PostgreSQL is ready"

**Importante:** Railway conecta automaticamente o PostgreSQL ao n8n via variáveis de ambiente!

---

### 4️⃣ Configurar Variáveis de Ambiente (2 min)

1. Clique no seu serviço **n8n** (não no PostgreSQL)
2. Vá na aba **"Variables"**
3. Clique em **"+ New Variable"** e adicione cada uma abaixo:

```
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=ShieldCar2024!
N8N_PORT=5678
N8N_PROTOCOL=https
GENERIC_TIMEZONE=America/Sao_Paulo
EXECUTIONS_DATA_SAVE_ON_SUCCESS=all
EXECUTIONS_DATA_SAVE_ON_ERROR=all
```

4. Clique em **"Add"** para cada variável
5. Após adicionar todas, clique em **"Deploy"** (se não fizer deploy automático)

---

### 5️⃣ Gerar URL Pública (30 segundos)

1. Ainda no serviço n8n, vá na aba **"Settings"**
2. Clique em **"Networking"** ou **"Domains"**
3. Clique em **"Generate Domain"**
4. Railway criará uma URL tipo: `n8n-production-xxxx.up.railway.app`
5. **COPIE ESSA URL!** 📋 Você vai precisar dela!

---

### 6️⃣ Aguardar Deploy Completar (1-2 min)

1. Volte para a aba **"Deployments"**
2. Aguarde até ver **"✓ Success"** (bolinha verde)
3. Você verá logs do tipo:
   ```
   n8n ready on 0.0.0.0:5678
   Editor is now accessible via:
   https://n8n-production-xxxx.up.railway.app
   ```

---

### 7️⃣ Acessar seu n8n (30 segundos)

1. Abra a URL que você copiou: `https://n8n-production-xxxx.up.railway.app`
2. Faça login com:
   - **Usuário:** `admin`
   - **Senha:** `ShieldCar2024!`
3. Você verá a tela inicial do n8n! 🎉

---

### 8️⃣ Importar Workflow ShieldCar (1 min)

1. No n8n, clique no ícone **"+"** no canto superior esquerdo
2. Clique em **"Import from File"**
3. Selecione o arquivo: `/Users/juanminni/shieldcar-n8n-webhook/workflow-shieldcar-leads.json`
4. O workflow aparecerá com 3 nós:
   - 🌐 **Webhook** (recebe dados do formulário)
   - 🔄 **Formatar Dados** (organiza as informações)
   - 📱 **Enviar WhatsApp** (envia notificação)

---

### 9️⃣ Configurar WhatsApp (IMPORTANTE) ⚠️

O nó "Enviar WhatsApp" precisa ser configurado. Você tem 3 opções:

#### **Opção A: Evolution API** (Recomendado - Gratuito)
1. Instale Evolution API: https://github.com/EvolutionAPI/evolution-api
2. Configure uma instância do WhatsApp
3. No n8n, edite o nó "Enviar WhatsApp"
4. Use o endpoint da Evolution API
5. Configure o número do grupo

#### **Opção B: WhatsApp Business API** (Oficial - Pago)
1. Configure Meta Business: https://business.facebook.com
2. Obtenha token de acesso
3. Configure webhook no workflow

#### **Opção C: Webhook Simples** (Temporário)
1. Use Zapier/Make.com para receber webhook
2. Configure ação de WhatsApp lá
3. Mantenha n8n apenas como ponte

**Por enquanto, você pode ATIVAR o workflow sem configurar o WhatsApp.** Ele receberá os dados do formulário e salvará no log, mesmo que não envie WhatsApp ainda.

---

### 🔟 Ativar Workflow (10 segundos)

1. No workflow, clique no botão **"Active"** (canto superior direito)
2. Deve ficar verde ✅
3. Clique em **"Save"**

---

### 1️⃣1️⃣ Copiar URL do Webhook (10 segundos)

1. Clique no nó **"Webhook"** (primeiro da esquerda)
2. Clique em **"Test URL"** ou **"Production URL"**
3. Você verá algo como:
   ```
   https://n8n-production-xxxx.up.railway.app/webhook/hubspot-lead
   ```
4. **COPIE ESSA URL COMPLETA!** 📋

---

### 1️⃣2️⃣ Atualizar Formulário ShieldCar (30 segundos)

Agora preciso atualizar o código do formulário com a nova URL permanente.

**Me envie a URL que você copiou** e eu atualizo automaticamente!

Exemplo: `https://n8n-production-xxxx.up.railway.app/webhook/hubspot-lead`

---

## ✅ CHECKLIST FINAL

Marque cada item que você completou:

- [ ] Criou conta no Railway
- [ ] Deploy do n8n concluído (build success)
- [ ] PostgreSQL adicionado
- [ ] Variáveis de ambiente configuradas
- [ ] URL pública gerada
- [ ] Acessou n8n (login ok)
- [ ] Workflow importado
- [ ] Workflow ativado (active = true)
- [ ] Copiou URL do webhook

---

## 🧪 TESTAR WEBHOOK

Depois que eu atualizar o formulário, você pode testar assim:

```bash
curl -X POST https://SUA-URL.up.railway.app/webhook/hubspot-lead \
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

Deve retornar status 200 e você verá a execução nos logs do n8n!

---

## 💰 CUSTOS

**Railway:**
- ✅ $5/mês de crédito GRÁTIS
- 💵 Uso estimado: $2-3/mês
- 🎁 **Provavelmente totalmente GRÁTIS!**

**n8n:**
- ✅ 100% GRÁTIS (self-hosted)

**Total:** $0 com o crédito mensal da Railway! 🎉

---

## 🆘 PROBLEMAS?

### "Build Failed"
- Verifique se o PostgreSQL foi criado
- Confira variáveis de ambiente

### "Can't access n8n"
- Aguarde 2-3 minutos após deploy
- Verifique se gerou o domínio público

### "Login não funciona"
- Usuário: `admin`
- Senha: `ShieldCar2024!`
- Verifique se variáveis foram salvas

### "Webhook não recebe dados"
- Certifique-se que workflow está ATIVO (verde)
- Clique em "Save" após importar

---

## 📞 PRÓXIMO PASSO

**ME ENVIE A URL DO WEBHOOK** que você copiou e eu:
1. ✅ Atualizo o formulário automaticamente
2. ✅ Faço deploy no Netlify
3. ✅ Testo a integração completa

Exemplo da URL que preciso:
```
https://n8n-production-xxxx.up.railway.app/webhook/hubspot-lead
```

Aguardo sua URL! 🚀
