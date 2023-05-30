//Instrucción complemento a dos, no se utiliza la sigla NOT, porque equivale a INV 
neg:
    mov acc, a
    inv acc
    add 0x01, acc
    mov a, acc