*** Settings ***
Resource   common.resource

*** Variables ***
${HOME_TITLE}               xpath=//h1[contains(text(),'Cinema')]
${MOVIES_SECTION}           id=movies-section
${FEATURED_MOVIE}           class=featured-movie

*** Keywords ***
Navigate To Home Page
    Open Browser To URL    ${HOME_URL}

Verify Home Page Is Loaded
    Wait Until Element Is Visible    ${HOME_TITLE}    ${TIMEOUT}
    Element Should Be Visible    ${MOVIES_SECTION}

Click Featured Movie
    Wait And Click Element    ${FEATURED_MOVIE}