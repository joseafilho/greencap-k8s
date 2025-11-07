# GreenCap K8s Installer Wizard

Um instalador gráfico tipo wizard para o GreenCap K8s, desenvolvido em Python usando Tkinter.

## 📋 Descrição

Este instalador fornece uma interface gráfica amigável para configurar e instalar o ambiente GreenCap K8s. O wizard guia o usuário através de todas as etapas necessárias, desde a seleção do tipo de instalação até a configuração dos componentes.

## ✨ Características

- **Interface Gráfica Intuitiva**: Wizard passo a passo com navegação fácil
- **Múltiplos Tipos de Instalação**:
  - Instalação Local (diretamente na máquina)
  - Vagrant (máquina virtual local)
  - AWS EC2 (cloud)
- **Seleção de Componentes**: Escolha quais componentes instalar
- **Resumo da Configuração**: Revise antes de instalar
- **Log em Tempo Real**: Acompanhe o progresso da instalação
- **Interface em Português**: Totalmente traduzida

## 🔧 Requisitos

### Sistema Operacional
- Linux (Ubuntu, Debian, Fedora, Arch, etc.)
- Python 3.6 ou superior

### Dependências
- Python 3
- Tkinter (geralmente já incluído com Python)

### Instalação do Tkinter (se necessário)

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install python3-tk
```

**Fedora:**
```bash
sudo dnf install python3-tkinter
```

**Arch Linux:**
```bash
sudo pacman -S tk
```

## 🚀 Como Usar

### Método 1: Executar Diretamente

```bash
# Tornar o script executável
chmod +x greencap_wizard.py

# Executar o wizard
./greencap_wizard.py
```

### Método 2: Usar o Launcher

```bash
# Tornar o launcher executável
chmod +x launch_wizard.sh

# Executar
./launch_wizard.sh
```

### Método 3: Usar Python Diretamente

```bash
python3 greencap_wizard.py
```

## 📖 Guia de Uso

### 1. Tela de Boas-Vindas
- Leia as informações sobre o que será instalado
- Verifique os requisitos do sistema
- Clique em "Avançar" para continuar

### 2. Seleção do Tipo de Instalação
Escolha entre:
- **Instalação Local**: Instala diretamente na máquina atual
- **Vagrant**: Cria uma VM local com VirtualBox
- **AWS EC2**: Provisiona infraestrutura na nuvem AWS

### 3. Configuração Específica
Dependendo do tipo escolhido, configure:

**Local:**
- Tipo de instalação (minimal/full/custom)
- Nome de usuário
- Usar ferramentas pré-instaladas

**Vagrant:**
- Quantidade de memória RAM
- Número de CPUs
- Interface gráfica (GUI)

**AWS:**
- Região
- Tipo de instância
- Credenciais e configurações de rede

### 4. Seleção de Componentes
Escolha quais componentes instalar:
- Kind (Kubernetes in Docker)
- kubectl
- Helm
- Ingress Controller
- Harbor (Container Registry)
- GitLab (CI/CD)
- Monitoring (Prometheus + Grafana)
- PostgreSQL
- Kubernetes Dashboard
- E muito mais...

### 5. Resumo
- Revise todas as configurações
- Confirme se está tudo correto
- Clique em "Instalar" para iniciar

### 6. Instalação
- Acompanhe o progresso em tempo real
- Veja os logs da instalação
- Aguarde a conclusão

### 7. Conclusão
- Visualize o resultado da instalação
- Acesse as informações de próximos passos

## 🎨 Screenshots

O wizard possui uma interface moderna e limpa com:
- Design responsivo
- Cores agradáveis (tema verde)
- Ícones e elementos visuais claros
- Fonte legível

## 🏗️ Estrutura do Projeto

```
greencap-gui/
├── greencap_wizard.py      # Aplicação principal
├── launch_wizard.sh         # Script de inicialização
├── greencap-installer.desktop  # Atalho do desktop
├── requirements.txt         # Dependências
└── README.md               # Esta documentação
```

## 🔧 Desenvolvimento

### Arquitetura

O wizard é construído com uma arquitetura modular:
- **WizardPage**: Classe base para todas as páginas
- **GreenCapWizard**: Controlador principal
- Cada tela é uma classe separada que herda de WizardPage

### Páginas Implementadas

1. **WelcomePage**: Tela de boas-vindas
2. **ProviderPage**: Seleção do provedor
3. **LocalConfigPage**: Configuração local
4. **VagrantConfigPage**: Configuração Vagrant
5. **AWSConfigPage**: Configuração AWS
6. **ComponentsPage**: Seleção de componentes
7. **SummaryPage**: Resumo da configuração
8. **InstallationPage**: Processo de instalação
9. **CompletionPage**: Tela de conclusão

### Adicionar Nova Página

```python
class MyNewPage(WizardPage):
    def __init__(self, parent, controller):
        super().__init__(parent, controller)
        # Adicionar widgets aqui
        
    def validate(self):
        # Validar dados antes de avançar
        return True
    
    def on_show(self):
        # Executado quando a página é exibida
        pass
```

## 🐛 Solução de Problemas

### Erro: "No module named 'tkinter'"
Instale o Tkinter conforme as instruções de instalação acima.

### Erro: "Permission denied"
Torne o script executável:
```bash
chmod +x greencap_wizard.py
```

### Interface não aparece
Certifique-se de que está em um ambiente com display gráfico (não SSH sem X11).

### Instalação falha
- Verifique os logs na tela de instalação
- Certifique-se de ter as permissões necessárias
- Verifique a conexão com a internet

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para:
- Reportar bugs
- Sugerir novas funcionalidades
- Enviar pull requests
- Melhorar a documentação

## 📝 Licença

Este projeto segue a mesma licença do GreenCap K8s.

## 🔗 Links Úteis

- [GreenCap K8s Repository](https://github.com/green-cap/greencap-k8s)
- [Documentação Tkinter](https://docs.python.org/3/library/tkinter.html)
- [Python Documentation](https://docs.python.org/3/)

## 👥 Autores

Desenvolvido para o projeto GreenCap K8s.

## 📞 Suporte

Para suporte e questões:
- Abra uma issue no GitHub
- Consulte a documentação do GreenCap K8s
- Entre em contato com a equipe de desenvolvimento


