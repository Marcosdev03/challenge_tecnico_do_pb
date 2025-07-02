*** Settings ***
Resource    ../../resources/web/home_page.resource
Resource    ../../resources/web/movie_page.resource
Suite Teardown    Close Browser Session

*** Test Cases ***
Navegar Para Página Inicial Deve Carregar Corretamente
    [Tags]    WEB-NAV-01
    Navigate To Home Page
    Verify Home Page Is Loaded

Navegar Para Página Do Filme Deve Carregar Detalhes
    [Tags]    WEB-NAV-02
    Navigate To Home Page
    Click Featured Movie
    Verify Movie Page Is Loaded