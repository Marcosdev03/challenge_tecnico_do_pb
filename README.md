# Cinema App Automation

Projeto de automação de testes para aplicação de cinema usando Robot Framework.

## Estrutura do Projeto

- **variables/**: Variáveis globais, API e web
- **resources/**: Keywords e recursos reutilizáveis
  - **api/**: Resources para testes de API
  - **web/**: Resources para testes web
- **tests/**: Casos de teste
  - **api/**: Testes de API
  - **web/**: Testes web

## Como Executar

```bash
# Instalar dependências
pip install -r requirements.txt

# Executar todos os testes
robot tests/

# Executar apenas testes de API
robot tests/api/

# Executar apenas testes web
robot tests/web/
```