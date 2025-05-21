# Manual para Crear Juegos en Lu8 (para niños de 11 años)

Hola! Este manual es para que aprendas a crear tus propios programas y jueguitos para la consola Lu8. Vamos a explicar todo paso a paso. No necesitas saber programar antes, sólo tener ganas de aprender y jugar.

---

## ¿Qué es Lu8?

Lu8 es una consola retro inventada por nosotros. No es una consola como la Play o la Nintendo, pero puedes hacer juegos que se vean parecidos a los de antes (pixelados, con sonidos simples, y muy rápidos).

Usamos un lenguaje llamado **ensamblador** (assembly), pero no te asustes: lo vamos a explicar como si fueran recetas.

---

## ¿Qué necesitas para empezar?

* Una computadora con el programa de Lu8 instalado
* Un editor de texto (como VSCode o Notepad++)
* Un archivo `.asm` donde escribirás tu código
* ¡Ganas de crear!

---

## La Interfaz de Lu8

Lu8 tiene varias partes que te ayudarán a crear tus juegos:

### 1. El Editor de Código
Es donde escribirás tu código. Tiene colores especiales para que sea más fácil leer y entender lo que escribes.

### 2. La Terminal (Shell)
Es como una ventana mágica donde puedes dar órdenes a Lu8. Algunos comandos útiles son:
* `help` - Muestra todos los comandos disponibles
* `load` - Carga un archivo de código
* `save` - Guarda tu código
* `compile` - Convierte tu código en un juego
* `start` - Inicia tu juego
* `pause` - Pausa el juego
* `resume` - Continúa el juego
* `shutdown` - Apaga el juego

### 3. El Monitor
Te muestra información importante sobre tu juego:
* **CPU**: Muestra qué está haciendo el juego en cada momento
* **RAM**: Te enseña qué está guardado en la memoria

Para activar el monitor, usa estos comandos:
* `monitor-cpu` - Activa/desactiva el monitor de CPU
* `monitor-ram` - Activa/desactiva el monitor de memoria
* `monitor-on` - Activa todos los monitores
* `monitor-off` - Desactiva todos los monitores

---

## ¿Qué es ensamblador?

El lenguaje ensamblador es uno de los lenguajes más cercanos a cómo entienden las computadoras. En vez de usar palabras como en los lenguajes modernos, usamos comandos cortos como `MOV`, `ADD`, `JMP`, que se traducen en instrucciones directas para el procesador.

Piensa en ensamblador como darle órdenes a un robot, paso por paso, sin magia. Es perfecto para aprender cómo funciona un videojuego por dentro.

---

## ¿Qué es la memoria?

La memoria es como una estantería llena de cajones donde puedes guardar números. Cada cajón tiene una dirección (por ejemplo `0x8000`) y puedes poner o leer un número en él.

Usamos la memoria para guardar:
* Dónde está el jugador
* Qué color estamos usando
* Si un botón fue presionado
* Qué tan fuerte es un sonido

En Lu8, toda la lógica del juego trabaja usando estas direcciones de memoria.

---

## ¿Cómo funciona la consola Lu8?

La consola Lu8 funciona leyendo un programa paso por paso. Cada paso (instrucción) hace algo:
* Dibuja en pantalla
* Toca sonidos
* Cambia colores
* Mueve cosas
* Lee botones del teclado

Usamos direcciones de memoria para guardar y leer información, como si fueran cajones con números.

---

## Instrucciones básicas de Lu8

Aquí explicamos las instrucciones más importantes y cómo usarlas.

### 1. `MOV [direccion], valor`

Guarda un número en una dirección. Es como decir "pon esto aquí".

```asm
MOV [0x8000], 42 ; Guarda el número 42 en 0x8000
```

### 2. `ADD`, `SUB`, `MUL`, `DIV`

Sirven para sumar, restar, multiplicar y dividir números.

```asm
ADD [0x8000], 1 ; Suma 1 al valor en 0x8000
```

### 3. `CMP`, `JMP`, `JZ`, `JNZ`, `JG`, `JL`

Se usan para tomar decisiones. Por ejemplo, saltar a otro lugar si un valor es mayor que otro.

```asm
CMP [0x8000], 10
JG ganar
```

### 4. `CLS` y `VSYNC`

`CLS` borra la pantalla. `VSYNC` espera al final del cuadro (como una pausa de 1 frame).

### 5. `SETCOLOR`, `PSET`, `RECT`, `FILLRECT`, `CIRC`, `FILLCIRCLE`

Se usan para dibujar en la pantalla. Todo se basa en coordenadas X e Y, y en el color actual.

### 6. `LOG`, `RND`, `TICK`

Extras útiles:
* `LOG` muestra en consola
* `RND` pone un número aleatorio (0 a 255)
* `TICK` guarda el tiempo actual en una dirección

---

## Colores disponibles

Puedes usar 16 colores del 0 al 15:

* 0: negro  
* 1: azul oscuro  
* 2: violeta oscuro  
* 3: verde oscuro  
* 4: marrón  
* 5: gris oscuro  
* 6: gris claro  
* 7: blanco  
* 8: rojo  
* 9: naranja  
* 10: amarillo  
* 11: verde claro  
* 12: azul  
* 13: violeta claro  
* 14: rosa  
* 15: durazno

---

## ¿Cómo leer el teclado?

La consola tiene 2 controles (como NES). El jugador 1 está en la dirección `0xFF10`. Cada botón es un bit:

| Botón     | Valor |
| --------- | ----- |
| A         | 0x01  |
| B         | 0x02  |
| SELECT    | 0x04  |
| START     | 0x08  |
| ARRIBA    | 0x10  |
| ABAJO     | 0x20  |
| IZQUIERDA | 0x40  |
| DERECHA   | 0x80  |

Ejemplo: mover algo si aprieta derecha

```asm
MOV [0x8000], [0xFF10]
AND [0x8000], 0x80 ; verifica botón derecha
CMP [0x8000], 0x80
JZ mover_derecha
```

---

## ¿Cómo hacer sonidos? (APU)

Cada canal de sonido tiene registros:

| Dirección     | Qué hace                 |
| ------------- | ------------------------ |
| `0xD820`      | Encender canal (Pulse 1) |
| `0xD821`      | Volumen y envolvente     |
| `0xD823`/`24` | Frecuencia baja/alta     |
| `0xD825`      | Tipo de onda (duty)      |

Ejemplo de un beep:

```asm
MOV [0xD820], 0       ; Apaga
MOV [0xD821], 0x8F    ; Volumen
MOV [0xD825], 2       ; Onda 50%
MOV [0xD823], 68      ; Frecuencia baja
MOV [0xD824], 2       ; Frecuencia alta
MOV [0xD820], 1       ; Prende canal
```

---

## Proyecto completo: Jugador que se mueve

Vamos a usar teclado, gráficos, colores y todo lo aprendido:

```asm
; Posiciones iniciales
MOV [0x8000], 64 ; X
MOV [0x8001], 64 ; Y

loop:
    CLS
    MOV [0xD800], 1
    SETCOLOR

    ; Dibujar jugador
    MOV [0xD806], [0x8000]
    MOV [0xD807], [0x8001]
    MOV [0xD800], 15 ; seteamos un color blanco
    PSET

    ; Leer entrada
    MOV [0x8002], [0xFF10] ; Teclado

    ; Derecha
    MOV [0x8003], [0x8002]
    AND [0x8003], 0x80
    CMP [0x8003], 0x80
    JNZ skip_right
    INC [0x8000]
skip_right:

    ; Izquierda
    MOV [0x8003], [0x8002]
    AND [0x8003], 0x40
    CMP [0x8003], 0x40
    JNZ skip_left
    DEC [0x8000]
skip_left:

    ; Abajo
    MOV [0x8003], [0x8002]
    AND [0x8003], 0x20
    CMP [0x8003], 0x20
    JNZ skip_down
    INC [0x8001]
skip_down:

    ; Arriba
    MOV [0x8003], [0x8002]
    AND [0x8003], 0x10
    CMP [0x8003], 0x10
    JNZ skip_up
    DEC [0x8001]
skip_up:

    VSYNC
    JMP loop
```

---

## ¡Felicitaciones!

Ahora sí, ¡sabes todo lo básico para hacer tus propios juegos en Lu8!

Próximos pasos:
* Aprender a usar `CALL` y `RET` para subrutinas
* Guardar puntajes y vidas en memoria
* Leer tiempo y aleatoriedad con `TICK` y `RND`
* Crear efectos de sonido y música
* Usar el monitor para ver cómo funciona tu juego por dentro

Y sobre todo: **¡Diviértete programando tus ideas!**
