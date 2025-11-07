#!/usr/bin/env python3
"""
GreenCap K8s Installer Wizard
A graphical installer for GreenCap K8s platform using Tkinter
"""

import tkinter as tk
from tkinter import ttk, messagebox, scrolledtext
import subprocess
import threading
import os
import sys
from pathlib import Path


class WizardPage(tk.Frame):
    """Base class for wizard pages"""
    
    def __init__(self, parent, controller):
        super().__init__(parent)
        self.controller = controller
        self.configure(bg='#f0f0f0')
        
    def validate(self):
        """Validate page data before proceeding"""
        return True
    
    def on_show(self):
        """Called when page is shown"""
        pass


class WelcomePage(WizardPage):
    """Welcome page with introduction"""
    
    def __init__(self, parent, controller):
        super().__init__(parent, controller)
        
        # Title
        title = tk.Label(
            self, 
            text="Bem-vindo ao GreenCap K8s Installer",
            font=('Arial', 18, 'bold'),
            bg='#f0f0f0',
            fg='#2e7d32'
        )
        title.pack(pady=30)
        
        # Description
        desc_frame = tk.Frame(self, bg='#f0f0f0')
        desc_frame.pack(pady=20, padx=40, fill='both', expand=True)
        
        description = """
        Este assistente irá guiá-lo através do processo de instalação do
        GreenCap K8s, uma plataforma completa de desenvolvimento com Kubernetes.
        
        O que será instalado:
        
        • Ambiente Kubernetes local (Kind)
        • Helm para gerenciamento de pacotes
        • Ingress Controller para roteamento
        • Harbor para registry de containers
        • GitLab para CI/CD
        • Monitoring Stack (Prometheus + Grafana)
        • PostgreSQL Database
        • Kubernetes Dashboard
        • Aplicações de exemplo
        
        Requisitos do sistema:
        
        • Sistema operacional: Linux (Ubuntu/Debian recomendado)
        • Memória RAM: mínimo 4GB
        • Espaço em disco: mínimo 20GB
        • Docker instalado (ou será instalado automaticamente)
        
        Clique em "Avançar" para começar a configuração.
        """
        
        desc_label = tk.Label(
            desc_frame,
            text=description,
            font=('Arial', 10),
            bg='#f0f0f0',
            justify='left',
            anchor='w'
        )
        desc_label.pack(fill='both', expand=True)


class ProviderPage(WizardPage):
    """Page for selecting installation provider"""
    
    def __init__(self, parent, controller):
        super().__init__(parent, controller)
        
        # Title
        title = tk.Label(
            self,
            text="Selecione o Tipo de Instalação",
            font=('Arial', 16, 'bold'),
            bg='#f0f0f0'
        )
        title.pack(pady=20)
        
        # Provider selection
        self.provider_var = tk.StringVar(value='local')
        
        providers_frame = tk.LabelFrame(
            self,
            text="Provedor de Ambiente",
            font=('Arial', 11, 'bold'),
            bg='#f0f0f0',
            padx=20,
            pady=20
        )
        providers_frame.pack(pady=20, padx=40, fill='both', expand=True)
        
        # Local installation
        local_radio = tk.Radiobutton(
            providers_frame,
            text="Instalação Local",
            variable=self.provider_var,
            value='local',
            font=('Arial', 10),
            bg='#f0f0f0',
            command=self.on_provider_change
        )
        local_radio.pack(anchor='w', pady=5)
        
        local_desc = tk.Label(
            providers_frame,
            text="    Instalar diretamente na máquina atual",
            font=('Arial', 9, 'italic'),
            bg='#f0f0f0',
            fg='#666'
        )
        local_desc.pack(anchor='w', padx=20)
        
        # Vagrant installation
        vagrant_radio = tk.Radiobutton(
            providers_frame,
            text="Vagrant (VM Local)",
            variable=self.provider_var,
            value='vagrant',
            font=('Arial', 10),
            bg='#f0f0f0',
            command=self.on_provider_change
        )
        vagrant_radio.pack(anchor='w', pady=5, padx=0)
        
        vagrant_desc = tk.Label(
            providers_frame,
            text="    Criar uma máquina virtual local com VirtualBox",
            font=('Arial', 9, 'italic'),
            bg='#f0f0f0',
            fg='#666'
        )
        vagrant_desc.pack(anchor='w', padx=20)
        
        # AWS installation
        aws_radio = tk.Radiobutton(
            providers_frame,
            text="AWS EC2",
            variable=self.provider_var,
            value='aws',
            font=('Arial', 10),
            bg='#f0f0f0',
            command=self.on_provider_change
        )
        aws_radio.pack(anchor='w', pady=5)
        
        aws_desc = tk.Label(
            providers_frame,
            text="    Provisionar infraestrutura na AWS usando Terraform",
            font=('Arial', 9, 'italic'),
            bg='#f0f0f0',
            fg='#666'
        )
        aws_desc.pack(anchor='w', padx=20)
        
    def on_provider_change(self):
        self.controller.config['provider'] = self.provider_var.get()
    
    def validate(self):
        self.controller.config['provider'] = self.provider_var.get()
        return True


class LocalConfigPage(WizardPage):
    """Configuration page for local installation"""
    
    def __init__(self, parent, controller):
        super().__init__(parent, controller)
        
        title = tk.Label(
            self,
            text="Configuração Local",
            font=('Arial', 16, 'bold'),
            bg='#f0f0f0'
        )
        title.pack(pady=20)
        
        config_frame = tk.LabelFrame(
            self,
            text="Opções de Instalação",
            font=('Arial', 11, 'bold'),
            bg='#f0f0f0',
            padx=20,
            pady=20
        )
        config_frame.pack(pady=20, padx=40, fill='both', expand=True)
        
        # Setup type
        setup_label = tk.Label(
            config_frame,
            text="Tipo de Instalação:",
            font=('Arial', 10),
            bg='#f0f0f0'
        )
        setup_label.grid(row=0, column=0, sticky='w', pady=10)
        
        self.setup_type_var = tk.StringVar(value='minimal')
        setup_combo = ttk.Combobox(
            config_frame,
            textvariable=self.setup_type_var,
            values=['minimal', 'full', 'custom'],
            state='readonly',
            width=30
        )
        setup_combo.grid(row=0, column=1, pady=10, padx=10)
        
        # Use pre-installed tools
        self.use_preinstalled_var = tk.BooleanVar(value=False)
        preinstalled_check = tk.Checkbutton(
            config_frame,
            text="Usar Docker/Kind/kubectl já instalados",
            variable=self.use_preinstalled_var,
            font=('Arial', 10),
            bg='#f0f0f0'
        )
        preinstalled_check.grid(row=1, column=0, columnspan=2, sticky='w', pady=10)
        
        # User name
        user_label = tk.Label(
            config_frame,
            text="Nome de Usuário:",
            font=('Arial', 10),
            bg='#f0f0f0'
        )
        user_label.grid(row=2, column=0, sticky='w', pady=10)
        
        self.username_var = tk.StringVar(value=os.getenv('USER', 'vagrant'))
        username_entry = tk.Entry(
            config_frame,
            textvariable=self.username_var,
            width=33
        )
        username_entry.grid(row=2, column=1, pady=10, padx=10)
        
    def validate(self):
        self.controller.config['setup_type'] = self.setup_type_var.get()
        self.controller.config['use_preinstalled'] = self.use_preinstalled_var.get()
        self.controller.config['username'] = self.username_var.get()
        return True


class VagrantConfigPage(WizardPage):
    """Configuration page for Vagrant installation"""
    
    def __init__(self, parent, controller):
        super().__init__(parent, controller)
        
        title = tk.Label(
            self,
            text="Configuração Vagrant",
            font=('Arial', 16, 'bold'),
            bg='#f0f0f0'
        )
        title.pack(pady=20)
        
        config_frame = tk.LabelFrame(
            self,
            text="Recursos da VM",
            font=('Arial', 11, 'bold'),
            bg='#f0f0f0',
            padx=20,
            pady=20
        )
        config_frame.pack(pady=20, padx=40, fill='both', expand=True)
        
        # Memory
        memory_label = tk.Label(
            config_frame,
            text="Memória (MB):",
            font=('Arial', 10),
            bg='#f0f0f0'
        )
        memory_label.grid(row=0, column=0, sticky='w', pady=10)
        
        self.memory_var = tk.StringVar(value='4096')
        memory_spinbox = tk.Spinbox(
            config_frame,
            from_=2048,
            to=16384,
            increment=1024,
            textvariable=self.memory_var,
            width=30
        )
        memory_spinbox.grid(row=0, column=1, pady=10, padx=10)
        
        # CPUs
        cpu_label = tk.Label(
            config_frame,
            text="CPUs:",
            font=('Arial', 10),
            bg='#f0f0f0'
        )
        cpu_label.grid(row=1, column=0, sticky='w', pady=10)
        
        self.cpus_var = tk.StringVar(value='2')
        cpu_spinbox = tk.Spinbox(
            config_frame,
            from_=1,
            to=8,
            textvariable=self.cpus_var,
            width=30
        )
        cpu_spinbox.grid(row=1, column=1, pady=10, padx=10)
        
        # GUI
        self.gui_var = tk.BooleanVar(value=True)
        gui_check = tk.Checkbutton(
            config_frame,
            text="Habilitar Interface Gráfica (GUI)",
            variable=self.gui_var,
            font=('Arial', 10),
            bg='#f0f0f0'
        )
        gui_check.grid(row=2, column=0, columnspan=2, sticky='w', pady=10)
        
    def validate(self):
        try:
            memory = int(self.memory_var.get())
            cpus = int(self.cpus_var.get())
            
            if memory < 2048:
                messagebox.showerror("Erro", "Memória mínima: 2048 MB")
                return False
            
            if cpus < 1:
                messagebox.showerror("Erro", "Número mínimo de CPUs: 1")
                return False
            
            self.controller.config['memory'] = memory
            self.controller.config['cpus'] = cpus
            self.controller.config['gui'] = self.gui_var.get()
            return True
        except ValueError:
            messagebox.showerror("Erro", "Valores inválidos")
            return False


class AWSConfigPage(WizardPage):
    """Configuration page for AWS installation"""
    
    def __init__(self, parent, controller):
        super().__init__(parent, controller)
        
        title = tk.Label(
            self,
            text="Configuração AWS",
            font=('Arial', 16, 'bold'),
            bg='#f0f0f0'
        )
        title.pack(pady=20)
        
        # Scrollable frame for many fields
        canvas = tk.Canvas(self, bg='#f0f0f0')
        scrollbar = ttk.Scrollbar(self, orient="vertical", command=canvas.yview)
        scrollable_frame = tk.Frame(canvas, bg='#f0f0f0')
        
        scrollable_frame.bind(
            "<Configure>",
            lambda e: canvas.configure(scrollregion=canvas.bbox("all"))
        )
        
        canvas.create_window((0, 0), window=scrollable_frame, anchor="nw")
        canvas.configure(yscrollcommand=scrollbar.set)
        
        config_frame = tk.LabelFrame(
            scrollable_frame,
            text="Credenciais e Configuração AWS",
            font=('Arial', 11, 'bold'),
            bg='#f0f0f0',
            padx=20,
            pady=20
        )
        config_frame.pack(pady=20, padx=40, fill='both', expand=True)
        
        # AWS fields
        fields = [
            ('Região:', 'region', 'us-east-1'),
            ('Tipo de Instância:', 'instance_type', 't3a.medium'),
            ('Nome do Key Pair:', 'key_name', ''),
            ('AMI ID (opcional):', 'ami_id', ''),
            ('Subnet ID (opcional):', 'subnet_id', ''),
            ('Security Group ID (opcional):', 'security_group', ''),
            ('Seu IP Público:', 'public_ip', ''),
        ]
        
        self.aws_vars = {}
        
        for idx, (label_text, var_name, default) in enumerate(fields):
            label = tk.Label(
                config_frame,
                text=label_text,
                font=('Arial', 10),
                bg='#f0f0f0'
            )
            label.grid(row=idx, column=0, sticky='w', pady=5)
            
            var = tk.StringVar(value=default)
            self.aws_vars[var_name] = var
            
            entry = tk.Entry(config_frame, textvariable=var, width=35)
            entry.grid(row=idx, column=1, pady=5, padx=10)
        
        # Auto approve
        self.auto_approve_var = tk.BooleanVar(value=False)
        auto_approve_check = tk.Checkbutton(
            config_frame,
            text="Auto-aprovar Terraform (sem confirmação)",
            variable=self.auto_approve_var,
            font=('Arial', 10),
            bg='#f0f0f0'
        )
        auto_approve_check.grid(row=len(fields), column=0, columnspan=2, sticky='w', pady=10)
        
        canvas.pack(side="left", fill="both", expand=True)
        scrollbar.pack(side="right", fill="y")
        
    def validate(self):
        # Check required fields
        if not self.aws_vars['key_name'].get():
            messagebox.showerror("Erro", "Nome do Key Pair é obrigatório")
            return False
        
        if not self.aws_vars['public_ip'].get():
            messagebox.showerror("Erro", "IP Público é obrigatório")
            return False
        
        # Save config
        for key, var in self.aws_vars.items():
            self.controller.config[f'aws_{key}'] = var.get()
        
        self.controller.config['aws_auto_approve'] = self.auto_approve_var.get()
        return True


class ComponentsPage(WizardPage):
    """Page for selecting components to install"""
    
    def __init__(self, parent, controller):
        super().__init__(parent, controller)
        
        title = tk.Label(
            self,
            text="Selecione os Componentes",
            font=('Arial', 16, 'bold'),
            bg='#f0f0f0'
        )
        title.pack(pady=20)
        
        desc = tk.Label(
            self,
            text="Escolha quais componentes deseja instalar:",
            font=('Arial', 10),
            bg='#f0f0f0'
        )
        desc.pack(pady=10)
        
        # Components frame
        components_frame = tk.LabelFrame(
            self,
            text="Componentes",
            font=('Arial', 11, 'bold'),
            bg='#f0f0f0',
            padx=20,
            pady=20
        )
        components_frame.pack(pady=20, padx=40, fill='both', expand=True)
        
        # Component checkboxes
        self.components = {
            'kind': ('Kind (Kubernetes in Docker)', True),
            'kubectl': ('kubectl (Kubernetes CLI)', True),
            'helm': ('Helm (Package Manager)', True),
            'ingress': ('Ingress Controller', True),
            'harbor': ('Harbor (Container Registry)', False),
            'gitlab': ('GitLab (CI/CD)', False),
            'monitoring': ('Monitoring (Prometheus + Grafana)', False),
            'postgres': ('PostgreSQL Database', False),
            'dashboard': ('Kubernetes Dashboard', True),
            'ecom': ('E-Commerce Demo App', False),
            'techdocs': ('Tech Documentation Site', False),
            'tracing': ('Jaeger Tracing', False),
        }
        
        self.component_vars = {}
        
        row = 0
        col = 0
        for key, (label, default) in self.components.items():
            var = tk.BooleanVar(value=default)
            self.component_vars[key] = var
            
            check = tk.Checkbutton(
                components_frame,
                text=label,
                variable=var,
                font=('Arial', 10),
                bg='#f0f0f0'
            )
            check.grid(row=row, column=col, sticky='w', pady=5, padx=10)
            
            col += 1
            if col > 1:
                col = 0
                row += 1
        
        # Select all / Deselect all buttons
        button_frame = tk.Frame(components_frame, bg='#f0f0f0')
        button_frame.grid(row=row+1, column=0, columnspan=2, pady=15)
        
        select_all_btn = tk.Button(
            button_frame,
            text="Selecionar Todos",
            command=self.select_all,
            bg='#4CAF50',
            fg='white',
            font=('Arial', 9),
            padx=10
        )
        select_all_btn.pack(side='left', padx=5)
        
        deselect_all_btn = tk.Button(
            button_frame,
            text="Desmarcar Todos",
            command=self.deselect_all,
            bg='#f44336',
            fg='white',
            font=('Arial', 9),
            padx=10
        )
        deselect_all_btn.pack(side='left', padx=5)
    
    def select_all(self):
        for var in self.component_vars.values():
            var.set(True)
    
    def deselect_all(self):
        for var in self.component_vars.values():
            var.set(False)
    
    def validate(self):
        selected = [key for key, var in self.component_vars.items() if var.get()]
        
        if not selected:
            messagebox.showwarning("Aviso", "Selecione pelo menos um componente")
            return False
        
        self.controller.config['components'] = selected
        return True


class SummaryPage(WizardPage):
    """Summary page showing configuration before installation"""
    
    def __init__(self, parent, controller):
        super().__init__(parent, controller)
        
        title = tk.Label(
            self,
            text="Resumo da Configuração",
            font=('Arial', 16, 'bold'),
            bg='#f0f0f0'
        )
        title.pack(pady=20)
        
        desc = tk.Label(
            self,
            text="Revise as configurações antes de iniciar a instalação:",
            font=('Arial', 10),
            bg='#f0f0f0'
        )
        desc.pack(pady=10)
        
        # Summary text
        self.summary_text = scrolledtext.ScrolledText(
            self,
            width=70,
            height=20,
            font=('Courier', 9),
            wrap=tk.WORD
        )
        self.summary_text.pack(pady=20, padx=40, fill='both', expand=True)
        
    def on_show(self):
        """Update summary when page is shown"""
        self.summary_text.delete('1.0', tk.END)
        
        config = self.controller.config
        summary = "═" * 60 + "\n"
        summary += "  RESUMO DA CONFIGURAÇÃO\n"
        summary += "═" * 60 + "\n\n"
        
        # Provider
        provider = config.get('provider', 'local')
        summary += f"Provedor: {provider.upper()}\n"
        summary += "─" * 60 + "\n\n"
        
        if provider == 'local':
            summary += f"Tipo de Instalação: {config.get('setup_type', 'minimal')}\n"
            summary += f"Usuário: {config.get('username', 'vagrant')}\n"
            summary += f"Usar ferramentas pré-instaladas: {'Sim' if config.get('use_preinstalled') else 'Não'}\n\n"
        
        elif provider == 'vagrant':
            summary += f"Memória: {config.get('memory', 4096)} MB\n"
            summary += f"CPUs: {config.get('cpus', 2)}\n"
            summary += f"Interface Gráfica: {'Sim' if config.get('gui') else 'Não'}\n\n"
        
        elif provider == 'aws':
            summary += f"Região: {config.get('aws_region', 'us-east-1')}\n"
            summary += f"Tipo de Instância: {config.get('aws_instance_type', 't3a.medium')}\n"
            summary += f"Key Pair: {config.get('aws_key_name', '')}\n"
            summary += f"IP Público: {config.get('aws_public_ip', '')}\n"
            if config.get('aws_ami_id'):
                summary += f"AMI ID: {config.get('aws_ami_id')}\n"
            if config.get('aws_subnet_id'):
                summary += f"Subnet ID: {config.get('aws_subnet_id')}\n"
            if config.get('aws_security_group'):
                summary += f"Security Group: {config.get('aws_security_group')}\n"
            summary += f"Auto-aprovar: {'Sim' if config.get('aws_auto_approve') else 'Não'}\n\n"
        
        # Components
        summary += "Componentes Selecionados:\n"
        summary += "─" * 60 + "\n"
        components = config.get('components', [])
        for comp in components:
            comp_name = self.get_component_name(comp)
            summary += f"  ✓ {comp_name}\n"
        
        summary += "\n" + "═" * 60 + "\n"
        
        self.summary_text.insert('1.0', summary)
        self.summary_text.config(state='disabled')
    
    def get_component_name(self, key):
        names = {
            'kind': 'Kind (Kubernetes in Docker)',
            'kubectl': 'kubectl (Kubernetes CLI)',
            'helm': 'Helm (Package Manager)',
            'ingress': 'Ingress Controller',
            'harbor': 'Harbor (Container Registry)',
            'gitlab': 'GitLab (CI/CD)',
            'monitoring': 'Monitoring (Prometheus + Grafana)',
            'postgres': 'PostgreSQL Database',
            'dashboard': 'Kubernetes Dashboard',
            'ecom': 'E-Commerce Demo App',
            'techdocs': 'Tech Documentation Site',
            'tracing': 'Jaeger Tracing',
        }
        return names.get(key, key)


class InstallationPage(WizardPage):
    """Installation progress page"""
    
    def __init__(self, parent, controller):
        super().__init__(parent, controller)
        
        title = tk.Label(
            self,
            text="Instalação em Progresso",
            font=('Arial', 16, 'bold'),
            bg='#f0f0f0'
        )
        title.pack(pady=20)
        
        # Progress bar
        self.progress = ttk.Progressbar(
            self,
            length=500,
            mode='indeterminate'
        )
        self.progress.pack(pady=20)
        
        # Status label
        self.status_label = tk.Label(
            self,
            text="Preparando instalação...",
            font=('Arial', 10),
            bg='#f0f0f0'
        )
        self.status_label.pack(pady=10)
        
        # Output text
        self.output_text = scrolledtext.ScrolledText(
            self,
            width=80,
            height=20,
            font=('Courier', 9),
            wrap=tk.WORD
        )
        self.output_text.pack(pady=20, padx=40, fill='both', expand=True)
        
        self.is_installing = False
        
    def on_show(self):
        """Start installation when page is shown"""
        if not self.is_installing:
            self.is_installing = True
            self.start_installation()
    
    def start_installation(self):
        """Start installation in background thread"""
        self.progress.start(10)
        self.controller.disable_navigation()
        
        thread = threading.Thread(target=self.run_installation, daemon=True)
        thread.start()
    
    def run_installation(self):
        """Run the installation process"""
        try:
            config = self.controller.config
            
            # Build greencap.sh command
            cmd = self.build_command(config)
            
            self.update_status("Executando instalação...")
            self.append_output(f"Comando: {' '.join(cmd)}\n\n")
            
            # Get script directory
            script_dir = Path(__file__).parent.parent.parent
            
            # Execute command
            process = subprocess.Popen(
                cmd,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                universal_newlines=True,
                cwd=script_dir
            )
            
            # Read output line by line
            for line in process.stdout:
                self.append_output(line)
            
            process.wait()
            
            if process.returncode == 0:
                self.update_status("Instalação concluída com sucesso!")
                self.append_output("\n✓ Instalação finalizada com sucesso!\n")
                self.controller.installation_success = True
            else:
                self.update_status("Instalação falhou!")
                self.append_output(f"\n✗ Instalação falhou com código: {process.returncode}\n")
                self.controller.installation_success = False
            
        except Exception as e:
            self.update_status(f"Erro: {str(e)}")
            self.append_output(f"\n✗ Erro durante instalação: {str(e)}\n")
            self.controller.installation_success = False
        
        finally:
            self.progress.stop()
            self.controller.enable_navigation()
            self.controller.show_next_button()
    
    def build_command(self, config):
        """Build the greencap.sh command from config"""
        cmd = ['./greencap.sh']
        
        provider = config.get('provider', 'local')
        
        if provider == 'local':
            cmd.append('--local')
            cmd.extend(['--setup-type', config.get('setup_type', 'minimal')])
            cmd.extend(['--user-name', config.get('username', 'vagrant')])
            if config.get('use_preinstalled'):
                cmd.append('--use-pre-installed-tools')
        
        elif provider == 'vagrant':
            cmd.append('--vagrant')
            cmd.extend(['--memory', str(config.get('memory', 4096))])
            cmd.extend(['--cpus', str(config.get('cpus', 2))])
            if not config.get('gui', True):
                cmd.append('--no-gui')
        
        elif provider == 'aws':
            cmd.append('--aws')
            cmd.extend(['--region', config.get('aws_region', 'us-east-1')])
            cmd.extend(['--instance-type', config.get('aws_instance_type', 't3a.medium')])
            cmd.extend(['--key-name', config.get('aws_key_name', '')])
            cmd.extend(['--public-ip', config.get('aws_public_ip', '')])
            
            if config.get('aws_ami_id'):
                cmd.extend(['--ami-id', config.get('aws_ami_id')])
            if config.get('aws_subnet_id'):
                cmd.extend(['--subnet-id', config.get('aws_subnet_id')])
            if config.get('aws_security_group'):
                cmd.extend(['--security-group', config.get('aws_security_group')])
            if config.get('aws_auto_approve'):
                cmd.append('--auto-approve')
        
        return cmd
    
    def update_status(self, text):
        """Update status label from any thread"""
        self.status_label.config(text=text)
    
    def append_output(self, text):
        """Append text to output from any thread"""
        self.output_text.insert(tk.END, text)
        self.output_text.see(tk.END)
        self.output_text.update()


class CompletionPage(WizardPage):
    """Completion page"""
    
    def __init__(self, parent, controller):
        super().__init__(parent, controller)
        
        self.title_label = tk.Label(
            self,
            text="",
            font=('Arial', 18, 'bold'),
            bg='#f0f0f0'
        )
        self.title_label.pack(pady=30)
        
        self.message_label = tk.Label(
            self,
            text="",
            font=('Arial', 11),
            bg='#f0f0f0',
            justify='center'
        )
        self.message_label.pack(pady=20, padx=40)
        
    def on_show(self):
        """Update message based on installation result"""
        if self.controller.installation_success:
            self.title_label.config(
                text="Instalação Concluída!",
                fg='#2e7d32'
            )
            message = """
            A instalação do GreenCap K8s foi concluída com sucesso!
            
            Você pode fechar este assistente agora.
            
            Para mais informações, consulte a documentação em:
            https://github.com/green-cap/greencap-k8s
            """
            self.message_label.config(text=message)
        else:
            self.title_label.config(
                text="Instalação Falhou",
                fg='#c62828'
            )
            message = """
            A instalação encontrou erros.
            
            Por favor, verifique os logs na página anterior
            e tente novamente.
            
            Para suporte, visite:
            https://github.com/green-cap/greencap-k8s/issues
            """
            self.message_label.config(text=message)


class GreenCapWizard(tk.Tk):
    """Main wizard application"""
    
    def __init__(self):
        super().__init__()
        
        self.title("GreenCap K8s Installer Wizard")
        self.geometry("800x650")
        self.resizable(False, False)
        
        # Configuration storage
        self.config = {}
        self.installation_success = False
        
        # Current page index
        self.current_page = 0
        
        # Create pages
        self.pages = []
        self.page_order = []
        
        # Container for pages
        container = tk.Frame(self)
        container.pack(fill='both', expand=True)
        
        # Initialize all pages
        self.welcome_page = WelcomePage(container, self)
        self.provider_page = ProviderPage(container, self)
        self.local_config_page = LocalConfigPage(container, self)
        self.vagrant_config_page = VagrantConfigPage(container, self)
        self.aws_config_page = AWSConfigPage(container, self)
        self.components_page = ComponentsPage(container, self)
        self.summary_page = SummaryPage(container, self)
        self.installation_page = InstallationPage(container, self)
        self.completion_page = CompletionPage(container, self)
        
        # Place all pages in the same location
        for page in [self.welcome_page, self.provider_page, self.local_config_page,
                     self.vagrant_config_page, self.aws_config_page, self.components_page,
                     self.summary_page, self.installation_page, self.completion_page]:
            page.place(x=0, y=0, relwidth=1, relheight=1)
        
        # Navigation buttons frame
        self.nav_frame = tk.Frame(self, bg='#e0e0e0', height=60)
        self.nav_frame.pack(side='bottom', fill='x')
        
        self.back_button = tk.Button(
            self.nav_frame,
            text="← Voltar",
            command=self.go_back,
            font=('Arial', 10),
            width=12,
            state='disabled'
        )
        self.back_button.pack(side='left', padx=20, pady=15)
        
        self.next_button = tk.Button(
            self.nav_frame,
            text="Avançar →",
            command=self.go_next,
            font=('Arial', 10),
            width=12,
            bg='#4CAF50',
            fg='white'
        )
        self.next_button.pack(side='right', padx=20, pady=15)
        
        self.cancel_button = tk.Button(
            self.nav_frame,
            text="Cancelar",
            command=self.cancel,
            font=('Arial', 10),
            width=12
        )
        self.cancel_button.pack(side='right', padx=10, pady=15)
        
        # Start with welcome page
        self.update_page_order()
        self.show_page(0)
    
    def update_page_order(self):
        """Update page order based on provider selection"""
        self.page_order = [
            self.welcome_page,
            self.provider_page,
        ]
        
        provider = self.config.get('provider', 'local')
        
        if provider == 'local':
            self.page_order.append(self.local_config_page)
        elif provider == 'vagrant':
            self.page_order.append(self.vagrant_config_page)
        elif provider == 'aws':
            self.page_order.append(self.aws_config_page)
        
        self.page_order.extend([
            self.components_page,
            self.summary_page,
            self.installation_page,
            self.completion_page
        ])
    
    def show_page(self, index):
        """Show page at given index"""
        if 0 <= index < len(self.page_order):
            self.current_page = index
            page = self.page_order[index]
            page.tkraise()
            page.on_show()
            
            # Update navigation buttons
            self.back_button['state'] = 'normal' if index > 0 else 'disabled'
            
            # Update next button text
            if index == len(self.page_order) - 2:  # Installation page
                self.next_button.config(text="Instalar", bg='#2196F3')
                self.next_button.pack_forget()  # Hide until installation completes
            elif index == len(self.page_order) - 1:  # Completion page
                self.next_button.config(text="Concluir", bg='#4CAF50')
                self.next_button.pack(side='right', padx=20, pady=15)
                self.cancel_button.pack_forget()
            else:
                self.next_button.config(text="Avançar →", bg='#4CAF50')
                self.next_button.pack(side='right', padx=20, pady=15)
    
    def go_next(self):
        """Go to next page"""
        current = self.page_order[self.current_page]
        
        # Validate current page
        if not current.validate():
            return
        
        # Special handling for provider page
        if current == self.provider_page:
            self.update_page_order()
        
        # Move to next page or finish
        if self.current_page < len(self.page_order) - 1:
            self.show_page(self.current_page + 1)
        else:
            self.finish()
    
    def go_back(self):
        """Go to previous page"""
        if self.current_page > 0:
            # Don't allow going back from installation or completion page
            if self.current_page >= len(self.page_order) - 2:
                return
            
            # Special handling for provider page
            if self.page_order[self.current_page - 1] == self.provider_page:
                self.update_page_order()
            
            self.show_page(self.current_page - 1)
    
    def cancel(self):
        """Cancel wizard"""
        if messagebox.askyesno("Cancelar", "Deseja realmente cancelar a instalação?"):
            self.quit()
    
    def finish(self):
        """Finish wizard"""
        self.quit()
    
    def disable_navigation(self):
        """Disable navigation buttons during installation"""
        self.back_button['state'] = 'disabled'
        self.next_button['state'] = 'disabled'
        self.cancel_button['state'] = 'disabled'
    
    def enable_navigation(self):
        """Enable navigation buttons after installation"""
        self.back_button['state'] = 'normal'
        self.next_button['state'] = 'normal'
        self.cancel_button['state'] = 'normal'
    
    def show_next_button(self):
        """Show next button after installation"""
        self.next_button.pack(side='right', padx=20, pady=15)


def main():
    """Main entry point"""
    app = GreenCapWizard()
    app.mainloop()


if __name__ == '__main__':
    main()


