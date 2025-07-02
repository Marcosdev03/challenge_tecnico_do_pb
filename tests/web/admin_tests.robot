*** Settings ***
Resource    ../../resources/web/auth_page.resource
Suite Teardown    Close Browser Session

*** Test Cases ***
Login Como Admin Deve Acessar Painel
    [Tags]    WEB-ADMIN-01
    Navigate To Login Page
    Login User    admin    admin_password
    Location Should Contain    /admin

Acessar Dashboard Admin Deve Mostrar Painel
    [Tags]    WEB-ADMIN-01
    Navigate To Login Page
    Login User    admin    admin_password
    Page Should Contain    Painel Administrativo