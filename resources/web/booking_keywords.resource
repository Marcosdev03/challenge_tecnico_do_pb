*** Settings ***
Library    Browser
Resource   common_keywords.resource
Resource   auth_keywords.resource

*** Variables ***
# Seats Page Selectors
${SEATS_MAP}                    .seats-map
${AVAILABLE_SEAT}               .seat.available >> nth=0
${OCCUPIED_SEAT}                .seat.occupied >> nth=0
${SELECTED_SEAT}                .seat.selected
${CONTINUE_BUTTON}              .continue-button

# Checkout Selectors
${CHECKOUT_SUMMARY}             .checkout-summary
${FINALIZE_BUTTON}              .finalize-button

*** Keywords ***
Ir Para Filme Com Sessoes
    Go To    ${BASE_WEB_URL}
    Click    text=Ver Detalhes >> nth=4
    Wait For Elements State    text=Selecionar Assentos >> nth=0    visible    timeout=10s

Tentar Acessar Selecao De Assentos
    Click    text=Selecionar Assentos >> nth=0
    Sleep    3s

Selecionar Assento Disponivel
    Aguardar Elemento    ${AVAILABLE_SEAT}
    Click    ${AVAILABLE_SEAT}

Tentar Selecionar Assento Ocupado
    Aguardar Elemento    ${OCCUPIED_SEAT}
    Click    ${OCCUPIED_SEAT}

Prosseguir Para Checkout
    Click    ${CONTINUE_BUTTON}
    Aguardar Elemento    ${CHECKOUT_SUMMARY}

Finalizar Compra
    Click    ${FINALIZE_BUTTON}

Verificar Pagina De Assentos Carregada
    Aguardar Elemento    ${SEATS_MAP}
    Aguardar Elemento    ${AVAILABLE_SEAT}

Verificar Assento Selecionado
    Aguardar Elemento    ${SELECTED_SEAT}