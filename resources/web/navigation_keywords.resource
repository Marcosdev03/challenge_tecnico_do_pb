*** Settings ***
Library    Browser
Resource   common_keywords.resource
Resource   auth_keywords.resource
Resource   booking_keywords.resource

*** Variables ***
# Home Page Selectors
${MOVIES_SECTION}               h2 >> text=Filmes em Cartaz
${MOVIE_CARD}                   .movie-card >> nth=0
${MOVIE_DETAILS_BUTTON}         text=Ver Detalhes >> nth=0

# Movie Details Selectors
${MOVIE_TITLE}                  h1 >> nth=0
${MOVIE_SYNOPSIS}               text=Sinopse
${SESSION_BUTTON}               .session-button

*** Keywords ***
Ir Para Home
    Go To    ${BASE_WEB_URL}
    Aguardar Elemento    ${MOVIES_SECTION}

Navegar Para Detalhes Do Filme
    Ir Para Home
    Aguardar Elemento    ${MOVIE_DETAILS_BUTTON}
    Click    ${MOVIE_DETAILS_BUTTON}
    Aguardar Elemento    ${MOVIE_TITLE}

Navegar Para Selecao De Assentos
    Navegar Para Detalhes Do Filme
    Aguardar Elemento    ${SESSION_BUTTON}
    Click    ${SESSION_BUTTON}

Verificar Home Carregada
    Aguardar Elemento    ${MOVIES_SECTION}
    Aguardar Elemento    ${MOVIE_CARD}

Verificar Detalhes Do Filme Carregados
    Aguardar Elemento    ${MOVIE_TITLE}
    Aguardar Elemento    ${MOVIE_SYNOPSIS}