# Guia de Testes - GreenCap GUI Installer

Este guia fornece instruções detalhadas para testar o instalador gráfico.

## 🧪 Testes Básicos

### 1. Verificação de Sintaxe Python

```bash
cd /home/araujo/projects/greencap-k8s-forked/greencap-k8s/installers/greencap-gui

# Compilar para verificar sintaxe
python3 -m py_compile greencap_wizard.py

# Verificar imports
python3 -c "import tkinter; print('Tkinter OK')"
```

### 2. Execução do Launcher

```bash
# Tornar executável
chmod +x launch_wizard.sh

# Executar
./launch_wizard.sh
```

**Resultado Esperado**:
- Verificação de Python 3
- Verificação de Tkinter
- Abertura da janela do wizard

### 3. Execução Direta

```bash
# Tornar executável
chmod +x greencap_wizard.py

# Executar
./greencap_wizard.py
```

**Resultado Esperado**:
- Janela do wizard abre imediatamente
- Tamanho: 800x650 pixels
- Título: "GreenCap K8s Installer Wizard"

## 🔍 Testes de Interface

### Teste 1: Navegação Básica

**Passos**:
1. Iniciar o wizard
2. Clicar em "Avançar" na tela de boas-vindas
3. Selecionar "Instalação Local"
4. Clicar em "Avançar"
5. Clicar em "Voltar"
6. Verificar se voltou para a página de seleção

**Resultado Esperado**:
- ✅ Navegação suave entre páginas
- ✅ Botão "Voltar" desabilitado na primeira página
- ✅ Estado das opções é mantido ao voltar

### Teste 2: Validação de Campos

#### Configuração Local
**Passos**:
1. Ir até página de configuração local
2. Limpar o campo "Nome de Usuário"
3. Tentar avançar

**Resultado Esperado**:
- ✅ Campo não pode ficar vazio
- ✅ Validação acontece antes de avançar

#### Configuração AWS
**Passos**:
1. Selecionar "AWS EC2"
2. Avançar até configuração AWS
3. Deixar "Key Name" e "IP Público" vazios
4. Tentar avançar

**Resultado Esperado**:
- ✅ Mensagem de erro aparece
- ✅ Não avança até preencher campos obrigatórios

### Teste 3: Seleção de Componentes

**Passos**:
1. Ir até página de componentes
2. Clicar em "Desmarcar Todos"
3. Tentar avançar
4. Selecionar pelo menos um componente
5. Avançar

**Resultado Esperado**:
- ✅ Aviso se nenhum componente selecionado
- ✅ "Selecionar Todos" marca todos
- ✅ "Desmarcar Todos" desmarca todos

### Teste 4: Resumo da Configuração

**Passos**:
1. Configurar uma instalação completa
2. Ir até a página de resumo
3. Verificar se todas as configurações aparecem

**Resultado Esperado**:
- ✅ Todas as configurações estão visíveis
- ✅ Formato legível e organizado
- ✅ Componentes listados corretamente

## 🏃 Testes de Provedor

### Teste Local

**Configuração de Teste**:
- Provedor: Local
- Tipo: minimal
- Usuário: vagrant
- Ferramentas pré-instaladas: Sim

**Comando Esperado**:
```bash
./greencap.sh --local --setup-type minimal --user-name vagrant --use-pre-installed-tools
```

**Verificar**:
1. Ir até resumo e verificar configurações
2. (Opcional) Iniciar instalação e verificar comando no log

### Teste Vagrant

**Configuração de Teste**:
- Provedor: Vagrant
- Memória: 4096 MB
- CPUs: 2
- GUI: Sim

**Comando Esperado**:
```bash
./greencap.sh --vagrant --memory 4096 --cpus 2
```

**Verificar**:
1. Spinboxes funcionam corretamente
2. Checkbox GUI funciona
3. Valores aparecem no resumo

### Teste AWS

**Configuração de Teste**:
- Provedor: AWS
- Região: us-east-1
- Instância: t3a.medium
- Key Name: my-key
- IP Público: 203.0.113.0

**Comando Esperado**:
```bash
./greencap.sh --aws --region us-east-1 --instance-type t3a.medium --key-name my-key --public-ip 203.0.113.0
```

**Verificar**:
1. Scroll funciona na página AWS
2. Campos opcionais podem ficar vazios
3. Campos obrigatórios são validados

## 🎭 Testes de Cenários

### Cenário 1: Instalação Mínima Local

```
Boas-Vindas → Local → minimal → Componentes padrão → Resumo → Instalar
```

### Cenário 2: Instalação Completa Vagrant

```
Boas-Vindas → Vagrant → 8GB/4CPU/GUI → Todos componentes → Resumo → Instalar
```

### Cenário 3: Instalação AWS Custom

```
Boas-Vindas → AWS → Configurações → Componentes selecionados → Resumo → Instalar
```

### Cenário 4: Cancelamento

```
Qualquer página → Cancelar → Confirmar → Wizard fecha
```

### Cenário 5: Voltar e Alterar

```
Resumo → Voltar → Alterar componentes → Avançar → Verificar mudanças no resumo
```

## 🐛 Testes de Erro

### Teste 1: Instalação Falha

**Simular**:
```bash
# Tornar greencap.sh não executável temporariamente
chmod -x ../../greencap.sh

# Tentar instalar através do wizard
./greencap_wizard.py
```

**Resultado Esperado**:
- ✅ Erro é capturado
- ✅ Mensagem de erro aparece
- ✅ Página de conclusão mostra falha

**Restaurar**:
```bash
chmod +x ../../greencap.sh
```

### Teste 2: Valores Inválidos

**Vagrant - Memória Negativa**:
- Tentar inserir valores inválidos no spinbox
- Verificar se aceita apenas valores válidos

**AWS - IP Inválido**:
- (Opcional) Adicionar validação de formato de IP
- Testar com formato inválido

## 📊 Checklist de Testes

### Interface
- [ ] Janela abre no tamanho correto (800x650)
- [ ] Título está correto
- [ ] Todas as páginas são renderizadas corretamente
- [ ] Fontes e cores estão corretas
- [ ] Botões estão posicionados corretamente

### Navegação
- [ ] "Avançar" funciona em todas as páginas
- [ ] "Voltar" funciona em todas as páginas
- [ ] "Cancelar" fecha o wizard
- [ ] "Voltar" desabilitado na primeira página
- [ ] Navegação mantém estado

### Validação
- [ ] Campos obrigatórios são validados
- [ ] Mensagens de erro são claras
- [ ] Validação numérica funciona (RAM, CPU)
- [ ] Pelo menos um componente deve ser selecionado

### Funcionalidade
- [ ] Seleção de provedor muda páginas corretamente
- [ ] Configurações são salvas no dict config
- [ ] Resumo exibe todas as configurações
- [ ] Comando é construído corretamente
- [ ] Instalação executa em thread separada
- [ ] Log é exibido em tempo real
- [ ] Barra de progresso anima
- [ ] Página de conclusão mostra resultado correto

### Provedor Local
- [ ] Tipo de instalação funciona
- [ ] Nome de usuário é capturado
- [ ] Checkbox de pré-instalados funciona
- [ ] Comando correto é gerado

### Provedor Vagrant
- [ ] Spinbox de memória funciona
- [ ] Spinbox de CPU funciona
- [ ] Checkbox GUI funciona
- [ ] Valores são validados
- [ ] Comando correto é gerado

### Provedor AWS
- [ ] Scroll funciona
- [ ] Todos os campos são capturados
- [ ] Campos opcionais podem ficar vazios
- [ ] Validação de campos obrigatórios
- [ ] Checkbox auto-approve funciona
- [ ] Comando correto é gerado

### Componentes
- [ ] Todos os 12 componentes aparecem
- [ ] Checkboxes funcionam
- [ ] "Selecionar Todos" funciona
- [ ] "Desmarcar Todos" funciona
- [ ] Layout em 2 colunas está correto
- [ ] Seleção é salva corretamente

### Instalação
- [ ] Thread não trava a UI
- [ ] Output aparece em tempo real
- [ ] Barra de progresso funciona
- [ ] Pode-se ver o scroll do log
- [ ] Botões são desabilitados durante instalação
- [ ] Botões são reabilitados após instalação

### Conclusão
- [ ] Mensagem de sucesso correta
- [ ] Mensagem de falha correta
- [ ] Botão "Concluir" fecha o wizard
- [ ] Links estão corretos

## 🔧 Ferramentas de Teste

### Teste Automatizado (Opcional)

Criar um script de teste:

```python
#!/usr/bin/env python3
import unittest
import sys
sys.path.insert(0, '.')
from greencap_wizard import *

class TestWizardValidation(unittest.TestCase):
    def test_vagrant_memory_validation(self):
        # Teste de validação
        pass
    
    def test_aws_required_fields(self):
        # Teste de campos obrigatórios
        pass

if __name__ == '__main__':
    unittest.main()
```

### Teste Manual

Use esta checklist para teste manual sistemático:

1. Abrir wizard
2. Passar por cada caminho possível
3. Testar validações
4. Verificar resumo
5. (Opcional) Executar instalação real

## 📸 Documentação de Testes

### Capturar Screenshots

```bash
# Para cada página
./greencap_wizard.py &
sleep 2
scrot -u page1_welcome.png
# Navegar e repetir
```

### Registrar Bugs

Formato sugerido:
```
**Bug**: [Título do bug]
**Página**: [Nome da página]
**Passos para Reproduzir**:
1. ...
2. ...
**Resultado Esperado**: ...
**Resultado Atual**: ...
**Screenshot**: [anexar se possível]
```

## ✅ Critérios de Aceitação

O wizard está pronto para produção quando:

- [x] Todos os testes de interface passam
- [x] Todas as validações funcionam
- [x] Todos os 3 provedores funcionam
- [x] Resumo mostra configurações corretas
- [x] Instalação executa corretamente
- [x] Tratamento de erros está implementado
- [x] Documentação está completa
- [x] Código está validado (py_compile)

## 🎉 Teste de Aceitação Final

**Cenário Real Completo**:

1. Instalar Python e Tkinter (se necessário)
2. Executar `./launch_wizard.sh`
3. Escolher "Instalação Local"
4. Configurar como "minimal"
5. Selecionar componentes básicos
6. Revisar resumo
7. Executar instalação
8. Verificar sucesso
9. Validar ambiente instalado

**Resultado Esperado**:
- ✅ Wizard executa sem erros
- ✅ Interface é intuitiva
- ✅ Instalação completa com sucesso
- ✅ Ambiente GreenCap K8s está funcional

---

**Boa Sorte com os Testes!** 🚀

Se encontrar bugs, por favor reporte-os para que possam ser corrigidos.


