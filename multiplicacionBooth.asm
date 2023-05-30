FOR:
    //Movemos al acc la direccion de memoria de la variable count
    mov acc, cte
    count
    mov dptr, acc
    //Obtemos el contenido que esta en esa direccion de memoria y lo guardamos 
    //en acc.
    mov acc, [dptr]
    //Invertimos el contenido en acc. (complemento a 1)
    inv acc
    //Guardamos el valor invertido en a
    mov a, acc
    //Guardamos en acc la direccion de memoria de num1
    mov acc, cte
    num1
    mov dptr, acc
    //Movemos el contenido de la direccion de memoria al que apunta DPTR a acc.
    mov acc, [dptr]
    //Sumamos acc (eso sera igual  -8)
    add acc, a
    //Guardamos en a ese resultado.
    mov a, acc
    //Guardamos en acc la direccion de memoria de num1
    mov acc, cte
    num1
    mov dptr, acc
    //Movemos el contenido de la direccion de memoria al que apunta DPTR a acc.
    mov acc, [dptr]
    //Sumamos acc con rango [1+(-8)= -7]
    add acc, a
    //Movemos "acc" a  "a"(a=-7)
    mov a, acc
    //Traemos la variable i
    mov acc, cte
    i
    mov dptr, acc
    //En este momento, acc=i
    mov acc, [dptr]
    //[i+(a= -7)]
    add acc, a

    jn cte
    //Si i+(-rango) es un resultado negativo, va a saltar a la funcion 
    //donde ocurre la multiplicacion.
    LSB_Q
    
    jmp cte
    FIN_LOOP
//Funcion que carga a Q y Q-1, realiza un XOR y toma el lsb de la operacion
LSB_Q:
    //Cargamos a acc la variable q
    mov acc, cte
    q
    mov dptr, acc
    mov acc, [dptr]
    inv acc
    //Guardamos lo de acc, en a
    mov a, acc
    //Cargamos a acc la variable q-1
    mov acc, cte
    q_1
    mov dptr, acc
    mov acc, [dptr]
    //Realizamos un xor entre q y q-1
    xor acc, a
    //Al resultado de esa operacion le tomamos su lsb para conocer la operacion que se debe realizar
    lsb acc
    //Si es 0 salta al shift
    jz cte
    SHIFT
    //Si es distinto a 0, sigue a la siguiente instruccion

MULTIPLICACION_BOOTH:
//Cargamos la variable "m" a acc, y luego la guardamos en a
    mov acc, cte
    multi
    mov dptr, acc
    mov acc, [dptr]
    mov a, acc
    //Cargamos la variable q y la guardamos en acc
    mov acc, cte
    q
    mov dptr,acc
    mov acc, [dptr]
    //Si el lsb de q es igual a 0, saltara a la operacion SUMAM
    lsb acc
    jz cte
    SUMAM

//Si el lsb de q es diferente a 0, seguira con la operacion RESTAM
RESTAM:
//Se aplica complemento a dos a la m, para que cuando pase a SUMAM realize la resta 
    neg a 
SUMAM:
    //Cargamos a "acc" la variable acumuladora
    mov acc, cte
    acum
    mov dptr, acc
    mov acc, [dptr]
    //Realizamos la operación correspondiente y la guardamos en a, si la "m" esta negada se realiza resta
    add acc, a
    mov a, acc
    //Realizamos la actualizacion de la variable acumuladora
    mov acc, cte
    acum
    mov dptr, acc
    //Movemos "a" a "acc", la cual puede ser (ACC+(-M)) o (ACC+M)
    mov acc, a
    mov [dptr], acc

//Pasamos a la siguiente operación del SHIFT
SHIFT:
    //Cargamos a "acc" la variable q
    mov acc, cte
    q
    mov dptr, acc
    mov acc, [dptr]
    //Aplicamos un lsb a "acc" para pasar el valor del lsb de q a q-1
    lsb acc
    mov a, acc
    mov acc, cte
    q_1
    mov dptr, acc
    //Movemos "a" a "acc", y actualizamos el valor de q-1
    mov acc, a
    mov [dptr], acc
    //Cargamos a "acc" la variable acumuladora
    mov acc, cte
    acum
    mov dptr, acc
    mov acc, [dptr]
    //Guardamos los que esta en "acc" a "a"
    mov a, acc

//Pasamos a la operacion para realizar el shift a la variable q
SHIFT_Q:
//Cargamos a "acc" la variable q
    mov acc, cte
    q
    mov dptr, acc
    mov acc, [dptr]
    //Realizamos el shift logico a la derecha de la variable q
    lsr acc
//Realizamos el lsb de la variable acumuladora
    lsb a
//Si este es igual a 0, guardar el logical shift a la derecha de q
    jz cte
    Q_ACT
//Si es diferente de 0, pasamos q a "a"
    mov a, acc
//Cargamos a "acc" la variable mascara_msb
    mov acc, cte
    mascara_msb
    mov dptr, acc
    mov acc, [dptr]
//Si el lsb de la variable acumuladora es distinto a 0, se le sumara 10000000 a q luego de realizar el shift
    add acc, a

Q_ACT:
//Guardamos el shift logico de q
    mov [dptr], acc

CHANGE_A:
//Cargamos a "acc" la variable acumuladora, y la guardamos en "a"
    mov acc, cte
    acum
    mov dptr, acc
    mov acc, [dptr]
    mov a, acc
//Cargamos a "acc" la variable acumuladora y realizamos el shift logical a la derecha 
    mov acc, cte
    acum
    mov dptr, acc
    mov acc, [dptr]
    lsr acc
//Realizamos un or entre el acumulador anterior al shift y el que tiene el shift, para actualizar el msb
//La operacion se guarda en acc, y luego se actualiza el valor
    or acc, a
    mov [dptr], acc


INCREMENT_I:
//Guardamos en acc la direccion de memoria de num1
    mov acc, cte
    num1
    mov dptr, acc
//Movemos el contenido de la direccion de memoria al que apunta DPTR a acc.
    mov acc, [dptr]
//Guardamos el num1 a "a"
    mov a, acc
//Cargamos i
    mov acc, cte
    i
    mov dptr, acc
    mov acc, [dptr]
//Sumamos "acc" y "a" (acc= i+1)
    add acc, a
//Guardamos por un momento el valor aumentado de i en "a"
    mov a, acc
//Actualizamos el valor de i llevando el contenido de "a" a i.
    mov acc, cte
    i
    mov dptr, acc
    mov acc, a
    mov [dptr], acc 
//Saltamos al for
    jmp cte
    FOR 

//fin loop y se guardan las variables en dos registros
FINLOOP:
    mov acc, cte
    acum
    mov dptr, acc
    mov acc, [dptr]
    mov a, acc
    mov acc, cte
    q
    mov dptr, acc
    mov acc, [dptr]
    jmp cte
    FINAL_PROGRAM
//Fin programa
FINAL_PROGRAM:
    HALT

//Variables:
lsb_q: 0x00
count: 0x08 //8
num1: 0x01  //00000001
i: 0x00 //0
q: 0xFD //11111101                                          //-3            
multi: 0xF9 //11111001                                      //-7
acum: 0x00 //00000000
mascara_msb: 0x80 //10000000
auxiliar: 0x00


