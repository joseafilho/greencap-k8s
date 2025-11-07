# Quick Start - GreenCap GUI Installer

Guia de início rápido de 2 minutos para executar o instalador.

## 🚀 Em 3 Passos

### 1️⃣ Navegue até o diretório

```bash
cd /home/araujo/projects/greencap-k8s-forked/greencap-k8s/installers/greencap-gui
```

### 2️⃣ Torne o launcher executável

```bash
chmod +x launch_wizard.sh
```

### 3️⃣ Execute!

```bash
./launch_wizard.sh
```

**Pronto!** 🎉 O wizard irá abrir automaticamente.

---

## 📋 Primeira Instalação

Se for a primeira vez, siga o fluxo básico:

1. **Boas-Vindas** → Clique em "Avançar"

2. **Tipo de Instalação** → Selecione "Instalação Local"

3. **Configuração** → Use os valores padrão

4. **Componentes** → Mantenha os básicos marcados

5. **Resumo** → Revise e clique em "Instalar"

6. **Aguarde** → A instalação será executada

7. **Concluído** → Clique em "Concluir"

---

## ⚠️ Problemas?

### Erro: "Tkinter não encontrado"

```bash
# Ubuntu/Debian
sudo apt-get install python3-tk

# Fedora
sudo dnf install python3-tkinter

# Arch
sudo pacman -S tk
```

### Erro: "Permission denied"

```bash
chmod +x launch_wizard.sh greencap_wizard.py
```

---

## 📚 Mais Informações

- Documentação completa: `README.md`
- Guia de instalação: `INSTALL.md`
- Testes: `TESTING.md`

---

**Boa instalação!** 🚀


