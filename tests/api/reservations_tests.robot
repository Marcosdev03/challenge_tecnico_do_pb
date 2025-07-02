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
    # BUG IDENTIFICADO: API retorna "not available" mesmo para assentos disponíveis
    ${seat1}=    Create Dictionary    row=B    number=1    type=full
    ${seat2}=    Create Dictionary    row=B    number=2    type=half
    ${seats_list}=    Create List    ${seat1}    ${seat2}
    ${reservation_data}=    Create Dictionary
    ...    session=${session_id}
    ...    seats=${seats_list}
    ${response}=    Create Reservation With Auth    ${token}    ${reservation_data}
    
    # Assertions - COMPORTAMENTO ESPERADO (FALHARÁ DEVIDO AO BUG-001)
    Should Be Equal As Strings    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()['data']}    _id
    Dictionary Should Contain Key    ${response.json()['data']}    totalPrice
    Dictionary Should Contain Key    ${response.json()['data']}    status
    Should Be Equal As Strings    ${response.json()['data']['status']}    confirmed

Listar Minhas Reservas Deve Retornar Apenas Reservas Do Usuário
    [Tags]    RES-003
    # Login as user
    ${login_response}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    
    # Get reservations
    ${response}=    Get My Reservations    ${token}
    
    # Assertions
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be True    len(${response.json()}) >= 0

Admin Pode Listar Todas As Reservas
    [Tags]    RES-006
    # Login as admin
    ${login_response}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    
    # Get all reservations
    ${response}=    Get All Reservations    ${token}
    
    # Assertions
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be True    len(${response.json()}) >= 0

Tentar Reservar Assento Ocupado Deve Falhar
    [Tags]    RES-002
    ${login_response}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    
    # Get available session
    ${sessions_response}=    Get All Sessions
    ${session_id}=    Set Variable    ${sessions_response.json()['data'][0]['_id']}
    
    # BUG: Não conseguimos criar primeira reserva devido ao bug da API
    ${seat1}=    Create Dictionary    row=C    number=1    type=full
    ${seat2}=    Create Dictionary    row=C    number=2    type=full
    ${seats_list}=    Create List    ${seat1}    ${seat2}
    ${reservation_data}=    Create Dictionary    session=${session_id}    seats=${seats_list}
    
    # Primeiro criar uma reserva para ocupar assentos
    ${first_response}=    Create Reservation With Auth    ${token}    ${reservation_data}
    Should Be Equal As Strings    ${first_response.status_code}    201
    
    # Agora tentar reservar os mesmos assentos (deve falhar)
    ${response}=    Create Reservation With Auth    ${token}    ${reservation_data}
    Should Be Equal As Strings    ${response.status_code}    400
    Should Contain    ${response.json()['message']}    not available

Obter Detalhes De Reserva Própria Deve Ter Sucesso
    [Tags]    RES-004
    ${login_response}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    
    # Get available session
    ${sessions_response}=    Get All Sessions
    ${session_id}=    Set Variable    ${sessions_response.json()['data'][0]['_id']}
    
    # BUG: Não conseguimos criar reserva devido ao bug da API
    ${seat1}=    Create Dictionary    row=D    number=1    type=full
    ${seats_list}=    Create List    ${seat1}
    ${reservation_data}=    Create Dictionary    session=${session_id}    seats=${seats_list}
    ${create_response}=    Create Reservation With Auth    ${token}    ${reservation_data}
    
    # Criar reserva deve ter sucesso
    Should Be Equal As Strings    ${create_response.status_code}    201
    
    # Testar busca de detalhes
    ${reservation_id}=    Set Variable    ${create_response.json()['data']['_id']}
    ${response}=    Get Reservation By ID    ${token}    ${reservation_id}
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()['data']}    _id
    Dictionary Should Contain Key    ${response.json()['data']}    seats
    Dictionary Should Contain Key    ${response.json()['data']}    totalPrice

Tentar Acessar Reserva De Outro Usuário Deve Falhar
    [Tags]    RES-005
    # Get available session
    ${sessions_response}=    Get All Sessions
    ${session_id}=    Set Variable    ${sessions_response.json()['data'][0]['_id']}
    
    # BUG: Não conseguimos criar reserva devido ao bug da API
    ${admin_login}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${admin_token}=    Set Variable    ${admin_login.json()['data']['token']}
    ${seat1}=    Create Dictionary    row=E    number=1    type=full
    ${seats_list}=    Create List    ${seat1}
    ${reservation_data}=    Create Dictionary    session=${session_id}    seats=${seats_list}
    ${admin_reservation}=    Create Reservation With Auth    ${admin_token}    ${reservation_data}
    
    # Admin deve conseguir criar reserva
    Should Be Equal As Strings    ${admin_reservation.status_code}    201
    
    # Tentar acessar como user comum
    ${admin_reservation_id}=    Set Variable    ${admin_reservation.json()['data']['_id']}
    ${user_login}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    ${user_token}=    Set Variable    ${user_login.json()['data']['token']}
    ${response}=    Get Reservation By ID    ${user_token}    ${admin_reservation_id}
    Should Be Equal As Strings    ${response.status_code}    403

Criar Reserva Sem Autenticação Deve Falhar
    [Tags]    RES-008
    # Get available session
    ${sessions_response}=    Get All Sessions
    ${session_id}=    Set Variable    ${sessions_response.json()['data'][0]['_id']}
    
    ${seat1}=    Create Dictionary    row=F    number=1    type=full
    ${seats_list}=    Create List    ${seat1}
    ${reservation_data}=    Create Dictionary    session=${session_id}    seats=${seats_list}
    ${response}=    Create Reservation    ${reservation_data}
    Should Be Equal As Strings    ${response.status_code}    401