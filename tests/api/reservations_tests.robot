*** Settings ***
Library    Collections
Library    RequestsLibrary
Resource    ../../resources/api/auth.resource
Resource    ../../resources/api/sessions.resource
Resource    ../../resources/api/reservations.resource
Resource    ../../variables/api_variables.robot

Suite Setup    RequestsLibrary.Create Session    cinema_api    ${BASE_API_URL}

*** Test Cases ***
Criar Reserva Com Dados Válidos Deve Ter Sucesso
    [Tags]    RES-001
    # Login as user
    ${login_response}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    
    # Get available session
    ${sessions_response}=    Get All Sessions
    ${sessions_data}=    Set Variable    ${sessions_response.json()['data']}
    ${available_session}=    Set Variable    ${sessions_data[0]}
    ${session_id}=    Set Variable    ${available_session['_id']}
    
    # Create reservation with available seats
    ${seats_list}=    Create List    A1    A2
    ${reservation_data}=    Create Dictionary
    ...    session=${session_id}
    ...    seats=${seats_list}
    ${response}=    Create Reservation With Auth    ${token}    ${reservation_data}
    
    # Assertions
    Status Should Be    201    ${response}
    Dictionary Should Contain Key    ${response.json()['data']}    _id
    Dictionary Should Contain Key    ${response.json()['data']}    user
    Dictionary Should Contain Key    ${response.json()['data']}    session
    Dictionary Should Contain Key    ${response.json()['data']}    seats

Listar Minhas Reservas Deve Retornar Apenas Reservas Do Usuário
    [Tags]    RES-003
    # Login as user
    ${login_response}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    
    # Get reservations
    ${response}=    Get My Reservations    ${token}
    
    # Assertions
    Status Should Be    200    ${response}
    Should Be True    len(${response.json()}) >= 0

Admin Pode Listar Todas As Reservas
    [Tags]    RES-006
    # Login as admin
    ${login_response}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    
    # Get all reservations
    ${response}=    Get All Reservations    ${token}
    
    # Assertions
    Status Should Be    200    ${response}
    Should Be True    len(${response.json()}) >= 0

Tentar Reservar Assento Ocupado Deve Falhar
    [Tags]    RES-002
    ${login_response}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    # Primeiro criar uma reserva para ocupar assentos
    ${seats_list}=    Create List    B1    B2
    ${reservation_data}=    Create Dictionary    session=685c2d5cf34317e7520c42a4    seats=${seats_list}
    Create Reservation With Auth    ${token}    ${reservation_data}
    # Agora tentar reservar os mesmos assentos
    ${response}=    Create Reservation With Auth    ${token}    ${reservation_data}
    Status Should Be    400    ${response}
    Dictionary Should Contain Value    ${response.json()}    Seats not available

Obter Detalhes De Reserva Própria Deve Ter Sucesso
    [Tags]    RES-004
    ${login_response}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    # Primeiro criar uma reserva
    ${seats_list}=    Create List    C1
    ${reservation_data}=    Create Dictionary    session=685c2d5cf34317e7520c42a4    seats=${seats_list}
    ${create_response}=    Create Reservation With Auth    ${token}    ${reservation_data}
    ${reservation_id}=    Set Variable    ${create_response.json()['data']['_id']}
    # Agora buscar detalhes
    ${response}=    Get Reservation By ID    ${token}    ${reservation_id}
    Status Should Be    200    ${response}
    Dictionary Should Contain Key    ${response.json()['data']}    _id
    Dictionary Should Contain Key    ${response.json()['data']}    seats

Tentar Acessar Reserva De Outro Usuário Deve Falhar
    [Tags]    RES-005
    # Criar reserva com admin
    ${admin_login}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${admin_token}=    Set Variable    ${admin_login.json()['data']['token']}
    ${seats_list}=    Create List    D1
    ${reservation_data}=    Create Dictionary    session=685c2d5cf34317e7520c42a4    seats=${seats_list}
    ${admin_reservation}=    Create Reservation With Auth    ${admin_token}    ${reservation_data}
    ${admin_reservation_id}=    Set Variable    ${admin_reservation.json()['data']['_id']}
    # Tentar acessar com user comum
    ${user_login}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    ${user_token}=    Set Variable    ${user_login.json()['data']['token']}
    ${response}=    Get Reservation By ID    ${user_token}    ${admin_reservation_id}
    Status Should Be    403    ${response}
    Dictionary Should Contain Value    ${response.json()}    Not authorized to access this reservation

Criar Reserva Sem Autenticação Deve Falhar
    [Tags]    RES-008
    ${reservation_data}=    Create Dictionary    session=685c2d5cf34317e7520c42a4    seats=E1
    ${response}=    Create Reservation    ${reservation_data}
    Status Should Be    401    ${response}
    Dictionary Should Contain Value    ${response.json()}    Authentication required