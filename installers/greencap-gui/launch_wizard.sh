#!/bin/bash
#
# GreenCap K8s Installer Wizard Launcher
# This script checks dependencies and launches the GUI installer
#

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║         GreenCap K8s Installer Wizard Launcher           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}✗ Python 3 não está instalado!${NC}"
    echo "Por favor, instale Python 3 antes de continuar."
    echo ""
    echo "Ubuntu/Debian: sudo apt-get install python3"
    echo "Fedora: sudo dnf install python3"
    echo "Arch: sudo pacman -S python"
    exit 1
fi

echo -e "${GREEN}✓ Python 3 encontrado:${NC} $(python3 --version)"

# Check if Tkinter is available
if ! python3 -c "import tkinter" &> /dev/null; then
    echo -e "${YELLOW}⚠ Tkinter não está instalado!${NC}"
    echo ""
    echo "Tkinter é necessário para a interface gráfica."
    echo "Instale com um dos seguintes comandos:"
    echo ""
    echo "Ubuntu/Debian: sudo apt-get install python3-tk"
    echo "Fedora: sudo dnf install python3-tkinter"
    echo "Arch: sudo pacman -S tk"
    echo ""
    read -p "Deseja tentar instalar automaticamente? (requer sudo) [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y python3-tk
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y python3-tkinter
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm tk
        else
            echo -e "${RED}✗ Não foi possível detectar o gerenciador de pacotes.${NC}"
            echo "Por favor, instale o Tkinter manualmente."
            exit 1
        fi
        
        # Check again
        if ! python3 -c "import tkinter" &> /dev/null; then
            echo -e "${RED}✗ Instalação falhou. Instale o Tkinter manualmente.${NC}"
            exit 1
        fi
    else
        echo "Instalação cancelada."
        exit 1
    fi
fi

echo -e "${GREEN}✓ Tkinter encontrado${NC}"

# Check if greencap.sh exists
GREENCAP_SCRIPT="$SCRIPT_DIR/../../greencap.sh"
if [ ! -f "$GREENCAP_SCRIPT" ]; then
    echo -e "${YELLOW}⚠ Aviso: greencap.sh não encontrado em $GREENCAP_SCRIPT${NC}"
    echo "O wizard pode não funcionar corretamente."
fi

# Make wizard executable
chmod +x "$SCRIPT_DIR/greencap_wizard.py" 2>/dev/null || true

echo ""
echo -e "${GREEN}Iniciando GreenCap K8s Installer Wizard...${NC}"
echo ""

# Launch the wizard
cd "$SCRIPT_DIR"
python3 greencap_wizard.py

echo ""
echo -e "${GREEN}Wizard encerrado.${NC}"


