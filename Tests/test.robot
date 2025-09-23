*** Settings ***
Library    SeleniumLibrary
Variables  ../Variables/variable.py
Library    ../Library/api.py

Suite Setup   Launch Browser  ${website_url}  ${login_txt_username}

*** Test Cases ***
TEST-000001
    [Documentation]   Testing
    Login User  ${username_login}   ${password_login}
    ${status}    Run Keyword And Return Status   Wait Until Element Is Visible   ${nav_btn_customer}
    Check Is Login   ${status}

    ${users}   Get Random Users
    FOR  ${i}  IN  @{users}
        Create User   ${i}
    END

*** Keywords ***
Launch Browser
    [Arguments]     ${url}     ${element_to_wait}
    Open Browser    ${url}    chrome   options=add_argument("--start-maximized")
    Wait Until Keyword Succeeds    5x   .5s    Wait Until Element Is Visible    ${element_to_wait}

Login User
    [Arguments]     ${username}=${username_login}       ${password}=${password_login}
    Input Text      ${login_txt_username}   ${username}
    Input Text      ${login_txt_password}   ${password}
    Click Button    ${login_btn_submit}

Create User
    [Arguments]  ${user}
    ${birthday}   Random Birthday

    Wait Until Keyword Succeeds   5x   1s   Click Element  ${nav_btn_customer}
    Wait Until Keyword Succeeds   5x   .5s   Wait Until Element Is Visible   ${customer_btn_create}
    Click Element   ${customer_btn_create}
    Wait Until Element Is Visible   ${customer_txt_firstname}

    Input Text  ${customer_txt_firstname}   ${user["name"].split(" ")[0]}
    Input Text  ${customer_txt_lastname}    ${user["name"].split(" ")[1]}
    Input Text  ${customer_txt_email}       ${user["email"]}
    Input Text  ${customer_txt_birthday}    ${birthday}   
    Input Text  ${customer_txt_address}     ${user["address"]["street"]}
    Input Text  ${customer_txt_city}        ${user["address"]["city"]}
    Input Text  ${customer_txt_state}       test
    Input Text  ${customer_txt_zipcode}     ${user["address"]["zipcode"]}
    Input Text  ${customer_txt_password}    test
    Input Text  ${customer_txt_confirm_password}    test

    Click Element   ${customer_btn_save}
    Sleep  2s


Check Is Login
    [Arguments]   ${status}
    IF    ${status}
            Log To Console   Login Successful
        ELSE
            Log To Console   Login Failed
        END