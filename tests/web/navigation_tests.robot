*** Settings ***
Library    Browser
Resource    ../../resources/web/navigation_keywords.resource

Suite Setup    Iniciar Navegador
Suite Teardown    Encerrar Navegador
Test Setup    Ir Para Home E Fazer Logout Se Necessario

*** Test Cases ***
WEB-NAV-01 - Visualizar Filmes Na Home
    [Tags]    WEB-NAV-01
    Ir Para Home
    Verificar Home Carregada

WEB-NAV-02 - Acessar Detalhes Do Filme
    [Tags]    WEB-NAV-02
    Navegar Para Detalhes Do Filme
    Verificar Detalhes Do Filme Carregados

WEB-NAV-03 - Tentar Acessar Selecao De Assentos
    [Tags]    WEB-NAV-03
    Fazer Login Como Usuario
    Ir Para Filme Com Sessoes
    Tentar Acessar Selecao De Assentos
    Verificar Texto Na Pagina    Erro ao carregar informações