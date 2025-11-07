# Screenshots e Demonstração Visual

Este documento descreve visualmente cada tela do GreenCap K8s Installer Wizard.

## 🎨 Interface do Wizard

O wizard possui uma interface limpa e moderna com:
- **Cores**: Tema verde (#2e7d32) e cinza suave
- **Fonte**: Arial, tamanhos variados para hierarquia visual
- **Navegação**: Botões claros (Voltar, Avançar, Cancelar)
- **Layout**: Centralizado com espaçamento consistente

---

## 📱 Telas do Wizard

### 1. Tela de Boas-Vindas

```
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║          Bem-vindo ao GreenCap K8s Installer                     ║
║                                                                   ║
║  Este assistente irá guiá-lo através do processo de              ║
║  instalação do GreenCap K8s, uma plataforma completa de          ║
║  desenvolvimento com Kubernetes.                                  ║
║                                                                   ║
║  O que será instalado:                                           ║
║    • Ambiente Kubernetes local (Kind)                            ║
║    • Helm para gerenciamento de pacotes                          ║
║    • Ingress Controller para roteamento                          ║
║    • Harbor para registry de containers                          ║
║    • GitLab para CI/CD                                           ║
║    • Monitoring Stack (Prometheus + Grafana)                     ║
║    • PostgreSQL Database                                         ║
║    • Kubernetes Dashboard                                        ║
║    • Aplicações de exemplo                                       ║
║                                                                   ║
║  Requisitos do sistema:                                          ║
║    • Sistema operacional: Linux (Ubuntu/Debian recomendado)      ║
║    • Memória RAM: mínimo 4GB                                     ║
║    • Espaço em disco: mínimo 20GB                                ║
║    • Docker instalado (ou será instalado automaticamente)        ║
║                                                                   ║
║                                                                   ║
║  [ Voltar ]              [ Cancelar ]        [ Avançar → ]       ║
╚═══════════════════════════════════════════════════════════════════╝
```

**Descrição**: Primeira tela com informações sobre o que será instalado e requisitos do sistema.

---

### 2. Seleção do Tipo de Instalação

```
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║              Selecione o Tipo de Instalação                      ║
║                                                                   ║
║  ┌─────────────────────────────────────────────────────────────┐ ║
║  │  Provedor de Ambiente                                       │ ║
║  │                                                             │ ║
║  │  ◉ Instalação Local                                        │ ║
║  │     Instalar diretamente na máquina atual                  │ ║
║  │                                                             │ ║
║  │  ○ Vagrant (VM Local)                                      │ ║
║  │     Criar uma máquina virtual local com VirtualBox         │ ║
║  │                                                             │ ║
║  │  ○ AWS EC2                                                 │ ║
║  │     Provisionar infraestrutura na AWS usando Terraform     │ ║
║  │                                                             │ ║
║  └─────────────────────────────────────────────────────────────┘ ║
║                                                                   ║
║                                                                   ║
║  [ ← Voltar ]            [ Cancelar ]        [ Avançar → ]       ║
╚═══════════════════════════════════════════════════════════════════╝
```

**Descrição**: Escolha entre instalação Local, Vagrant ou AWS.

---

### 3a. Configuração Local

```
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║                  Configuração Local                              ║
║                                                                   ║
║  ┌─────────────────────────────────────────────────────────────┐ ║
║  │  Opções de Instalação                                       │ ║
║  │                                                             │ ║
║  │  Tipo de Instalação:  [ minimal ▼ ]                        │ ║
║  │                                                             │ ║
║  │  ☑ Usar Docker/Kind/kubectl já instalados                  │ ║
║  │                                                             │ ║
║  │  Nome de Usuário:     [ vagrant          ]                 │ ║
║  │                                                             │ ║
║  └─────────────────────────────────────────────────────────────┘ ║
║                                                                   ║
║                                                                   ║
║  [ ← Voltar ]            [ Cancelar ]        [ Avançar → ]       ║
╚═══════════════════════════════════════════════════════════════════╝
```

**Descrição**: Configurações para instalação local (aparece se escolher "Local").

---

### 3b. Configuração Vagrant

```
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║                  Configuração Vagrant                            ║
║                                                                   ║
║  ┌─────────────────────────────────────────────────────────────┐ ║
║  │  Recursos da VM                                             │ ║
║  │                                                             │ ║
║  │  Memória (MB):        [ 4096 ▲▼ ]                          │ ║
║  │                                                             │ ║
║  │  CPUs:                [ 2 ▲▼ ]                             │ ║
║  │                                                             │ ║
║  │  ☑ Habilitar Interface Gráfica (GUI)                       │ ║
║  │                                                             │ ║
║  └─────────────────────────────────────────────────────────────┘ ║
║                                                                   ║
║                                                                   ║
║  [ ← Voltar ]            [ Cancelar ]        [ Avançar → ]       ║
╚═══════════════════════════════════════════════════════════════════╝
```

**Descrição**: Configurações para VM Vagrant (aparece se escolher "Vagrant").

---

### 3c. Configuração AWS

```
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║                    Configuração AWS                              ║
║                                                                   ║
║  ┌─────────────────────────────────────────────────────────────┐ ║
║  │  Credenciais e Configuração AWS                  ▲         │ ║
║  │                                                  ║         │ ║
║  │  Região:              [ us-east-1          ]    ║         │ ║
║  │  Tipo de Instância:   [ t3a.medium         ]    ║         │ ║
║  │  Nome do Key Pair:    [                    ]    ║         │ ║
║  │  AMI ID (opcional):   [                    ]    ║         │ ║
║  │  Subnet ID:           [                    ]    ║         │ ║
║  │  Security Group ID:   [                    ]    ║         │ ║
║  │  Seu IP Público:      [                    ]    ▼         │ ║
║  │                                                             │ ║
║  │  ☐ Auto-aprovar Terraform (sem confirmação)                │ ║
║  └─────────────────────────────────────────────────────────────┘ ║
║                                                                   ║
║  [ ← Voltar ]            [ Cancelar ]        [ Avançar → ]       ║
╚═══════════════════════════════════════════════════════════════════╝
```

**Descrição**: Configurações AWS com scroll (aparece se escolher "AWS").

---

### 4. Seleção de Componentes

```
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║                Selecione os Componentes                          ║
║                                                                   ║
║         Escolha quais componentes deseja instalar:               ║
║                                                                   ║
║  ┌─────────────────────────────────────────────────────────────┐ ║
║  │  Componentes                                                │ ║
║  │                                                             │ ║
║  │  ☑ Kind (Kubernetes in Docker)    ☐ Harbor (Registry)      │ ║
║  │  ☑ kubectl (Kubernetes CLI)       ☐ GitLab (CI/CD)         │ ║
║  │  ☑ Helm (Package Manager)         ☐ Monitoring             │ ║
║  │  ☑ Ingress Controller              ☐ PostgreSQL Database    │ ║
║  │  ☑ Kubernetes Dashboard            ☐ E-Commerce Demo       │ ║
║  │  ☐ Tech Documentation Site         ☐ Jaeger Tracing        │ ║
║  │                                                             │ ║
║  │         [ Selecionar Todos ]  [ Desmarcar Todos ]          │ ║
║  └─────────────────────────────────────────────────────────────┘ ║
║                                                                   ║
║  [ ← Voltar ]            [ Cancelar ]        [ Avançar → ]       ║
╚═══════════════════════════════════════════════════════════════════╝
```

**Descrição**: Seleção de componentes a serem instalados com checkboxes.

---

### 5. Resumo da Configuração

```
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║               Resumo da Configuração                             ║
║                                                                   ║
║     Revise as configurações antes de iniciar a instalação:       ║
║                                                                   ║
║  ┌─────────────────────────────────────────────────────────────┐ ║
║  │ ════════════════════════════════════════════════════════    │ ║
║  │   RESUMO DA CONFIGURAÇÃO                                    │ ║
║  │ ════════════════════════════════════════════════════════    │ ║
║  │                                                             │ ║
║  │ Provedor: LOCAL                                             │ ║
║  │ ──────────────────────────────────────────────────────────  │ ║
║  │                                                             │ ║
║  │ Tipo de Instalação: minimal                                 │ ║
║  │ Usuário: vagrant                                            │ ║
║  │ Usar ferramentas pré-instaladas: Não                        │ ║
║  │                                                             │ ║
║  │ Componentes Selecionados:                                   │ ║
║  │ ──────────────────────────────────────────────────────────  │ ║
║  │   ✓ Kind (Kubernetes in Docker)                            │ ║
║  │   ✓ kubectl (Kubernetes CLI)                               │ ║
║  │   ✓ Helm (Package Manager)                                 │ ║
║  │   ✓ Ingress Controller                                     │ ║
║  │   ✓ Kubernetes Dashboard                                   │ ║
║  └─────────────────────────────────────────────────────────────┘ ║
║                                                                   ║
║  [ ← Voltar ]            [ Cancelar ]        [ Instalar ]        ║
╚═══════════════════════════════════════════════════════════════════╝
```

**Descrição**: Resumo completo de todas as configurações antes da instalação.

---

### 6. Instalação em Progresso

```
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║              Instalação em Progresso                             ║
║                                                                   ║
║               [████████████████░░░░░░░░░░░░░░]                   ║
║                                                                   ║
║                  Instalando componentes...                       ║
║                                                                   ║
║  ┌─────────────────────────────────────────────────────────────┐ ║
║  │ Comando: ./greencap.sh --local --setup-type minimal ...     │ ║
║  │                                                             │ ║
║  │ [INFO] Iniciando instalação do GreenCap K8s...             │ ║
║  │ [INFO] Verificando requisitos do sistema...                │ ║
║  │ [INFO] Instalando Docker...                                │ ║
║  │ [OK] Docker instalado com sucesso                          │ ║
║  │ [INFO] Instalando Kind...                                  │ ║
║  │ [INFO] Criando cluster Kubernetes...                       │ ║
║  │ Creating cluster "greencap-cluster" ...                    │ ║
║  │ ✓ Ensuring node image (kindest/node:v1.27.3) 🖼           │ ║
║  │ ✓ Preparing nodes 📦                                       │ ║
║  │ ✓ Writing configuration 📜                                 │ ║
║  │ ...                                                        │ ║
║  └─────────────────────────────────────────────────────────────┘ ║
║                                                                   ║
║  [ ← Voltar ]            [ Cancelar ]              [ Avançar → ] ║
╚═══════════════════════════════════════════════════════════════════╝
```

**Descrição**: Barra de progresso animada e log em tempo real da instalação.

---

### 7. Conclusão (Sucesso)

```
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║                                                                   ║
║                Instalação Concluída!                             ║
║                                                                   ║
║                                                                   ║
║     A instalação do GreenCap K8s foi concluída com sucesso!      ║
║                                                                   ║
║               Você pode fechar este assistente agora.            ║
║                                                                   ║
║              Para mais informações, consulte a documentação em:  ║
║              https://github.com/green-cap/greencap-k8s           ║
║                                                                   ║
║                                                                   ║
║                                                                   ║
║                                                                   ║
║                                    [ Concluir ]                  ║
╚═══════════════════════════════════════════════════════════════════╝
```

**Descrição**: Tela final de sucesso.

---

### 7. Conclusão (Falha)

```
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║                                                                   ║
║                  Instalação Falhou                               ║
║                                                                   ║
║                                                                   ║
║              A instalação encontrou erros.                       ║
║                                                                   ║
║           Por favor, verifique os logs na página anterior        ║
║                       e tente novamente.                         ║
║                                                                   ║
║                    Para suporte, visite:                         ║
║            https://github.com/green-cap/greencap-k8s/issues      ║
║                                                                   ║
║                                                                   ║
║                                                                   ║
║                                    [ Concluir ]                  ║
╚═══════════════════════════════════════════════════════════════════╝
```

**Descrição**: Tela final em caso de falha.

---

## 🎨 Elementos de Design

### Cores Utilizadas
- **Verde Primário**: `#2e7d32` - Títulos e elementos de destaque
- **Verde Botões**: `#4CAF50` - Botão "Avançar"
- **Azul Ação**: `#2196F3` - Botão "Instalar"
- **Vermelho**: `#f44336` / `#c62828` - Erros e "Desmarcar"
- **Cinza Fundo**: `#f0f0f0` - Background das páginas
- **Cinza Nav**: `#e0e0e0` - Background da barra de navegação

### Tipografia
- **Títulos**: Arial, 16-18pt, Bold
- **Subtítulos**: Arial, 11pt, Bold
- **Texto Normal**: Arial, 10pt
- **Descrições**: Arial, 9pt, Italic
- **Logs/Código**: Courier, 9pt

### Componentes Principais
- **Radiobuttons**: Seleção única (provedor)
- **Checkboxes**: Seleção múltipla (componentes)
- **Spinboxes**: Valores numéricos (RAM, CPUs)
- **Comboboxes**: Dropdown (tipo de instalação)
- **Entry fields**: Entrada de texto (usuário, IPs)
- **ScrolledText**: Log de saída
- **Progress bar**: Indicação de progresso
- **Frames com borda**: Agrupamento de opções

---

## 📸 Captura de Telas Reais

Para capturar screenshots do wizard em execução:

```bash
# Execute o wizard
./launch_wizard.sh

# Em outro terminal, use scrot ou gnome-screenshot
scrot -u wizard-screenshot.png

# Ou
gnome-screenshot -w -f wizard-screenshot.png
```

---

## 🔄 Fluxo de Navegação

```
Boas-Vindas
    ↓
Seleção de Provedor
    ↓
    ├─→ Config Local ─────┐
    ├─→ Config Vagrant ───┤
    └─→ Config AWS ───────┘
           ↓
    Seleção de Componentes
           ↓
    Resumo da Configuração
           ↓
    Instalação em Progresso
           ↓
       Conclusão
```

---

## 💡 Notas de UX

1. **Validação**: Cada página valida os dados antes de avançar
2. **Feedback**: Mensagens claras de erro e sucesso
3. **Progresso**: Barra animada durante instalação
4. **Navegação**: Botões de voltar/avançar sempre visíveis
5. **Consistência**: Layout uniforme em todas as páginas
6. **Acessibilidade**: Cores contrastantes e fontes legíveis
7. **Responsividade**: Janela de tamanho fixo otimizado (800x650)

---

**Nota**: As representações ASCII acima são aproximações. A interface real usa widgets Tkinter com aparência nativa do sistema operacional.


