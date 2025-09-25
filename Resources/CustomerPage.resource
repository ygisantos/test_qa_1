*** Settings ***
Library    ../Library/CustomerLibrary.py
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

    # INPUT AND SAVE THE DATA
    ${first_name}=    Set Variable And Input Text   ${user["name"].split(" ")[0]}    ${customer_txt_firstname}
    ${last_name}=     Set Variable And Input Text   ${user["name"].split(" ")[1]}    ${customer_txt_lastname}
    ${email}=         Set Variable And Input Text   ${user["email"]}                 ${customer_txt_email}
    ${birthday}=      Set Variable And Input Text   ${birthday}                      ${customer_txt_birthday}
    ${address}=       Set Variable And Input Text   ${user["address"]["street"]}     ${customer_txt_address}
    ${city}=          Set Variable And Input Text   ${user["address"]["city"]}       ${customer_txt_city}
    ${state}=         Set Variable And Input Text   test                             ${customer_txt_state}
    ${zipcode}=       Set Variable And Input Text   ${user["address"]["zipcode"]}    ${customer_txt_zipcode}
    ${password}=      Set Variable And Input Text   PassWord#123#Hardp_w             ${customer_txt_password}
    Set Variable And Input Text                     PassWord#123#Hardp_w             ${customer_txt_confirm_password}

    Click Element   ${customer_btn_save}
    Wait Until Element Is Visible   ${customer_created_toast}

    # VERIFY THE DATA SAVED
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
    RETURN      ${value}

Go To Customer Page
    Wait Until Keyword Succeeds   5x   1s   Click Element  ${nav_btn_customer}
    Refresh Current Page

Verify User Is Added
    [Arguments]    ${expected_value}    ${element}      ${isDate}=False
    Wait Until Element Is Visible    ${element}
    ${actual_value}=    Get Element Attribute    ${element}    value

    # Need to change the format because the format of the value of date input changes 
    IF    ${isDate} == True
        ${expected_value}=  Evaluate    '{}-{}-{}'.format("${expected_value}".split("-")[2], "${expected_value}".split("-")[0], "${expected_value}".split("-")[1])
    END

    Should Be Equal    ${actual_value}    ${expected_value}
    Log To Console     "\nVerified: ${element} = ${actual_value}"

Verify Users In Table
    Go To Customer Page

    ${row_count}=   Get Element Count   ${table_row}
    ${found_users}=    Create List

    FOR   ${i}  IN RANGE   ${row_count}
        ${row_xpath}=    Get Table Row    ${i}    td[contains(@class,"column-last_name")]//a/div
        ${row_text}=     Get Text    ${row_xpath}
        ${row_name}=     Evaluate    " ".join('''${row_text}'''.split()[1:])
        Append To List   ${found_users}    ${row_name}
    END

    FOR   ${user}   IN   @{users}
        ${expected_name}=    Set Variable    ${user['name']}
        Run Keyword If    '${expected_name}' not in ${found_users}    Fail    User ${expected_name} not found in table
    END

Update Data
    [Arguments]   ${row_to_edit}    ${data}
    Go To Customer Page
    Wait Until Element Is Visible   ${first_table_row}
    ${row_xpath}=    Get Table Row   ${row_to_edit}
    Click Element    ${row_xpath}
    ${birthday}=   Random Birthday

    Clear And Input Text          ${customer_txt_firstname}       ${data["name"].split(" ")[0]}
    Clear And Input Text          ${customer_txt_lastname}        ${data["name"].split(" ")[1]}
    Clear And Input Text          ${customer_txt_email}           ${data["email"]}
    Set Variable And Input Text   ${birthday}                     ${customer_txt_birthday}
    Clear And Input Text          ${customer_txt_address}         ${data["address"]["street"]}
    Clear And Input Text          ${customer_txt_city}            ${data["address"]["city"]}
    Clear And Input Text          ${customer_txt_state}           test_state
    Clear And Input Text          ${customer_txt_zipcode}         ${data["address"]["zipcode"]}
    Log To Console   done:${row_to_edit}

    Click Element   ${customer_btn_save}
    Wait Until Element Is Visible   ${customer_created_toast}
    

Print All Users In Table
    Go To Customer Page

    ${row_count}=   Get Element Count   //table//tr
    ${row_count}=    Evaluate    ${row_count} - 1
    FOR   ${i}   IN RANGE   1   ${row_count}+1
        ${row_xpath}=    Set Variable    //table//tr[${i}]
        Log To Console   ${EMPTY}
        Log To Console   ========= User ${i} =========
        ${column_count}=   Get Element Count   ${row_xpath}/td

        # Start from 2 to skip checkbox
        FOR   ${j}   IN RANGE   2   ${column_count}+1
            ${cell_xpath}=    Set Variable    ${row_xpath}/td[${j}]
            ${cell_text}=     Get Text    ${cell_xpath}

            # FORMAT NAME
            IF   ${j} == 2
                ${cell_text}=     Evaluate    " ".join('''${cell_text}'''.split()[1:])
            END

            # GET NEWS 
            IF   ${j} == 7
                ${cell_text}=     Get Element Attribute    ${cell_xpath}/span/*    aria-label
            END

            # GET SEGMENT
            IF  ${j} == 8
                ${chip_elements}=    Get WebElements    ${cell_xpath}//div[contains(@class,'MuiChip-root')]//span
                ${segments}=         Create List
                FOR    ${chip}    IN    @{chip_elements}
                    ${segment_text}=    Get Text    ${chip}
                    Append To List      ${segments}    ${segment_text}
                END
                ${cell_text}=    Evaluate    ", ".join(${segments})
            END
            
            IF    $cell_text == '' or $cell_text == 'None'
                ${cell_text}=    Set Variable    N/A
            END

            ${col_index}=    Evaluate    ${j} - 2
            ${col_name}=     Get From List    ${COLUMN_NAMES}    ${col_index}  
            Log To Console    ${col_name}: ${cell_text} 
        END
    END



Analyze User Spending
    [Arguments]    ${min_threshold}=3500
    Go To Customer Page

    ${row_count}=    Get Element Count   //table//tr
    ${row_count}=    Evaluate    ${row_count} - 1
    ${total_spent}=  Set Variable         0
    ${spending_users}=    Create List

    FOR   ${i}   IN RANGE   1   ${row_count}+1
        ${row_xpath}=    Set Variable    //table//tr[${i}]
        ${name_cell}=    Get Text    ${row_xpath}/td[2]
        ${name}=         Evaluate    " ".join('''${name_cell}'''.split()[1:])

        ${total_cell}=   Get Text    ${row_xpath}/td[5] 
        ${total}=        Evaluate    ${total_cell.replace('$','').replace(',','') or 0}   

        IF    ${total} > 0
            Append To List    ${spending_users}    ${name}:${total}
        END

        # Add to total
        ${total_spent}=    Evaluate    ${total_spent} + ${total}
    END

    Log To Console   ${EMPTY}
    ${counter}=    Set Variable    1
    FOR    ${user}    IN    @{spending_users}
        ${user_name}=    Evaluate    "${user}".split(':')[0]
        ${user_total}=   Evaluate    "${user}".split(':')[1]
        Log To Console    ${counter}. ${user_name}: $${user_total}
        ${counter}=      Evaluate    ${counter}+1
    END

    Log To Console   ${EMPTY}
    Log To Console    ======================
    Log To Console    Total Customer Spending: $${total_spent}
    Log To Console    ======================

    # Validate total spending
    Run Keyword If    ${total_spent} < ${min_threshold}    Fail    Fail: Total spending ($${total_spent}) is below minimum threshold ($${min_threshold})
    Run Keyword If    ${total_spent} >= ${min_threshold}   Log To Console    PASS: Total spending ($${total_spent}) meets minimum threshold ($${min_threshold})
    Log To Console   ${EMPTY}
