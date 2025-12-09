# Pantalla LED a 24bpp (8bpp por canal)
Integrantes:
* Felipe Diaz Gordillo - fdiazgo@unal.edu.co - 1013100552

Dependencias:
* [Yosys](https://github.com/YosysHQ/yosys)
* [Nextpnr-ecp5](https://github.com/YosysHQ/nextpnr)
* [Ecppack](https://manpages.ubuntu.com/manpages/noble/man1/ecppack.1.html)
* [openFPGALoader](https://github.com/trabucayre/openFPGALoader)
* [Verilog Compiler/Linter](https://github.com/lite-xl/lite-xl)

## Especificaciones
El objetivo principal es controlar una matriz de 64x64 pixeles con la interfaz HUB75e, usando una FPGA Lattice 5A-75e V8.2.
Esta versión es sencilla, donde solo se muestra 1 imagen a 5bpp o 8bpp.
Version con solo 1bpp
Version donde cambia la imagen cada vez que se oprime le botón fisico de la fpga.
Test sencillo de los leds.

Inicialmente se tenian unas matrices que utilizaban integrados ICN2038S, pero no se logro hacerlas funcionar, probablemente estos errores se deban a problemas de hardware de las pantallas ya que no eran consistentes en como funcionaban y cada vez que se les conectaba hacian algo diferente apesar de no haber hecho cambios al codigo. Hablando con el profesros se habia llegado al acuerdo de que el proyecto seria hacer funcionar esas pantallas en especifico, pero se abandono la idea de hacer funcionar esas pantallas, por lo que se volvio a la idea inicial de hacer que cambiara de imagen cada vez que se oprima el botón. 

## Diagramas
Se incluen los diagramas [aqui](https://github.com/Fdiaz718/Panel-Led-8bpp/blob/47a3fab53f9a34ae6aadb2a624b2ab448935afd0/Proyecto%20digital_251125_101825%20(1).PDF)

Estas fueron versiones iniciales del proyecto donde el objetivo era darse una idea de como funcionaria la matriz y sus componentes, no es una version fiel a la final.
## Explicación modulos
### scan_counter.v
Define la posicion de los pixeles que se estan mostrando en la pantalla. Funciona como un generador de coordenadas cíclicas que sincroniza la lectura de memoria, el barrido del panel y la modulación de brillo.
Se hace el barrido de filas y de columnas con los ciclos if de `[0:32]` y `[0:64]` respectivamente. La modulacion de brillo hecha por PWM, es generada por medio del ancho de pulso.
La sincronización se hace enviando los datos de posición durante el latch, cuando `col=0`.

### panel_memory.v
Lee el archivo dependiendo de la dirección que se le indique por medio de **scan_counter.v** y envia los datos, aprovecha la memoria de la FPGA para permitir dos lecturas simultáneas en el mismo ciclo de reloj, con los datos superiores e inferiores

### panel_pwm.v
Este módulo es el encargado de generar la profundidad de color (24 bits) utilizando una técnica de **PWM Global**.
Actúa como un comparador digital. Recibe el valor de color de 8 bits de cada píxel (leído de panel_memory.v) y lo compara con un contador global de 8 bits (`pwm_level`) que se incrementa cada vez que se completa un barrido de pantalla. Debido a la frecuencia de actualización que debe hacerse en el comparador, al tener 8bpp es perceptible un parpadeo en la pantalla, esto se puede correguir usando solo 5bpp, que aún es suficiente para una buena visualizacion de imagen, en los codigos se indica que cambios ahcer para uno u otro.

### delay_unit.v

Este módulo gestiona las señales de control del protocolo HUB75. Se utiliza `~clk` alinea el flanco de subida del panel con el centro de la ventana de datos estables, eliminando errores al leer el dato justo en el momento en que se carga. Genera el latch al inicio de una nueva línea `col == 0`. Maneja el OE para mostrar la imagen, ademas de qeu se apaga duratne el latch para evitar errores en la visualización.

### top.v
Encapsula la arquitectura completa del controlador. Da la interconexión de los sub-módulos y la gestión de las interfaces de entrada/salida (I/O).
1.  **Coordenadas:** Instancia `scan_counters` para obtener la posición actual de barrido (`col`, `row`) y el nivel de modulación (`pwm_level`).
2.  **Carga de Datos:** Usa las coordenadas para solicitar a `panel_memory` los datos RGB correspondientes a la mitad superior e inferior del panel simultáneamente.
3.  **Procesamiento de Color:** Pasa los datos crudos y el nivel PWM a `panel_pwm`, obteniendo las señales digitales R, G, B puras.
4.  **Sincronización:** Pasa las señales de control a `delay_unit` para alinear el reloj y generar los pulsos de `LATCH` y `OE` con la temporización por el hardware.




