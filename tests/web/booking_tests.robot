*** Settings ***
Library    Browser
Resource    ../../resources/web/booking_keywords.resource

Suite Setup    Iniciar Navegador
Suite Teardown    Encerrar Navegador
Test Setup    Ir Para Home E Fazer Logout Se Necessario

*** Test Cases ***
WEB-BOOK-01 - Visualizar Sessoes Disponiveis
    [Tags]    WEB-BOOK-01
    Fazer Login Como Usuario
    Ir Para Filme Com Sessoes
    ${page_text}=    Get Text    body
    Should Contain    ${page_text}    25/06/2025
    Should Contain    ${page_text}    Inteira: R$ 15.00
    ${sessions}=    Get Element Count    text=Selecionar Assentos
    Should Be True    ${sessions} >= 5

WEB-BOOK-02 - Tentar Acessar Selecao Assentos
    [Tags]    WEB-BOOK-02
    Fazer Login Como Usuario
    Ir Para Filme Com Sessoes
    Tentar Acessar Selecao De Assentos
    Verificar Texto Na Pagina    Erro ao carregar informações

WEB-BOOK-03 - Verificar Precos Das Sessoes
    [Tags]    WEB-BOOK-03
    Fazer Login Como Usuario
    Ir Para Filme Com Sessoes
    ${page_text}=    Get Text    body
    Should Contain    ${page_text}    Inteira: R$ 15.00
    Should Contain    ${page_text}    Meia: R$ 7.50

WEB-BOOK-04 - Verificar Multiplas Sessoes
    [Tags]    WEB-BOOK-04
    Fazer Login Como Usuario
    Ir Para Filme Com Sessoes
    ${sessions}=    Get Element Count    text=Selecionar Assentos
    Should Be True    ${sessions} >= 5