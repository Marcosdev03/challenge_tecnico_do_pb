*** Settings ***
Library    Browser
Library    String
Resource    ../../resources/web/auth_keywords.resource

Suite Setup    Iniciar Navegador
Suite Teardown    Encerrar Navegador 
Test Setup    Ir Para Home E Fazer Logout Se Necessario

*** Test Cases ***
WEB-AUTH-01 - Login Usuario Bem Sucedido
    [Tags]    WEB-AUTH-01
    Fazer Login Como Usuario
    Verificar Usuario Logado

WEB-AUTH-02 - Login Admin Bem Sucedido
    [Tags]    WEB-AUTH-02
    Fazer Login Como Admin
    Verificar Usuario Logado

WEB-AUTH-03 - Login Com Credenciais Invalidas
    [Tags]    WEB-AUTH-03
    Ir Para Pagina De Login
    Preencher Credenciais    email@invalido.com    senhaerrada
    Clicar Em Entrar
    Verificar Texto Na Pagina    404: NOT_FOUND
    ${url}=    Get Url
    Should Contain    ${url}    /login

WEB-AUTH-04 - Registro De Novo Usuario
    [Tags]    WEB-AUTH-04
    ${random_email}=    Gerar Email Aleatorio
    Registrar Novo Usuario    Test User    ${random_email}    password123    password123
    ${url}=    Get Url
    Should Contain    ${url}    challenge-pb-front.vercel.app
    Verificar Texto Na Pagina    Conta criada com sucesso!
    Verificar Usuario Logado

WEB-AUTH-05 - Registro Com Senhas Diferentes
    [Tags]    WEB-AUTH-05
    ${random_email}=    Gerar Email Aleatorio
    Registrar Novo Usuario    Test User    ${random_email}    password123    password456
    Verificar Texto Na Pagina    As senhas não coincidem.
    ${url}=    Get Url
    Should Contain    ${url}    /register

WEB-AUTH-06 - Logout Do Sistema
    [Tags]    WEB-AUTH-06
    Fazer Login Como Usuario
    Fazer Logout
    Verificar Usuario Nao Logado