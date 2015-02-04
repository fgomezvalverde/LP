;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |progra scheme Genetico[V1]|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))


;;FUNCIONES QUE NECESITA EL PROGRAMA
(define signo (lambda()'(+ / - * expt mi-log)))
(define cantidad_mutacion (lambda () 17))
(define constantes (lambda () '(-10 -9 -8 -7 -6 -5 -4 -3 -2 -1 x x x x x x x x x x 1 2 3 4 5 6 7 8 9 10)))
(define rnd_poblacion_inicial (lambda () 6))

; OPERANDO DE LOGARITMO
(define mi-log
    (lambda (a B) 
      (/ (log a) (log B))))


;Algoritmo que crea los individios aleatorio de la primera poblacion
;Cantidad: el numero de poblacion que se desea
(define aleatorio
  (lambda (cantidad)
    (cond[(equal? cantidad 0) '() ]
         [else
          (append (list (aleatorio_aux (random (rnd_poblacion_inicial)))) (aleatorio (- cantidad 1)))]
         )))


;Ayuda a aleatorio a generar un solo invididuo
;numero_Rnd: ayuda al algorito a decidir si debe crear una rama nueva o terminar
(define aleatorio_aux
  (lambda (numero_Rnd)
    (cond [(equal? numero_Rnd 4)(list (list-ref (signo) (random (length (signo)) )) (aleatorio_aux (random (rnd_poblacion_inicial))) (aleatorio_aux (random (rnd_poblacion_inicial))))]
          [(equal? numero_Rnd 3)(list (list-ref (signo) (random (length (signo)) )) (list-ref (constantes) (random (length (constantes)) )) (aleatorio_aux (random (rnd_poblacion_inicial))))]
          [(equal? numero_Rnd 2)(list (list-ref (signo) (random (length (signo)) )) (aleatorio_aux (random (rnd_poblacion_inicial))) (list-ref (constantes) (random (length (constantes)))))]
          [else
           (list (list-ref (signo) (random (length (signo)) )) (list-ref (constantes) (random (length (constantes)))) (list-ref (constantes) (random (length (constantes)))))
           ])))



;lee el text para hagarrar la lista de evaluacion
;Archivo: nombre del archivo en string, tiene que ser donde esta el programa
 
(define lectura
  (lambda (archivo)  
    (call-with-input-file archivo
      (lambda (input-port)
        (second (lectura_aux input-port (read input-port)))))))

(define lectura_aux
  (lambda (arch flag)
    (cond[(eof-object? flag)'()]
         [else
          (append flag (lectura_aux arch (read arch)))
          ])))   

; FUNCIONES DE SELECCION ====================================================================================================================================

(define suma
  (lambda (lista)
   (cond((null? lista)0)
     (else(+ (car lista) (suma(cdr lista)))))))
     

(define Minimizar
  (lambda (lista0 lista)
  (cond((null? lista)1)
  (else(+(/(suma lista0) (car lista))(Minimizar lista0 (cdr lista)))))))

(define Minimax
 (lambda (lista0 lista)
    (cond((null? lista)(cons(list 0)'()))
     (else(cons(list(/(/(suma lista0) (car lista))(Minimizar lista0 lista0))(Minimax lista0 (cdr lista)))'())))))
 
(define Intervalo
   (lambda (x y)
     (append(list x y))))

(define ListaEsp
  (lambda (lista numero)
    (cond((zero? (caar lista))(append(list(list 0 0))))
         ((zero? numero)(append(list(Intervalo numero (+ numero (caar lista)))(ListaEsp (car(cdr(car lista))) (+ numero (caar lista))))))
         (else(list(Intervalo numero (+ numero (caar lista)))(ListaEsp (car(cdr(car lista))) (+ numero (caar lista))))))))


(define union
  (lambda (lista0 lista numero)
    (ListaEsp (Minimax lista0 lista) 0)))

(define rand
  (lambda (n)
  (/(random 1000) 1000.0)))  

(define partir
  (lambda (lista)
    (car lista)))

(define elegirAux
  (lambda (number lista) 
   (and (<= (car lista) number)(<= number (second lista))) ))

(define elegir
  (lambda (lista cont)
    (cond((zero? (car(cdr(car lista))))1)
         ((equal? (elegirAux (rand 1) (partir lista)) #t)cont)
         (else (elegir (car(cdr lista)) (+ cont 1))))))

(define menor
  (lambda (lista)
    (cond((zero? (caar lista))#f)
         (else (aux (caar lista) (car(cdr(car lista))))))))

(define aux
  (lambda (numero lista)
    (cond ((zero? (caar lista))numero)
          ((< (caar lista) numero)(aux (caar lista)(car(cdr(car lista)))))
          (else(aux numero (car(cdr(car lista))))))))

(define posicion
  (lambda (lista)
    (cond((zero? (caar lista))0)
    ((= (caar lista) (menor lista)) (+ 1 (posicion (car(cdr(car lista))))))
    (else(+ 1 (posicion (car(cdr(car lista)))))))))
  


 (define individuo
   (lambda (poblacion cantidad lista0 lista cont numero elitismo)
     (cond((zero? cantidad)1)
          ((equal? elitismo 1)(append(list(list-ref poblacion (- (posicion (Minimax lista0 lista)) 1)) (individuo poblacion (- cantidad 1) lista0 lista numero cont 0))))
          (else(append(list(list-ref poblacion (elegir (union lista0 lista numero) cont)) (individuo poblacion (- cantidad 1) lista0 lista numero cont 0)))))))
 
 


;FINAL DE FUNCIOES DE SELECCION




;hace el cruce , agarrando el hijo izquierdo de uno y el derecho del otro
;Pobla: poblacion actual
;Contador: cantidad de invidividuos a crear
(define cruce 
  (lambda (pobla contador)  ; contador representa la cantidad de cruces necesarios
    (cond[(equal? contador 1)(append pobla (list (aleatorio_aux (random 5)))) ]
         [else
          (cons (list (list-ref (signo) (random (length (signo)))) (list-ref (list-ref pobla (- contador 2)) 1) (list-ref (list-ref pobla (- contador 1)) 2)) (cruce pobla (- contador 1)))])))



;segun la posibilidad del cantidad_ mutacion es el porcentaje a acertar para mutar un individuo,si acerta el random se hace la mutacion sino sigue igual
;pobla: la poblacion actual
(define mutacion
  (lambda (pobla)
    (cond[(> (random 100) (cantidad_mutacion))pobla]
         [else ; se va agregar el signo y quitar el mismo
          (append (list (append (list (list-ref (signo) (random (length (signo))))) (remove (caar pobla) (car pobla)))) (cdr pobla))])))


;Evalua los individuos con la funcion de evaluacion
;Poblacion: los individuos actuales
;Evalua: funcion de evaluacion
(define evaluacion
  (lambda (poblacion evalua)
    (cond [(null? poblacion) '()]
          [else
           (append (list (evaluacion_aux (car poblacion) evalua)) (evaluacion (cdr poblacion) evalua))
           ])))

;Dado un individuo lo evalua con todos los puntos del evaluador y saca la diferencia de lo que deberia de dar resultado con la funcion evaluada
;Individuo: la funcion
;Evaluador: los puntos de la respuesta
(define evaluacion_aux
  (lambda (individuo evaluador)
    (cond [
           (null? evaluador) 0]
          [
           else
           (+(with-handlers (
                              [exn:fail:contract:arity? (lambda (v) 99999)])
                                                (with-handlers (
                                                [exn:fail:contract:divide-by-zero? (lambda (v) 99999)]
                                                [exn:fail:contract?  (lambda (v) 99999)]
                                                )(abs(- ((eval (append '(lambda (x)) individuo)) (caar evaluador)) (second (car evaluador)))))) (evaluacion_aux individuo (cdr evaluador)))
           ])))


(define seleccion
  (lambda (poblacion lista_evaluacion elitismo)
    (list-tail poblacion (- (round (/ (length poblacion) 2)) 1))
    ))
    


           
(define imprime_mejor
  (lambda (poblacion evaluador)
    (print (append '(lambda (x)) (list (list-ref poblacion (imprime_mejor_aux evaluador -1 0 0)))))
    (display "\n")
    ))

(define imprime_mejor_aux
  (lambda (evaluador menor posicion contador)
    (cond [(equal? contador (length evaluador)) posicion]
          [(equal? -1 menor) (imprime_mejor_aux evaluador (list-ref evaluador posicion) 0 (+ contador 1))]
          [else
           (cond [(< (list-ref evaluador contador) menor) (imprime_mejor_aux evaluador (list-ref evaluador contador) contador (+ contador 1))]
                 [else
                  (imprime_mejor_aux evaluador menor posicion (+ contador 1))
                  ])])))

;Pasa por todas las generacion hasta que se acabe el contador
(define ciclo_generaciones
  (lambda (generacion poblacion lista_evaluacion elitismo)
    (cond [(= generacion 0) 
           (print "El resultado final es: ")
           (imprime_mejor poblacion (evaluacion poblacion lista_evaluacion))  
           poblacion]
          [else
            (print generacion)
            (imprime_mejor poblacion (evaluacion poblacion lista_evaluacion)) 
            (ciclo_generaciones (- generacion 1) (mutacion (cruce (seleccion poblacion (evaluacion poblacion lista_evaluacion) elitismo) (- (round (/ (length poblacion) 2)) 1))) lista_evaluacion elitismo)]
          )))

;PRUEBAAA
(define ciclo_generaciones1
  (lambda (generacion poblacion lista_evaluacion elitismo)
              (cruce (seleccion poblacion (evaluacion poblacion lista_evaluacion) elitismo) (- (round (/ (length poblacion) 2)) 1))
          ))
   
;FUNCION DE ENTRADA
(define principal
  (lambda (generaciones poblacion nombre_Archivo elitismo)
    (ciclo_generaciones generaciones (aleatorio poblacion) (lectura nombre_Archivo) elitismo)
    ))




(principal 1000 10 "entradita.ucr" 'si)
;;DE PRUEBA
;(define temp (aleatorio 10))
;(evaluacion temp entrada)

;(imprime_mejor temp (evaluacion temp (lectura "entradita.ucr")))
;(define pru (mi-log (- (expt (* 10 (+ x 7)) (expt (+ -8 x) (/ -7 (/ #?# -8)))) x) -9))