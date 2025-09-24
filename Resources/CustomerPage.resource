*** Settings ***
Resource   ../Resources/App.resource
Variables  ../Variables/customerpage.py

*** Variables ***
${first_name}
${last_name}
${email}
${address}
${city}
${state}
${zipcode}
${password}

*** Keywords ***
Create User
    [Arguments]  ${user}
    ${birthday}   Random Birthday

    Go To Customer Page
    Wait Until Keyword Succeeds   5x   .5s   Wait Until Element Is Visible   ${customer_btn_create}
    Click Element   ${customer_btn_create}
    Wait Until Element Is Visible   ${customer_txt_firstname}

    ${first_name}=    Set Variable And Input Text   ${user["name"].split(" ")[0]}    ${customer_txt_firstname}
    ${last_name}=     Set Variable And Input Text   ${user["name"].split(" ")[1]}    ${customer_txt_lastname}
    ${email}=         Set Variable And Input Text   ${user["email"]}                 ${customer_txt_email}
    ${birthday}=      Set Variable And Input Text   ${birthday}                      ${customer_txt_birthday}
    ${address}=       Set Variable And Input Text   ${user["address"]["street"]}     ${customer_txt_address}
    ${city}=          Set Variable And Input Text   ${user["address"]["city"]}       ${customer_txt_city}
    ${state}=         Set Variable And Input Text   test                             ${customer_txt_state}
    ${zipcode}=       Set Variable And Input Text   ${user["address"]["zipcode"]}    ${customer_txt_zipcode}
    ${password}=      Set Variable And Input Text   test                             ${customer_txt_password}
    Set Variable And Input Text                     test                             ${customer_txt_confirm_password}

    Click Element   ${customer_btn_save}
    Sleep  2s
    Go To Customer Page
    Wait Until Element Is Visible   ${first_table_row}
    Click Element   ${first_table_row}
    Verify User Is Added   ${first_name}    ${customer_txt_firstname}
    Verify User Is Added   ${last_name}     ${customer_txt_lastname}
    Verify User Is Added   ${email}         ${customer_txt_email}
    Verify User Is Added   ${birthday}      ${customer_txt_birthday}    True
    Verify User Is Added   ${address}       ${customer_txt_address}
    Verify User Is Added   ${city}          ${customer_txt_city}
    Verify User Is Added   ${state}         ${customer_txt_state}
    Verify User Is Added   ${zipcode}       ${customer_txt_zipcode}

Set Variable And Input Text
    [Arguments]   ${value}    ${element_to_input}
    Input Text    ${element_to_input}    ${value}
    [Return]      ${value}

Go To Customer Page
    Wait Until Keyword Succeeds   5x   1s   Click Element  ${nav_btn_customer}
    Refresh Current Page

Verify User Is Added
    [Arguments]    ${expected_value}    ${element}      ${isDate}=False
    Wait Until Element Is Visible    ${element}
    ${actual_value}=    Get Element Attribute    ${element}    value

    IF    ${isDate} == True
        ${expected_value}=  Evaluate    '{}-{}-{}'.format("${expected_value}".split("-")[2], "${expected_value}".split("-")[0], "${expected_value}".split("-")[1])
    END

    Should Be Equal    ${actual_value}    ${expected_value}
    Log To Console     "\nVerified: ${element} = ${actual_value}"


