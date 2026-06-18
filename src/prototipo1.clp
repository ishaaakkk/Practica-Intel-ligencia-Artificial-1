;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRACTICA SBC - MVP DE RECOMENDACIÓN DE VIVIENDAS
;; Basado en CLASSES (defclass)
;; Compatible con CLIPS 6.30
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1. MÓDULO DE ENTRADA (INPUT)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmodule INPUT
   (export ?ALL)
)

;; Clase Solicitante
(defclass Solicitante
   (is-a USER)
   (role concrete)
   (pattern-match reactive)

   (slot id (type SYMBOL) (create-accessor read-write))
   

   (multislot cerca_de (type INSTANCE) (create-accessor read-write))
   (multislot media_de (type INSTANCE) (create-accessor read-write))
   (multislot lejos_de (type INSTANCE) (create-accessor read-write))

   (slot precioMax (type INTEGER) (create-accessor read-write))
   (slot numHabitaciones (type INTEGER) (create-accessor read-write))
   (slot ascensor (type SYMBOL) (create-accessor read-write))
   (slot mascotas (type SYMBOL) (create-accessor read-write))
   (slot amueblado (type SYMBOL) (create-accessor read-write))

   (multislot restricciones)
)

;; Clase Vivienda
(defclass Vivienda
   (is-a USER)
   (role concrete)
   (pattern-match reactive)

   (slot id (type SYMBOL) (create-accessor read-write))
   
   (slot precio (type INTEGER) (create-accessor read-write))
   (slot habitaciones (type INTEGER) (create-accessor read-write))
   (slot superficie (type INTEGER) (create-accessor read-write))
   (slot planta (type INTEGER) (create-accessor read-write))
   (slot ascensor (type SYMBOL) (create-accessor read-write))
   (slot mascotasPermitidas (type SYMBOL) (create-accessor read-write))
   (slot amueblado (type SYMBOL) (create-accessor read-write))
   (slot soleado (type SYMBOL) (create-accessor read-write))
   (slot coordX (type INTEGER) (create-accessor read-write))
   (slot coordY (type INTEGER) (create-accessor read-write))

   (multislot cerca_de (type INSTANCE) (create-accessor read-write))
   (multislot media_de (type INSTANCE) (create-accessor read-write))
   (multislot lejos_de (type INSTANCE) (create-accessor read-write))

   (slot precio-cat (type SYMBOL) (create-accessor read-write))
   (slot tamano-cat (type SYMBOL) (create-accessor read-write))
   (slot accesibilidad (type SYMBOL) (create-accessor read-write))
)

;; Clase Servicio
(defclass Servicio
   (is-a USER)
   (role concrete)
   (pattern-match reactive)

   (slot tipo (type SYMBOL) (create-accessor read-write))
   (slot coordX (type INTEGER) (create-accessor read-write))
   (slot coordY (type INTEGER) (create-accessor read-write))
)


(definstances instances
   ;; Solicitantes
   ([Usuario1] of Solicitante
       (id u1)
       (precioMax 900)
       (numHabitaciones 2)
       (ascensor yes)
       (mascotas yes)
       (amueblado no)
   )

   ;; Viviendas
   ([Vivienda1] of Vivienda
       (id o1) (precio 850) (habitaciones 2) (superficie 60) (planta 3) (ascensor yes)
       (mascotasPermitidas yes) (amueblado no) (soleado yes)
   )

   ([Vivienda2] of Vivienda
       (id o2) (precio 1200) (habitaciones 3) (superficie 85) (planta 1)(ascensor no)
       (mascotasPermitidas no) (amueblado yes) (soleado no)
   )

   ([Vivienda3] of Vivienda
       (id o3) (precio 700) (habitaciones 1) (superficie 35) (planta 5)
       (ascensor no) (mascotasPermitidas yes) (amueblado yes) (soleado no)
   )
   ([HospitalSantPau] of Servicio
      (tipo Hospital) (coordX 10) (coordY 10)
   )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 2. MÓDULO DE ABSTRACCIÓN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmodule ABSTRACCION
   (import INPUT ?ALL)
   (export ?ALL)
)

   (defrule ABSTRACCION::crear-vivienda-abstracta
      ?v <- (object (is-a Vivienda) (id ?id) (precio ?p) (habitaciones ?h) (ascensor ?a))
      =>
      ;; precio-cat
      (bind ?cp (if (< ?p 600) then bajo else (if (< ?p 1000) then medio else alto)))

      ;; tamano-cat
      (bind ?ct (if (< ?h 2) then pequeño else (if (<= ?h 3) then medio else grande)))

      ;; accesibilidad
      (bind ?acc (if (eq ?a yes) then buena else mala))

      ;; actualizar la instancia
      (send ?v put-precio-cat ?cp) (send ?v put-tamano-cat ?ct) (send ?v put-accesibilidad ?acc)
   )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 3. MÓDULO DE HEURÍSTICAS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmodule HEURISTICAS
   (import INPUT ?ALL)
   (import ABSTRACCION ?ALL)
   (export ?ALL)
)

(deftemplate Recomendacion
   (slot idVivienda)
   (slot puntos)
   (multislot razones)
   (slot etiqueta)
   (multislot asumpciones)
)

;; Crear recomendaciones iniciales: 1 por vivienda
(defrule init-evaluar
   ?s <- (object (is-a Solicitante))
   ?v <- (object (is-a Vivienda) (id ?id))
   (not (Recomendacion (idVivienda ?id)))
   =>
   (assert (Recomendacion (idVivienda ?id) (puntos 0) (razones) (etiqueta none)))
)

;; Score de precio
(defrule score-precio
   ?s <- (object (is-a Solicitante) (precioMax ?max))
   ?r <- (Recomendacion (idVivienda ?idv) (puntos ?p) (razones $?rs))
   (test (not (member$ precio $?rs)))
   ?v <- (object (is-a Vivienda) (id ?idv) (precio ?pv))
   =>
   (if (or (<= ?pv ?max) (<= ?pv (+ ?max 150))) then
         (modify ?r (razones (create$ $?rs precio)))
   )
)

   ;; Score habitaciones
  (defrule score-habitaciones
      ?s <- (object (is-a Solicitante) (numHabitaciones ?min))
      ?r <- (Recomendacion (idVivienda ?idv) (puntos ?p) (razones $?rs))
      (test (not (member$ habitaciones $?rs)))
      ?v <- (object (is-a Vivienda) (id ?idv) (habitaciones ?h))
      =>
      (if (>= ?h ?min) then
          (modify ?r (razones (create$ $?rs habitaciones)))
      )
  )
  
   ;; Score accesibilidad buena
   (defrule score-accesibilidad-buena
      ?v <- (object (is-a Vivienda) (id ?idv) (accesibilidad buena))
      ?r <- (Recomendacion (idVivienda ?idv) (puntos ?p) (razones $?rs))
      (test (not (or (member$ accesibilidad-buena $?rs)
                     (member$ accesibilidad-regular $?rs))))
      =>
      (modify ?r (razones (create$ $?rs accesibilidad-buena)))
   )

   ;; Score accesibilidad regular
   (defrule score-accesibilidad-regular
      ?v <- (object (is-a Vivienda) (id ?idv) (accesibilidad regular))
      ?r <- (Recomendacion (idVivienda ?idv) (puntos ?p) (razones $?rs))
      (test (not (or (member$ accesibilidad-buena $?rs)
                     (member$ accesibilidad-regular $?rs))))
      =>
      (modify ?r (razones (create$ $?rs accesibilidad-regular)))
   )


  ;; Score mascotas
  (defrule score-mascotas
      ?s <- (object (is-a Solicitante) (mascotas yes))
      ?v <- (object (is-a Vivienda) (id ?idv) (mascotasPermitidas yes))
      ?r <- (Recomendacion (idVivienda ?idv) (puntos ?p) (razones $?rs))
      (test (not (member$ mascotas $?rs)))
      =>
      (modify ?r (razones (create$ $?rs mascotas)))
  )

   ;; Score amueblado
   (defrule score-amueblado
      ?s <- (object (is-a Solicitante) (amueblado yes))
      ?v <- (object (is-a Vivienda) (id ?idv) (amueblado yes))
      ?r <- (Recomendacion (idVivienda ?idv) (puntos ?p) (razones $?rs))
      (test (not (member$ amueblado $?rs)))
      =>
      (modify ?r (razones (create$ $?rs amueblado)))
   )

   ;; Score soleado
   (defrule score-soleado
      ?v <- (object (is-a Vivienda) (id ?idv) (soleado yes))
      ?r <- (Recomendacion (idVivienda ?idv) (puntos ?p) (razones $?rs))
      (test (not (member$ soleado $?rs)))
      =>
      (modify ?r (razones (create$ $?rs soleado)))
   )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 4. MÓDULO DE REFINAMIENTO (Etiquetas)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmodule REFINAMIENTO
   (import HEURISTICAS ?ALL)
   (import ABSTRACCION ?ALL)
   (import INPUT ?ALL)
   (export ?ALL)
)

;; Calcular puntuacion final

   (defrule calcular-puntuacion-final
      (declare (salience -10))
      ?s <- (object (is-a Solicitante))
      ?v <- (object (is-a Vivienda) (id ?idv))
      ?r <- (Recomendacion (idVivienda ?idv) (puntos 0) (razones $?rs&:(> (length$ $?rs) 0)))
      =>
      (bind ?puntuacion 0)

      (if (member$ precio $?rs) then
         (if (<= (send ?v get-precio) (send ?s get-precioMax))
               then (bind ?puntuacion (+ ?puntuacion 40))
               else (bind ?puntuacion (+ ?puntuacion 10))
         )
      )

      (if (member$ habitaciones $?rs) then (bind ?puntuacion (+ ?puntuacion 25)))
      (if (member$ accesibilidad-buena $?rs) then (bind ?puntuacion (+ ?puntuacion 25)))
      (if (member$ accesibilidad-regular $?rs) then (bind ?puntuacion (+ ?puntuacion 10)))
      (if (member$ mascotas $?rs) then (bind ?puntuacion (+ ?puntuacion 30)))
      (if (member$ amueblado $?rs) then (bind ?puntuacion (+ ?puntuacion 10)))
      (if (member$ soleado $?rs) then (bind ?puntuacion (+ ?puntuacion 5)))

      (modify ?r (puntos ?puntuacion))
   )

  (defrule etiqueta-muy-recomendable
    (declare (salience -20))
    ?r <- (Recomendacion (puntos ?p&:(> ?p 0)) (etiqueta none))
    (test (>= ?p 70))
    =>
    (modify ?r (etiqueta muy_recomendable))
  )

  (defrule etiqueta-adecuado
    (declare (salience -20))
    ?r <- (Recomendacion (puntos ?p&:(> ?p 0)) (etiqueta none))
    (test (and (>= ?p 40) (< ?p 70)))
    =>
    (modify ?r (etiqueta adecuado))
  )

  (defrule etiqueta-parcial
    (declare (salience -20))
    ?r <- (Recomendacion (puntos ?p&:(> ?p 0)) (etiqueta none))
    (test (< ?p 40))
    =>
    (modify ?r (etiqueta parcialmente_adecuado))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5. MÓDULO DE SALIDA (OUTPUT)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmodule SALIDA
   (import REFINAMIENTO ?ALL)
   (export ?ALL)
)

(defrule imprimir-resultados
   ?r <- (Recomendacion (etiqueta ?etq&~none) (puntos ?p) (razones $?rs))
   =>
   (printout t "----------------------------------" crlf)
   (printout t "Puntos: " ?p crlf)
   (printout t "Etiqueta: " ?etq crlf)
   (printout t "Razones: " $?rs crlf crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6. FLUJO DE CONTROL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule MAIN::inicio
   (declare (salience 100))
   =>
   (focus ABSTRACCION HEURISTICAS REFINAMIENTO SALIDA)
)