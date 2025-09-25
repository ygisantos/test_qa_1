
table_row = '//*[@id="main-content"]/div/div[1]/div[2]/div/div[2]/table/tbody/tr'

def get_table_row(index: int, element_to_check: str = None):
    if element_to_check:
        return f"{table_row}[{index+1}]//{element_to_check}"
    return f"{table_row}[{index+1}]"
