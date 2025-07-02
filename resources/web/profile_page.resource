*** Settings ***
Resource   common.resource

*** Variables ***
${PROFILE_TITLE}            xpath=//h1[contains(text(),'Perfil')]
${USER_INFO_SECTION}        id=user-info
${EDIT_PROFILE_BUTTON}      id=edit-profile-btn
${SAVE_PROFILE_BUTTON}      id=save-profile-btn

*** Keywords ***
Navigate To Profile Page
    Open Browser To URL    ${PROFILE_URL}

Verify Profile Page Is Loaded
    Wait Until Element Is Visible    ${PROFILE_TITLE}    ${TIMEOUT}
    Element Should Be Visible    ${USER_INFO_SECTION}

Edit Profile
    Wait And Click Element    ${EDIT_PROFILE_BUTTON}

Save Profile Changes
    Wait And Click Element    ${SAVE_PROFILE_BUTTON}