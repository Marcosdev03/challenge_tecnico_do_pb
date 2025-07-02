*** Settings ***
Library    Browser
Resource    ../../resources/web/profile_keywords.resource

Suite Setup    Iniciar Navegador
Suite Teardown    Encerrar Navegador
Test Setup    Ir Para Home E Fazer Logout Se Necessario

*** Test Cases ***
WEB-PROF-01 - Visualizar Dados Do Perfil
    [Tags]    WEB-PROF-01
    Fazer Login Como Usuario
    Ir Para Pagina De Perfil
    Verificar Pagina De Perfil Carregada

WEB-PROF-02 - Visualizar Reserva Existente
    [Tags]    WEB-PROF-02
    Fazer Login Como Usuario
    Visualizar Reservas Na Pagina De Perfil
    Verificar Reserva Existente

WEB-PROF-03 - Campos Do Perfil Visiveis
    [Tags]    WEB-PROF-03
    Fazer Login Como Usuario
    Ir Para Pagina De Perfil
    ${page_text}=    Get Text    body
    Should Contain    ${page_text}    Nome Completo
    Should Contain    ${page_text}    E-mail
    Should Contain    ${page_text}    Alterar Senha

WEB-PROF-04 - Informacoes Da Reserva
    [Tags]    WEB-PROF-04
    Fazer Login Como Usuario
    Visualizar Reservas Na Pagina De Perfil
    ${page_text}=    Get Text    body
    Should Contain    ${page_text}    25/06/2025
    Should Contain    ${page_text}    14:00
    Should Contain    ${page_text}    Assentos:A1