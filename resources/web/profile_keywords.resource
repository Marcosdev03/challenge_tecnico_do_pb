*** Settings ***
Library    Browser
Resource   common_keywords.resource
Resource   auth_keywords.resource

*** Variables ***
# Profile Page Selectors
${PROFILE_NAME_FIELD}           id=name
${PROFILE_EMAIL_FIELD}          id=email
${PROFILE_SAVE_BUTTON}          button[type="submit"]

# Reservations Page Selectors
${RESERVATIONS_SECTION}         h2 >> text=Minhas Reservas
${RESERVATION_MOVIE}            text=The Avengers
${RESERVATION_STATUS}           text=CONFIRMADA
${NO_RESERVATIONS_MESSAGE}      text=Nenhuma reserva encontrada

*** Keywords ***
Ir Para Pagina De Perfil
    Click    text=Perfil
    Wait For Elements State    ${PROFILE_NAME_FIELD}    visible    timeout=10s

Visualizar Reservas Na Pagina De Perfil
    Ir Para Pagina De Perfil
    Aguardar Elemento    ${RESERVATIONS_SECTION}
    Sleep    5s

Atualizar Nome Do Perfil
    [Arguments]    ${novo_nome}
    Ir Para Pagina De Perfil
    Fill Text    ${PROFILE_NAME_FIELD}    ${novo_nome}
    Click    ${PROFILE_SAVE_BUTTON}

Verificar Pagina De Perfil Carregada
    Aguardar Elemento    ${PROFILE_NAME_FIELD}
    Aguardar Elemento    ${PROFILE_EMAIL_FIELD}
    Wait For Elements State    h1 >> text=Meu Perfil    visible    timeout=10s

Verificar Reserva Existente
    Aguardar Elemento    ${RESERVATION_MOVIE}
    Aguardar Elemento    ${RESERVATION_STATUS}
    Verificar Texto Na Pagina    R$ 15.00

Verificar Nenhuma Reserva
    Aguardar Elemento    ${NO_RESERVATIONS_MESSAGE}