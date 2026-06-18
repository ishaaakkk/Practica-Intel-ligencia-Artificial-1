;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5. MÓDULO DE SALIDA 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmodule SALIDA
   (import REFINAMIENTO ?ALL)
   (export ?ALL)
)

;;imprime la vivienda con el menor valor de orden y la elimina de la lista de impresión
(defrule imprimir-resultados-ordenados
   (declare (salience -40))
   ;;se encuentra el hecho con el menor valor de orden
   ?hecho <- (vivienda-a-mostrar (vivienda ?v) (valor-orden ?vo))
   (not (vivienda-a-mostrar (valor-orden ?vo2&:(< ?vo2 ?vo))))
   =>
   ;;se extraen los datos de la vivienda
   (bind ?id (send ?v get-id))
   (bind ?etq (send ?v get-etiqueta-recomendacion))
   (bind ?fallos (send ?v get-requisitos-fallados))
   (bind ?extras (send ?v get-ventajas-extra))

   (printout t "----------------------------------" crlf)
   (printout t "Vivienda ID: " ?id crlf)
   (printout t "Grado de Recomendacion: " ?etq crlf)
   (if (> (length$ ?fallos) 0) then
      (printout t "Requisitos NO cumplidos (simbolos): " (implode$ ?fallos) crlf)
   )
   (if (> (length$ ?extras) 0) then
      (printout t "Ventajas extra (simbolos): " (implode$ ?extras) crlf)
   )
   (printout t crlf)

   ;;se elimina el hecho para pasar a la siguiente vivienda en la próxima iteración
   (retract ?hecho)
)

(defrule imprimir-resumen-fallos
   (declare (salience -60))
   =>
   (printout t crlf "=== RESUMEN DE FALLOS POR VIVIENDA ===" crlf)
   (bind ?viviendas (find-all-instances ((?v Vivienda)) TRUE))
   (foreach ?v ?viviendas
      (bind ?id (send ?v get-id))
      (bind ?fallos (send ?v get-requisitos-fallados))
      (bind ?etq (send ?v get-etiqueta-recomendacion))
      (printout t ?etq "  Vivienda " ?id ": " (implode$ ?fallos)  crlf)
   )
   (printout t "===================================" crlf crlf)
)

(defrule fallback-ninguna-vivienda
   (declare (salience -50))
   ;; No existe ninguna vivienda con etiqueta distinta a Sin-Clasificar
   (not (object (is-a Vivienda)
                (etiqueta-recomendacion ~Sin-Clasificar)))
   =>
   (printout t "----------------------------------" crlf)
   (printout t " No existe ninguna vivienda que cumpla los requisitos del solicitante." crlf)
   (printout t "----------------------------------" crlf)
)
