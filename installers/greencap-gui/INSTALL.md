# Guia de Instalação e Execução

Este guia rápido mostra como instalar e executar o GreenCap K8s Installer Wizard.

## 🚀 Início Rápido

### 1. Clone o Repositório (se ainda não fez)

```bash
git clone https://github.com/green-cap/greencap-k8s.git
cd greencap-k8s/installers/greencap-gui
```

### 2. Instale as Dependências

**Python 3:**

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install python3

# Fedora
sudo dnf install python3

# Arch Linux
sudo pacman -S python
```

**Tkinter (interface gráfica):**

```bash
# Ubuntu/Debian
sudo apt-get install python3-tk

# Fedora
sudo dnf install python3-tkinter

# Arch Linux
sudo pacman -S tk
```

### 3. Execute o Wizard

#### Opção A: Usando o Launcher (Recomendado)

```bash
chmod +x launch_wizard.sh
./launch_wizard.sh
```

O launcher irá:
- Verificar se Python 3 está instalado
- Verificar se Tkinter está disponível
- Oferecer instalação automática de dependências
- Iniciar o wizard

#### Opção B: Execução Direta

```bash
chmod +x greencap_wizard.py
./greencap_wizard.py
```

#### Opção C: Com Python

```bash
python3 greencap_wizard.py
```

## 🖥️ Criando Atalho no Desktop

Para criar um atalho na área de trabalho no Linux:

```bash
# Copiar o arquivo .desktop para o desktop
cp greencap-installer.desktop ~/Desktop/

# Tornar executável
chmod +x ~/Desktop/greencap-installer.desktop

# Ou instalar no sistema (disponível no menu de aplicativos)
sudo cp greencap-installer.desktop /usr/share/applications/
```

Após isso, você poderá encontrar "GreenCap K8s Installer" no menu de aplicativos ou clicar no atalho do desktop.

## 📋 Requisitos do Sistema

### Mínimo
- **SO**: Linux (qualquer distribuição)
- **RAM**: 2GB livres
- **Disco**: 10GB livres
- **Python**: 3.6+
- **Display**: Interface gráfica (X11 ou Wayland)

### Recomendado (para instalação local)
- **RAM**: 4GB+ livres
- **Disco**: 20GB+ livres
- **CPU**: 2+ cores

### Para instalação Vagrant
- **VirtualBox**: 6.0+
- **Vagrant**: 2.2+
- **RAM**: 6GB+ total (4GB para VM)

### Para instalação AWS
- **AWS CLI**: configurado
- **Terraform**: 1.0+
- **Credenciais AWS**: com permissões adequadas

## 🐛 Solução de Problemas

### Erro: "No module named 'tkinter'"

```bash
# Instale o Tkinter conforme as instruções acima
sudo apt-get install python3-tk  # Ubuntu/Debian
```

### Erro: "Permission denied"

```bash
# Torne os scripts executáveis
chmod +x launch_wizard.sh greencap_wizard.py
```

### Erro: "Display not found" ou "Can't connect to X server"

Você está em uma sessão SSH sem suporte gráfico. Opções:
- Use SSH com X11 forwarding: `ssh -X user@host`
- Use o script CLI original: `../../greencap.sh`
- Execute em uma máquina com interface gráfica

### Wizard não inicia

```bash
# Verifique a versão do Python
python3 --version  # Deve ser 3.6+

# Teste se Tkinter funciona
python3 -c "import tkinter; tkinter.Tk()"
```

### Erro durante a instalação

- Verifique os logs na tela de instalação do wizard
- Verifique se tem permissões adequadas (pode precisar de sudo)
- Verifique conexão com internet
- Verifique se há espaço em disco suficiente

## 📝 Notas Adicionais

### Executar sem Interface Gráfica

Se você não tem interface gráfica disponível, use o script CLI original:

```bash
cd ../..
./greencap.sh --help
```

### Executar em SSH com GUI

Se estiver conectado via SSH e quiser usar a interface gráfica:

```bash
# No cliente SSH
ssh -X user@host

# No servidor
./launch_wizard.sh
```

### Desenvolvimento

Para desenvolver ou modificar o wizard:

```bash
# Instale um editor de código
code greencap_wizard.py  # VS Code
vim greencap_wizard.py   # Vim

# O código está bem documentado e modular
# Cada página é uma classe separada
```

## 🔗 Links Úteis

- [README Principal](./README.md)
- [Documentação GreenCap K8s](../../README.md)
- [Tkinter Documentation](https://docs.python.org/3/library/tkinter.html)

## 💡 Dicas

1. **Primeira vez**: Use a instalação "minimal" para testar
2. **Produção**: Use "full" para ter todos os componentes
3. **Desenvolvimento**: Use "custom" para escolher componentes específicos
4. **Vagrant**: Melhor opção para isolar do sistema principal
5. **AWS**: Para demonstrações ou ambientes cloud

## ✅ Checklist de Instalação

- [ ] Python 3.6+ instalado
- [ ] Tkinter instalado
- [ ] Scripts com permissão de execução
- [ ] Conexão com internet ativa
- [ ] Espaço em disco suficiente
- [ ] (Vagrant) VirtualBox instalado
- [ ] (AWS) Credenciais configuradas

---

**Pronto!** Agora você está preparado para instalar o GreenCap K8s usando o wizard gráfico. 🎉


